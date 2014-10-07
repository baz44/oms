require "rails_helper"

RSpec.describe "orders", :type => :request do
  describe "#post" do
    it "should allow me to create a order" do
      post "/orders", {format: :json, order: {vat: 17.5, order_date: Date.today}}
      expect(response.status).to eql(201)
      created_order = JSON.parse(response.body)
      order = Order.find(created_order["id"])
      expect(order.vat).to eql(17.5)
    end
  end

  describe "#get" do
    it "should return a single order" do
      order = Order.create
      get "/orders/#{order.id}", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql(order.to_json)
    end

    it "should return all orders" do
      order_1 = Order.create
      order_2 = Order.create
      get "/orders", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql([order_1, order_2].to_json)
    end
  end

  describe "#put" do
    it "should allow me to update a order" do
      order = Order.create
      put "/orders/#{order.id}", {format: :json, order: {vat: 15}}
      expect(response.status).to eql(200)
      body = JSON.parse(response.body)
      expect(body["vat"]).to eql(15.0)
    end

    it "should not allow me to update an order if status is not draft" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3, order: order)
      status_transition = StatusTransition.create(order: order,
                                                  event: "order placed",
                                                  to: "placed")

      put "/orders/#{order.id}", {format: :json, order: {vat: 15}}
      expect(response.status).to eql(400)
      expect(response.body).to eql({base: ["Cannot update an order if order status is not draft"]}.to_json)
    end
  end

  describe "#delete" do
    it "should allow me to delete a order" do
      order = Order.create
      expect(Order.find(order.id)).to eql(order)
      delete "/orders/#{order.id}", {format: :json}
      expect(response.status).to eql(204)
    end
  end
end
