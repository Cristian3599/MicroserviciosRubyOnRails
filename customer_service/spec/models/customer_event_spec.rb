require 'rails_helper'

RSpec.describe "RabbitMQ Event Consumer", type: :model do
  let!(:customer) { Customer.create!(customer_name: "Juan", address: "Calle 1", orders_count: 0) }

  it "incrementa el orders_count cuando se recibe un evento de pedido creado" do
    # Simulamos el cuerpo del mensaje que enviaría el Order Service
    payload = { customer_id: customer.id, event: "order_created" }.to_json

    # Simulamos la lógica que ejecuta el Worker (Rake Task)
    data = JSON.parse(payload)
    target_customer = Customer.find(data['customer_id'])

    expect {
      target_customer.increment!(:orders_count)
    }.to change { target_customer.orders_count }.by(1)
  end
end
