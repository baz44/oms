require "rails_helper"

RSpec.describe Order, :type => :model do
  describe ".create" do
    it "should allow me to create an order" do
      product = Product.create(name: "test", net_price: 22.33)
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3, net_price: 22.33)
      order = Order.create(line_items: [line_item_1])
      expect(Order.find(order)).to eql(order)
    end
  end

  describe ".update" do
    it "should allow me to update an order" do
      product = Product.create(name: "test", net_price: 22.33)
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
      order = Order.create(line_items: [line_item_1])
      order.line_items.first.quantity = 2
      order.save
      expect(order.line_items.first.quantity).to eql(2)
    end

    it "should not allow me to update an order if the status is not draft" do
      product = Product.create(name: "test", net_price: 22.33)
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
      order = Order.create(line_items: [line_item_1])
      status_transition = StatusTransition.create(order: order,
                                                event: "order placed",
                                                to: "placed")
      order.line_items.first.quantity = 2
      order.save
      expect(Order.find(order).status).to eql('placed')
    end
  end
end
