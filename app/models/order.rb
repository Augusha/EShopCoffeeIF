class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :status, inclusion: { in: ['pending', 'processed', 'shipped', 'delivered'], message: "%{value} is not a valid status" }, allow_nil: true
end
