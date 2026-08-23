FROM ubuntu:22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    libboost-all-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    nlohmann-json3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Копирование проекта
COPY . /app
WORKDIR /app

# Компиляция с правильными путями
RUN g++ -std=c++20 main.cpp \
    -I./include \
    -I/usr/include \
    -L/usr/lib \
    -lTgBot -lcurl -lssl -lcrypto -lpthread \
    -o bugulbot

# Запуск
CMD ["./bugulbot"]
