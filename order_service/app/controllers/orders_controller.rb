class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @orders = Order.all
    render json: @orders, status: :ok
  rescue StandardError
    render json: { error: "Error interno del servidor" }, status: :internal_server_error
  end

  def create
    customer_data = CustomerService.get_customer(order_params[:customer_id])

    # Se valida si hubo un error al consultar el cliente
    if customer_data.key?(:error)
      status = customer_data[:code] || :bad_gateway
      render json: customer_data, status: status
    else
      # Si todo esta bien se crea el pedido
      @order = Order.create(order_params)
      if @order.save!
        MessagingService.publish({ customer_id: @order.customer_id, event: "order_created" })
        render json: customer_data, status: :created
      else
        render json: { error: @order.errors.full_messages }, status: :unprocesable_entity
      end
    end

  rescue StandardError
    render json: { error: "Error interno del servidor" }, status: :internal_server_error
  end

  def order_params
    params.require(:order).permit(:customer_id, :product_name, :quantity, :price, :status)
  end
end
