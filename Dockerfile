FROM ubuntu:22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    g++ \
    libboost-all-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    nlohmann-json3-dev \
    && rm -rf /var/lib/apt/lists/*

# Копирование проекта
COPY . /app
WORKDIR /app

# Компиляция
RUN g++ -std=c++20 main.cpp -I./include -lTgBot -lcurl -lssl -lcrypto -lpthread -o bugulbot

# Запуск
CMD ["./bugulbot"]
