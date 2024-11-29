class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:new, :create, :destroy]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      redirect_to products_path, alert: 'Продукт не знайдено!'
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path, notice: 'Продукт успішно додано!'
    else
      render :new
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to root_path, notice: 'Продукт успішно видалено!'
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :image_url, :category, :manufacturer, :release_date, :warranty_period)
  end

  def require_admin
    redirect_to root_path, alert: 'Тільки адміністратори можуть додавати або видаляти продукти!' unless current_user.admin?
  end

  def current_user_review
    @current_user_review ||= @product.reviews.find_by(user: current_user)
  end
  helper_method :current_user_review

end
