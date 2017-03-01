require 'test_helper'

# Integration test that imitating user shopping process
class ShoppingCartTest < ActionDispatch::IntegrationTest
  def setup
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
