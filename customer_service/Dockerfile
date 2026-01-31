# 1. Usamos una versión ligera de Ruby
ARG RUBY_VERSION=3.4.8
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# 2. Instalamos dependencias del sistema
# - build-essential y libpq-dev son necesarios para la gema 'pg'
# - curl es útil para healthchecks
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 3. Configuramos el directorio de trabajo
WORKDIR /app

# 4. Instalamos las gemas
# Copiamos primero estos archivos para aprovechar el cache de Docker
COPY Gemfile Gemfile.lock ./
RUN bundle install

# 5. Copiamos el resto del código
COPY . .

# 6. Exponemos el puerto
EXPOSE 3001

# 7. Comando por defecto (será sobrescrito por docker-compose)
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
