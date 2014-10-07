require "rails_helper"

RSpec.describe Product, :type => :model do
  describe ".create" do
    it "should allow me to create a product" do
      expect(Product.find_by_name("test")).to be_nil
      product = Product.create(name: "test", net_price: 22.33)
      expect(Product.find_by_name("test")).to eql(product)
    end

    it "shouldn't let me to create a product with a name that already exists" do
      Product.create(name: "test", net_price: 22.33)
      product = Product.create(name: "test", net_price: 22.33)
      expect(product.errors[:name]).to eql(["has already been taken"])
    end
  end

  describe ".update" do
    it "should allow me to update a product" do
      product = Product.create(name: "test", net_price: 22.33)
      product.update(name: "test-update", net_price: 33.22)

      updated_product = Product.find_by_name("test-update")
      expect(updated_product.net_price).to eql(33.22)
    end

    it "should not allow me to update a product name if already exist" do
      product = Product.create(name: "test", net_price: 22.33)
      Product.create(name: "test-exist", net_price: 22.33)
      expect(product.update(name: "test-exist", net_price: 33.22)).to eql(false)
      expect(product.errors[:name]).to eql(["has already been taken"])
    end
  end

  describe ".destroy" do
    it "should allow me to delete a product" do
      product = Product.create(name: "test", net_price: 22.33)
      expect(Product.find_by_name("test")).to eql(product)
      product.destroy
      expect(Product.find_by_name("test")).to be_nil
    end

    it "should not allow me to delete a product that exist in an order" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3, order: order)
      product.destroy
      expect(product.errors[:base]).to eql(["Cannot delete a product that has been added to orders."])
      expect(Product.find_by_name("test")).to eql(product)
    end
  end
end
