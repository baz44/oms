require "rails_helper"

RSpec.describe "status transitions", :type => :request do
  describe "#post" do
    it "should allow me to create a status transition" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      post "/orders/#{order.id}/status_transitions", {format: :json, status_transition: {event: "order placed", to: "placed"}}
      expect(response.status).to eql(201)
      created_status_transition = JSON.parse(response.body)
      status_transition = StatusTransition.find(created_status_transition["id"])
      expect(status_transition.to).to eql('placed')
      expect(status_transition.from).to eql('draft')
      expect(status_transition.event).to eql("order placed")
    end

    it "should not allow me to create a status transition if the new status is not allowed" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      status_transition = StatusTransition.create(order: order,
                                                  event: "order placed",
                                                  to: "placed")

      post "/orders/#{order.id}/status_transitions", {format: :json, status_transition: {event: "order drafted again", to: "draft"}}
      expect(response.status).to eql(400)
    end
  end

  describe "#get" do
    it "should return all line items for a given order" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      status_transition_1 = StatusTransition.create(order: order,
                                                    event: "order placed",
                                                    to: "placed")
      status_transition_2 = StatusTransition.create(order: order,
                                                    event: "order paid",
                                                    to: "paid")


      get "/orders/#{order.id}/status_transitions", {format: :json}
      expect(response.status).to eql(200)
      expect(response.body).to eql([status_transition_1, status_transition_2].to_json)
    end
  end
end
