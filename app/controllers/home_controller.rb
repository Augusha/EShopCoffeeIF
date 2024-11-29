class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all # отримуємо всі продукти
    @cart_items = CartItem.where(user_id: current_user.id) # припускаємо, що є модель CartItem
    @total_price = @cart_items.joins(:product).sum('products.price')

  end
end
