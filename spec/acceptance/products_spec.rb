require "rails_helper"

RSpec.describe "products", :type => :request do
  describe "#post" do
    it "should allow me to create a product" do
      expect(Product.find_by_name("test")).to be_nil
      post "/products", {format: :json, product: {name: "test", net_price: 22.33}}
      expect(response.status).to eql(201)
      product = Product.find_by_name("test")
      expect(product.name).to eql("test")
      expect(product.net_price).to eql(22.33)
    end

    it "should not allow me to create a product if name is missing" do
      expect(Product.find_by_name("test")).to be_nil
      post "/products", {format: :json, product: {net_price: 22.33}}
      expect(response.status).to eql(400)
      expect(response.body).to eql({name: ["can't be blank"]}.to_json)
    end

    it "should not allow me to create a product if net_price is missing" do
      expect(Product.find_by_name("test")).to be_nil
      post "/products", {format: :json, product: {name: "test"}}
      expect(response.status).to eql(400)
      expect(response.body).to eql({net_price: ["can't be blank"]}.to_json)
    end

    it "should not allow me to create a product that already exists" do
      product = Product.create(name: "test", net_price: 22.33)
      post "/products", {format: :json, product: {name: "test", net_price: 14}}
      expect(response.status).to eql(400)
      expect(response.body).to eql({name: ["has already been taken"]}.to_json)
    end
  end

  describe "#get" do
    it "should return a single product" do
      product = Product.create(name: "test", net_price: 22.33)
      get "/products/#{product.id}", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql(product.to_json)
    end

    it "should return all products" do
      product_1 = Product.create(name: "test", net_price: 22.33)
      product_2 = Product.create(name: "test2", net_price: 33.33)
      get "/products", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql([product_1, product_2].to_json)
    end
  end

  describe "#put" do
     it "should allow me to update a product" do
      product = Product.create(name: "test", net_price: 22.33)
      put "/products/#{product.id}", {format: :json, product: {name: "test2", net_price: 15.22}}
      expect(response.status).to eql(200)
      body = JSON.parse(response.body)
      expect(body["name"]).to eql("test2")
      expect(body["net_price"]).to eql(15.22)
    end
  end

  describe "#delete" do
     it "should allow me to delete a product" do
      product = Product.create(name: "test", net_price: 22.33)
      expect(Product.find_by_name("test")).to eql(product)
      delete "/products/#{product.id}", {format: :json}
      expect(response.status).to eql(204)
      expect(Product.find_by_name("test")).to be_nil
    end

    it "should not allow me to delete a product if it belongs to an order" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      LineItem.create(product_id: product.id, quantity: 3, order: order)
      expect(Product.find_by_name("test")).to eql(product)
      delete "/products/#{product.id}", {format: :json}
      expect(response.status).to eql(400)
      expect(response.body).to eql({base: ["Cannot delete a product that has been added to orders."]}.to_json)
      expect(Product.find_by_name("test")).to eql(product)
    end
  end
end
