require 'test_helper'

class ShoppingCartTest < ActionDispatch::IntegrationTest
  test 'add to cart' do
    get store_index_url
    ruby = products(:ruby)
    assert_difference 'LineItem.count', 1 do
      post line_items_path(product_id: ruby.id)
    end

    current_item = LineItem.where(product_id: ruby.id).order(created_at: :desc).first
    assert_redirected_to current_item.cart
    follow_redirect!

    current_item.cart.line_items.each do |item|
      assert_select "tr#line_item-#{item.id}", count: 1
      assert_select_and_match "tr#line_item-#{item.id} td.item_count", item.quantity.to_s
      assert_select "tr#line_item-#{item.id} td.item_title", item.product.title
      assert_select_and_match "tr#line_item-#{item.id} td.item_price", item.product.price.to_s
    end    

    assert_select_and_match 'tr.total_line td.total_cell', current_item.cart.total_price.to_s
  end

  test 'empty cart' do
    get store_index_url
    ruby = products(:ruby)
    assert_difference 'LineItem.count', 1 do
      post line_items_path(product_id: ruby.id)
    end

    current_item = LineItem.where(product_id: ruby.id).order(created_at: :desc).first
    assert_redirected_to current_item.cart
    follow_redirect!

    assert_difference 'Cart.count', -1 do
      delete cart_path(current_item.cart)
    end

    assert_redirected_to store_index_url
    assert_not flash.empty?   
  end

  test 'delete one item in cart' do
    get store_index_url
    ruby = products(:ruby)
    qc35 = products(:qc35)
    
    post line_items_path(product_id: ruby.id)
    2.times do
      get store_index_url
      post line_items_path(product_id: qc35.id)
    end

    current_item = LineItem.where(product_id: qc35.id).order(created_at: :desc).first
    current_cart = current_item.cart
    assert_redirected_to current_cart
    follow_redirect!

    assert_difference 'LineItem.count', -1 do
      delete line_item_path(current_item)
    end

    # assert_redirected_to current_cart
    assert_not flash.empty?   
  end
end
