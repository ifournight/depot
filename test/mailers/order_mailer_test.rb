require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  def setup
    @order = orders(:one)
  end
  test 'new order' do
    email = OrderMailer.new_order(@order)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [@order.email], email.to
    assert_equal "Hi, #{@order.name}, Thanks for the order.", email.subject

    assert_match @order.name, email.body.to_s
    @order.line_items.each do |item|
      assert_match item.product.title, email.body.to_s
      assert_match item.product.price.to_s, email.body.to_s
    end
  end
end
