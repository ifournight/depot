class OrderMailer < ApplicationMailer
  default from: 'ifournight <depot@example.com>'
  def new_order_received(order)
      @order = order
      mail(
        to: order.email,
        subject: "Hi, #{order.name}, Thanks for the order."
      )
  end

  def order_shipped(order)
    @order = order
    mail(
      to: order.email,
      subject: "Order shipped."
    )
  end
end