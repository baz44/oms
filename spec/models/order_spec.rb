require "rails_helper"

RSpec.describe Order, :type => :model do
  describe ".create" do
    it "should allow me to create an order" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      expect(Order.find(order)).to eql(order)
    end
  end

  describe ".update" do
    it "should allow me to update an order" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      tomorrow = Date.today + 1
      order.order_date = tomorrow
      order.save
      expect(Order.find(order).order_date).to eql(tomorrow)
    end

    it "should not allow me to update an order if the status is not draft" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3, order: order)
      status_transition = StatusTransition.create(order: order,
                                                  event: "order placed",
                                                  to: "placed")
      order.order_date = Date.today + 1
      order.save
      expect(Order.find(order).order_date).to eql(Date.today)
      expect(Order.find(order).status).to eql('placed')
    end
  end
end
