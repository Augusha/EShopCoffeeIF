# В контролері для кошика (наприклад, CartController)
class CartController < ApplicationController
  def show
    # Отримуємо всі товари користувача в кошику
    @cart_items = CartItem.where(user_id: current_user.id)
    @total_price = @cart_items.sum { |item| item.product.price } # Підраховуємо загальну суму
  end
end
