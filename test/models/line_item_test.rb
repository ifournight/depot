require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  def setup
    @valid = {
      cart_id: carts(:one).id,
      product_id: products(:ruby).id
    }
  end
  test "line item basic validation" do
    line_item = LineItem.new(@valid)
    assert line_item.valid?
  end

  test "quantity should >= 1" do
    line_item = LineItem.new(@valid)
    line_item.quantity = 1
    assert line_item.valid?

    line_item.quantity = 0
    assert line_item.invalid?
    assert line_item.errors[:quantity].any?

    line_item.quantity = -1
    assert line_item.invalid?
    assert line_item.errors[:quantity].any?
  end
end
