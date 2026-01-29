class MessagingService
  # Emite el evento de la creación del pedido a RabbitMQ
  def self.publish(payload)
    connection = Bunny.new(
      host: ENV["RABBITMQ_HOST"],
      port: ENV["RABBITMQ_PORT"],
      username: ENV["RABBITMQ_USER"],
      password: ENV["RABBITMQ_PASSWORD"],
      vhost: ENV["RABBITMQ_VHOST"]
    )
    connection.start

    channel = connection.create_channel
    queue = channel.queue("order_created_queue", durable: true)

    queue.publish(payload.to_json, persistent: true)

    connection.close
  end
end
