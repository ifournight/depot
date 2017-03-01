class Order < ApplicationRecord
  enum pay_types: {
    "Check"          => 0,
    "Credit cart"    => 1,
    "Purchase order" => 2
  }
  has_many :line_items, dependent: :destroy
  validates :name, :address, presence: true
  validates :pay_type, inclusion: pay_types.values
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: {maximum: 150},
                    format: { with: VALID_EMAIL_REGEX }

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end