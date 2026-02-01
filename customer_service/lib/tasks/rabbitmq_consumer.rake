namespace :rabbitmq do
  desc "Escuchar eventos de creación de pedidos"
  task consume: :environment do
    connection = Bunny.new(
      host: ENV["RABBITMQ_HOST"],
      port: ENV["RABBITMQ_PORT"],
      username: ENV["RABBITMQ_USER"],
      password: ENV["RABBITMQ_PASSWORD"],
      vhost: ENV["RABBITMQ_VHOST"],
      tls: ENV["RABBITMQ_TLS"],
    )
    connection.start

    channel = connection.create_channel
    queue = channel.queue("order_created_queue", durable: true)

    queue.subscribe(manual_ack: true, block: true) do |_delivery_info, _properties, body|
      data = JSON.parse(body)

      # Lógica para incrementar el contador
      customer = Customer.find_by(id: data["customer_id"])
      if customer
        customer.increment!(:orders_count)
      end
    end
  rescue Bunny::TCPConnectionFailed
    sleep 5
    retry
  end
end
