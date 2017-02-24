require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @product = products(:ruby)
    @create = {
      title: 'Product3',
      description: "Ruby is fun!",
      image_url: 'MyImage.jpg',
      price: 99.9
    }
  end

  test "should get index" do
    get products_url
    assert_response :success
    product_count = Product.count
    assert_select 'table tr[class^="list_line_"]', product_count
    products.each do |product|
      assert_select image_tag(product.image_url)
      assert_select 'a[href=?]', edit_product_path(product)
      assert_select 'a[href=?]', product_path(product)
      assert_select 'a[href=? data-method="delete"]', product_path(product)
    end
    assert_select 'a[href=?]', new_product_path
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: @create }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { description: @product.description, image_url: @product.image_url, price: @product.price, title: @product.title } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
