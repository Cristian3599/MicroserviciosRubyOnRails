require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "Orders", type: :request do
  let(:valid_params) {
    {
      order: { customer_id: 1, product_name: "Laptop", quantity: 1, price: 1200.0, status: "pending" }
    }
  }

  describe "POST /orders" do
    context "cuando el cliente existe en Customer Service" do
      before do
        # Simulamos la respuesta exitosa del Customer Service
        stub_request(:get, "#{ENV['CUSTOMER_SERVICE_URL']}/customers/1")
          .to_return(status: 200, body: { id: 1, customer_name: "Juan" }.to_json, headers: { 'Content-Type' => 'application/json' })

        # Simulamos que RabbitMQ recibe el mensaje
        allow(MessagingService).to receive(:publish).and_return(true)
      end

      it "crea un nuevo pedido y devuelve status 201" do
        expect {
          post orders_path, params: valid_params
        }.to change(Order, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "envía un evento a RabbitMQ" do
        post orders_path, params: valid_params
        expect(MessagingService).to have_received(:publish).with(hash_including(customer_id: 1))
      end
    end

    context "cuando el cliente NO existe" do
      before do
        stub_request(:get, "#{ENV['CUSTOMER_SERVICE_URL']}/customers/99")
          .to_return(status: 404)
      end

      it "no crea el pedido y devuelve error" do
        post orders_path, params: { order: { customer_id: 99, product_name: "Error" } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
