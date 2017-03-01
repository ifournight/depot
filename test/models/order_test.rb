require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    @valid = {
      name: 'ifournight',
      email: 'ifournight@gmail.com',
      address: 'Chengdu, China',
      pay_type: 2
    }
  end
  test "prescene validation" do
    order = Order.new(@valid)
    assert order.valid?

    order.name = nil
    assert order.invalid?

    order = Order.new(@valid)
    order.email = ''
    assert order.invalid?

    order = Order.new(@valid)
    order.address = ''
    assert order.invalid?
  end

  test "pay_type includsion validation" do
    valid_key_types = Order.pay_types.values
    invalid_key_types = [4, -1]

    order = Order.new(@valid)
    valid_key_types.each do |type|
      order.pay_type = type
      assert order.valid?
    end

    invalid_key_types.each do |type|
      order.pay_type = type
      assert order.invalid?
    end
  end

  test "email should check format validation" do
    order = Order.new(@valid)
    invalid_emails = %w[ifournight@gmail,com if#gmail.com he^qq.com]
    invalid_emails.each do |i_e|
      order.email = i_e
      assert order.invalid?
    end
  end
end
