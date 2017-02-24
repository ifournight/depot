require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @create = {
      title: 'Product3',
      description: "Ruby is fun!",
      image_url: 'MyImage.jpg',
      price: 99.9
    }
  end

  test 'product attributes presence validations' do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test 'product title uniqueness' do
    product = Product.new(@create)
    assert product.valid?
    product.title = products(:ruby).title
    assert product.invalid?
    assert_equal product.errors[:title], [I18n.translate('errors.messages.taken')]
  end

  test 'product img url' do
    ok = ['image.jpg', 'http://image_provider.com/image1_2_3.png?middle', 'cat.jpg']
    bad = ['imagejpg', 'catpng', 'img.xml']

    product = Product.new(@create)
    assert product.valid?
    ok.each do |image_url|
      product.image_url = image_url
      assert product.valid?, "#`{image_url}` should be valid"
    end    
    bad.each do |image_url|
      product.image_url = image_url
      assert product.invalid?, "'#{image_url}' should be invalid"
    end    
  end

  test 'product price equal than 0' do
    product = Product.new(@create)
    assert product.valid?
    product.price = 0
    assert product.invalid?, product.errors[:price]
  end
end
