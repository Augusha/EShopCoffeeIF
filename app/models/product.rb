class Product < ApplicationRecord

  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :cart_items, dependent: :destroy
end