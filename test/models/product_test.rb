require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  # test "the truth" do
  #   assert true
  # end

  test "product attributes must not be empty" do
  	product = Product.new
  	assert product.invalid?
  	assert product.errors[:title].any?, "no title"
  	assert product.errors[:description].any?, "no description"
  	assert product.errors[:price].any?, "no price"
  	assert product.errors[:image_url].any?, "no image url"
  end

  test "product price must be positive" do
  	product = Product.new(title: 				"My Book Title",
  												description: 	"yyy",
  												image_url: 		"zzz.jpg")
  	product.price = -1
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"],
  		product.errors[:price]

  	product.price = 0
  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"],
  		product.errors[:price]

  	product.price = 1
  	assert product.valid?	
  end

  def new_product(image_url)
  	Product.new(title: 				"My Book Title",
  							description: 	"yyy",
  							price: 				1,
  							image_url: 		image_url)
  end

  test "image url" do
  	ok = %w{ 	fred.gif fred.jpg fred.png FRED.JPG FRED.jpg
  						http://a.b.c/x/y/z/fred.gif }
  	bad = %w{ fred.doc fred.gif/more fred.gif.more }

  	ok.each do |name|
  		assert new_product(name).valid?, "#{name} shouldn't be invalid"
  	end

  	bad.each do |name|
  		assert new_product(name).invalid?, "#{name} shouldn't be valid"
  	end
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title:        products(:ruby).title,
                          description:  products(:ruby).description,
                          price:        products(:ruby).price,
                          image_url:    products(:ruby).image_url)

    assert product.invalid?
    #assert_equal ["has already been taken"], product.errors[:title]
    assert_equal [I18n.translate('errors.messages.taken')],
                  product.errors[:title]
  end

end
