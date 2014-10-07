require "rails_helper"

RSpec.describe "line_items", :type => :request do
  describe "#post" do
    it "should allow me to create a line_item" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      post "/orders/#{order.id}/line_items", {format: :json,
                                              line_item: {product_id: product.id,
                                                          quantity: 3,
                                                          net_price: 22.33}}
      expect(response.status).to eql(201)
      created_line_item = JSON.parse(response.body)
      line_item = LineItem.find(created_line_item["id"])
      expect(line_item.quantity).to eql(3)
      expect(line_item.net_price).to eql(22.33)
      expect(line_item.order_id).to eql(order.id)
      expect(line_item.product_id).to eql(product.id)
    end
  end

  describe "#get" do
    it "should return a single line_item" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      get "/orders/#{order.id}/line_items/#{line_item.id}", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql(line_item.to_json)
    end

    it "should return all line items for a given order" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3, order: order)
      line_item_2 = LineItem.create(product_id: product.id, quantity: 3, order: order)
      get "/orders/#{order.id}/line_items", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql([line_item_1, line_item_2].to_json)
    end
  end

  describe "#put" do
    it "should allow me to update a line item" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      put "/orders/#{order.id}/line_items/#{line_item.id}", {format: :json, line_item: {net_price: 15}}
      expect(response.status).to eql(200)
      body = JSON.parse(response.body)
      expect(body["net_price"]).to eql(15.0)
    end

    it "should not allow me to update an line_item if order status is not draft" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      status_transition = StatusTransition.create(order: order,
                                                  event: "order placed",
                                                  to: "placed")

      put "/orders/#{order.id}/line_items/#{line_item.id}", {format: :json, line_item: {net_price: 15}}
      expect(response.status).to eql(400)
      expect(response.body).to eql({base: ["Cannot update an order if order status is not draft"]}.to_json)
    end
  end

  describe "#delete" do
    it "should allow me to delete a line item" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      expect(LineItem.find(line_item.id)).to eql(line_item)
      delete "/orders/#{order.id}/line_items/#{line_item.id}", {format: :json}
      expect(response.status).to eql(204)
    end
  end
end
