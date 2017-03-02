require 'test_helper'

# Integration test that imitating user shopping process
class ShoppingCartTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  def setup
    super
    @ruby = products(:ruby)
    @qc35 = products(:qc35)
  end

  test 'add to cart' do
    get store_index_url
    assert_empty_cart

    # add to cart
    assert_difference 'LineItem.count', 1 do
      post line_items_path(product_id: @ruby.id)
    end

    assert_redirected_to store_index_url
    follow_redirect!
    assert_cart(current_item.cart)

    # add to cart ajax
    post line_items_path(product_id: @ruby.id), xhr: true
    assert_response :success
    assert_cart_jquery(current_item.cart)

    # empty cart
    assert_difference 'Cart.count', -1 do
      delete cart_path(current_item.cart)
    end

    assert_redirected_to store_index_url
    follow_redirect!
    assert_empty_cart
  end

  test 'empty cart ajax' do
    # empty cart ajax
    get store_index_url
    2.times do
      post line_items_path(product_id: @qc35.id)
    end

    2.times do
      post line_items_path(product_id: @ruby.id)
    end

    assert_redirected_to store_index_url
    follow_redirect!

    assert_difference 'Cart.count', -1 do
      delete cart_path(current_item.cart), xhr: true
    end
    assert_response :success
    assert_empty_cart_jquery
  end

  test 'buy a product' do
    get store_index_url
    assert_empty_cart

    # add to cart
    assert_difference 'LineItem.count', 1 do
      post line_items_path(product_id: @ruby.id)
    end

    assert_redirected_to store_index_url
    follow_redirect!
    assert_cart(current_item.cart)

    last_order_count = Order.count
    get new_order_url
    perform_enqueued_jobs do
      post orders_url, params: { 
        order: {
          name: 'ifournight',
          email: 'ifournight@gmail.com',
          address: 'mars',
          pay_type: Order.pay_types['Credit cart']
        }
      }

      assert_redirected_to store_index_url
      follow_redirect!

      assert_equal last_order_count + 1, Order.count

      order = Order.last
      mail = ActionMailer::Base.deliveries.last
      assert_equal 'ifournight@gmail.com', mail.to[0]
      assert_equal "Hi, #{order.name}, Thanks for the order.", mail.subject

      order.line_items.each do |item|
        assert_match item.product.title, mail.body.to_s
      end
    end
  end

  # test 'should create order result email delivered' do
  #   post line_items_url, params: {product_id: products(:ruby).id}
  #   assert_difference 'ActionMailer::Base.deliveries.size', 1 do
  #     post orders_url, params: { order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type } }      
  #   end

  #   email = ActionMailer::Base.deliveries.last
  #   assert_equal @order.email, email.to[0]
  # end

  private

  def current_item
    LineItem.order(updated_at: :desc).first
  end

  def assert_empty_cart
    # #cart div hidden
    assert_select "#cart.hidden"
    # render empty cart
    assert_select '#cart table', false
    assert_select_and_match '#cart h2', 'Your Cart', 0
  end

  def assert_cart(cart)
    cart.line_items.each do |item|
      assert_select "tr#line_item-#{item.id}", count: 1
      assert_select_and_match "tr#line_item-#{item.id} td.item_count", item.quantity.to_s
      assert_select "tr#line_item-#{item.id} td.item_title", item.product.title
      assert_select_and_match "tr#line_item-#{item.id} td.item_price", item.product.price.to_s
    end

    assert_select_and_match 'tr.total_line td.total_cell', cart.total_price.to_s
    assert_select 'form.button_to'
  end

  def assert_empty_cart_jquery
    assert_select_jquery :wrap, "#cart" do
      assert_empty_cart
    end
  end

  def assert_cart_jquery(cart)
    assert_select_jquery :wrap, "#cart" do
      assert_cart(cart)
    end
  end
end
