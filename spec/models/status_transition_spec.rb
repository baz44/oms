require "rails_helper"

RSpec.describe StatusTransition, :type => :model do
  describe ".create" do
    it "should allow me to create an status transition and changing the order status" do
      product = Product.create(name: "test", net_price: 22.33)
      line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
      order = Order.create(line_items: [line_item_1])
      status_transition_created = StatusTransition.create(order: order,
                                                          event: "order placed",
                                                          to: "placed")
      status_transition = StatusTransition.find(status_transition_created)
      expect(status_transition.from).to eql('draft')
    end

    context "status transition is valid" do
      it "should change the status from draft to placed" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        status_transition = StatusTransition.create(order: order,
                                                  event: "order placed",
                                                  to: "placed")
        expect(Order.find(order).status).to eql('placed')
        expect(status_transition.from).to eql('draft')
      end

      it "should change the status from placed to paid" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        StatusTransition.create(order: order,
                                event: "order placed",
                                to: "placed")
        status_transition = StatusTransition.create(order: order,
                                event: "order paid",
                                to: "paid")

        expect(Order.find(order).status).to eql('paid')
        expect(status_transition.from).to eql('placed')
      end

      it "should change the status from placed to canceled" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        StatusTransition.create(order: order,
                                event: "order placed",
                                to: "placed")
        status_transition = StatusTransition.create(order: order,
                                event: "order canceled",
                                to: "canceled")

        expect(Order.find(order).status).to eql('canceled')
        expect(status_transition.from).to eql('placed')
      end

      it "should change the status from draft to canceled" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        status_transition = StatusTransition.create(order: order,
                                event: "order canceled",
                                to: "canceled")

        expect(Order.find(order).status).to eql('canceled')
        expect(status_transition.from).to eql('draft')
      end

      it "should not allow the cancelation of an order if no reason is given" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        status_transition = StatusTransition.create(order: order,
                                                    to: "canceled")

        order = Order.find(order)
        expect(order.status).to eql('draft')
        expect(order.status_transitions.size).to eql(0)
      end
    end

    context "status transition is invalid" do
      it "should not change the status from draft to paid" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        StatusTransition.create(order: order,
                                event: "order paid",
                                to: "paid")
        order = Order.find(order)
        expect(order.status).to eql('draft')
        expect(order.status_transitions).to be_empty
      end

      it "should not change the status from placed to draft" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        status_transition = StatusTransition.create(order: order,
                                event: "order placed",
                                to: "placed")
        StatusTransition.create(order: order,
                                event: "order paid",
                                to: "draft")

        order = Order.find(order)
        expect(order.status).to eql('placed')
        expect(order.status_transitions.size).to eql(1)
        expect(order.status_transitions.first).to eql(status_transition)
      end

      it "should not change the status from paid to canceled" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        StatusTransition.create(order: order,
                                event: "order placed",
                                to: "placed")
        status_transition = StatusTransition.create(order: order,
                                event: "order paid",
                                to: "paid")
        StatusTransition.create(order: order,
                                event: "order canceled",
                                to: "canceled")

        order = Order.find(order)
        expect(order.status).to eql('paid')
        expect(order.status_transitions.size).to eql(2)
        expect(order.status_transitions.last).to eql(status_transition)
      end

      it "should not change the status from canceled to draft" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        StatusTransition.create(order: order,
                                event: "order placed",
                                to: "placed")
        status_transition = StatusTransition.create(order: order,
                                event: "order canceled",
                                to: "canceled")
        StatusTransition.create(order: order,
                                event: "new order",
                                to: "draft")

        order = Order.find(order)
        expect(order.status).to eql('canceled')
        expect(order.status_transitions.size).to eql(2)
        expect(order.status_transitions.last).to eql(status_transition)
      end

      it "should not change the status from paid to draft" do
        product = Product.create(name: "test", net_price: 22.33)
        line_item_1 = LineItem.create(product_id: product.id, quantity: 3)
        order = Order.create(line_items: [line_item_1])
        StatusTransition.create(order: order,
                                event: "order placed",
                                to: "placed")
        status_transition = StatusTransition.create(order: order,
                                event: "order paid",
                                to: "paid")
        StatusTransition.create(order: order,
                                event: "new order",
                                to: "draft")

        order = Order.find(order)
        expect(order.status).to eql('paid')
        expect(order.status_transitions.size).to eql(2)
        expect(order.status_transitions.last).to eql(status_transition)
      end
    end
  end
end
