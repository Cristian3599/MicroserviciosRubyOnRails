class CustomersController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @customers = Customer.all
        render json: @customers, status: :ok
    rescue StandardError
        render json: { error: "Error interno del servidor" }, status: :internal_server_error
    end

    def show
        @customer = Customer.find(params[:id])
        render json: @customer, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Cliente no encontrado" }, status: :not_found
    rescue StandardError
        render json: { error: "Error interno del servidor" }, status: :internal_server_error
    end
end
