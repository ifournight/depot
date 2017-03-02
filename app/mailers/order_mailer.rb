class OrderMailer < ApplicationMailer

def new_order(order)
    @order = order
    mail(
      to: order.email,
      subject: "Hi, #{order.name}, Thanks for the order."
    )
  end
end
