class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin?
      @orders = Order.all
    else
      @orders = current_user.orders
    end
  end

  def create
    @cart_items = CartItem.where(user_id: current_user.id)
    @total_price = @cart_items.sum { |item| item.product.price }

    @order = Order.new(
      user_id: current_user.id,
      address: params[:address],
      delivery_method: params[:delivery_method],
      payment_method: params[:payment_method],
      postal_code: params[:postal_code],
      credit_card_number: params[:credit_card_number],
      total: @total_price,
      status: 'pending'  # Статус за замовчуванням
    )


    if @order.save
      # Створити OrderItems для кожного товару в кошику
      @cart_items.each do |cart_item|
        OrderItem.create(
          order: @order,
          product: cart_item.product,
          quantity: 1
        )
      end

      # Очистити кошик
      @cart_items.destroy_all

      flash[:notice] = 'Замовлення успішно оформлено!'
      redirect_to root_path
    else
      flash[:alert] = 'Помилка оформлення замовлення. Перевірте введені дані.'
      puts @order.errors.full_messages
      render :new
    end
  end

  def destroy
    Rails.logger.debug "Params: #{params.inspect}"  # Перевірка параметрів
    @order = Order.find_by(id: params[:id])
    if @order
      if @order.destroy
        flash[:notice] = 'Замовлення успішно видалено!'
      else
        flash[:alert] = 'Не вдалося видалити замовлення.'
      end
    else
      flash[:alert] = 'Замовлення не знайдено.'
    end
    redirect_to orders_path
  end


  def update_status
    @order = Order.find_by(id: params[:id])
    if current_user.admin?
      if @order.update(status: params[:status])
        flash[:notice] = 'Статус замовлення оновлено.'
      else
        flash[:alert] = 'Помилка при оновленні статусу.'
      end
    else
      flash[:alert] = 'Ви не маєте прав для зміни статусу.'
    end
    redirect_to orders_path
  end

  private

  def calculate_total_price
    @cart_items.sum { |item| item.product.price * item.quantity }
  end

  def order_params
    params.require(:order).permit(:address, :delivery_method, :payment_method, :postal_code, :credit_card_number)
  end

end
