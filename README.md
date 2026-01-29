# Microservicios Order & Customer (Rails + RabbitMQ)

Este proyecto implementa una arquitectura de microservicios basada en eventos para gestionar pedidos y clientes. Utiliza Ruby on Rails, PostgreSQL como base de datos y RabbitMQ para la comunicación asincrónica.


## 🏗️ Arquitectura

- Order Service (Puerto 3000): Gestiona la creación de pedidos. Valida la existencia del cliente mediante una llamada HTTP sincrónica al Customer Service antes de guardar.

- Customer Service (Puerto 3001): Gestiona la información de clientes.

- RabbitMQ: Canal de mensajería asincrónica. Cuando se crea un pedido, el Order Service emite un evento que el Customer Service escucha para incrementar el contador de pedidos (orders_count).

## 🛠️ Requisitos Previos

- Docker y Docker Compose instalados.

- (Opcional) Un cliente de API como Postman o cURL.
## 🚀 Instalación y Configuración

1. **Clonar y Construir**
Desde la raíz del proyecto, construye las imágenes de Docker:

```bash
  docker compose build
```

2. **Levantar Servicios**
Inicia todos los contenedores en segundo plano:

```bash
  docker compose up -d
```

3. **Configurar Bases de Datos**
Ejecuta las migraciones y prepara el entorno para ambos servicios:

```bash
  # Order Service
  docker compose exec order-service bundle exec rails db:prepare

  # Customer Service
  docker compose exec customer-service bundle exec rails db:prepare
```

## 🧪 Ejecución de Pruebas (RSpec)
Los tests utilizan WebMock para simular llamadas HTTP y Mocks para RabbitMQ, asegurando que la suite sea independiente y rápida.

```bash
  #Cambiar entorno a test
  docker compose exec order-service bundle exec rails db:environment:set RAILS_ENV=test
  docker compose exec customer-service bundle exec rails db:environment:set RAILS_ENV=test

  # Ejecutar tests en Order Service
  docker compose exec order-service bundle exec rails db:prepare
  docker compose exec order-service bundle exec rspec

  # Ejecutar tests en Customer Service
  docker compose exec customer-service bundle exec rails db:prepare
  docker compose exec customer-service bundle exec rspec
```

## 🚦 Flujo de Trabajo Manual
**Crear un Pedido**  
Para probar la integración completa, realiza una petición POST:

```bash
  curl -X POST http://localhost:3000/orders \
     -H "Content-Type: application/json" \
     -d '{
       "order": {
         "customer_id": 1,
         "product_name": "Laptop Pro",
         "quantity": 1,
         "price": 1500.0,
         "status": "pending"
       }
     }'
```
**Monitorear Eventos**  
Puedes ver en tiempo real cómo el Worker procesa el incremento del contador:

```bash
  docker compose logs -f customer-worker
```