# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  def new_order_received
    OrderMailer.new_order_received(Order.first)
  end

  def order_shipped
    OrderMailer.order_shipped(Order.first)
  end
end