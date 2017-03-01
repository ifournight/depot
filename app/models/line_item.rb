class LineItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product, optional: true
  belongs_to :order, optional: true

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def total_price
    product.price * quantity
  end
end
