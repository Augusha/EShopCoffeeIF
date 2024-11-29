class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    @cart_item = CartItem.create(user_id: current_user.id, product_id: product.id)
    redirect_to root_path, notice: "Товар додано до кошика"
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    if @cart_item.user_id == current_user.id
      @cart_item.destroy
      redirect_to root_path, notice: "Товар видалено з кошика"
    else
      redirect_to root_path, alert: "Ви не можете видалити цей товар"
    end
  end
end
