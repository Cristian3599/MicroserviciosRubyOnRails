class CustomerService
  def self.get_customer(customer_id)
    require "httparty"

    url = "#{ENV['CUSTOMER_SERVICE_URL']}/customers/#{customer_id}"
    response = HTTParty.get(url)

    if response.success?
      response.parsed_response
    elsif response.code == 404
      { error: "Cliente no encontrado en el sistema", code: response.code }
    else
      { error: "Error al conectar con el microservicio", code: response.code }
    end

  rescue StandardError
    { error: "Error interno del servidor", code: :internal_server_error }
  end
end
