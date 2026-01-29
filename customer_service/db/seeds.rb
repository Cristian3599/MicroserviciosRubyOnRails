# Limpiar datos existentes para evitar duplicados al re-ejecutar
puts "Limpiando base de datos..."
Customer.destroy_all

puts "Insertando clientes de prueba..."

customers = [
  { customer_name: "Juan Perez", address: "Calle Falsa 123", orders_count: 0 },
  { customer_name: "Maria Garcia", address: "Avenida Siempre Viva 742", orders_count: 0 },
  { customer_name: "Carlos Gomez", address: "Carrera 10 # 20-30", orders_count: 0 }
]

customers.each do |attr|
  customer = Customer.create!(attr)
  puts "Creado: #{customer.customer_name}"
end

puts "¡Carga finalizada con éxito!"