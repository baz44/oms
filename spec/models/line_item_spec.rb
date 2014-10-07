require "rails_helper"

RSpec.describe LineItem, :type => :model do
  describe ".create" do
    it "should allow me to create a line item" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      expect(LineItem.all.size).to eql(0)
      line_item = LineItem.create(product_id: product.id, quantity: 3, net_price: 22.33, order: order)
      expect(LineItem.find(line_item)).to eql(line_item)
    end

    it "should set the net_price of the line item if none given" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      expect(LineItem.all.size).to eql(0)
      created_line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      line_item = LineItem.find(created_line_item)
      expect(line_item.net_price).to eql(66.99)
    end

    it "should not let me add a line item without quantity" do
      product = Product.create(name: "test", net_price: 22.33)
      expect(LineItem.all.size).to eql(0)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, order: order)
      expect(line_item.errors[:quantity]).to eql(["can't be blank"])
      expect(LineItem.all.size).to eql(0)
    end
  end

  describe ".update" do
    it "should allow me to update a line item" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item = LineItem.create(product_id: product.id, quantity: 3, order: order)
      line_item.quantity = 4
      line_item.save
      updated_line_item = LineItem.find(line_item)
      expect(updated_line_item.quantity).to eql(4)
    end

    it "should not allow me to update a line item if the status of the order is not draft" do
      product = Product.create(name: "test", net_price: 22.33)
      order = Order.create
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3, order: order)
      order.update(line_items: [line_item_1])
      status_transition = StatusTransition.create(order: order,
                                                  event: "order placed",
                                                  to: "placed")
      line_item_1.quantity = 2
      line_item_1.save
      expect(Order.find(order).status).to eql('placed')
      expect(line_item_1.reload.quantity).to eql(3)
    end
  end
end
