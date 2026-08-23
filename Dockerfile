FROM ubuntu:22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    cmake \
    git \
    libboost-system-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    nlohmann-json3-dev \
    && rm -rf /var/lib/apt/lists/*

# Копирование проекта
COPY . /app
WORKDIR /app

# Сборка tgbot-cpp из исходников
RUN cd /tmp && \
    git clone https://github.com/reo7sp/tgbot-cpp.git && \
    cd tgbot-cpp && \
    cmake . && \
    make -j4 && \
    make install && \
    ldconfig

# Компиляция бота
RUN g++ -std=c++20 main.cpp \
    -I./include \
    -I/usr/local/include \
    -L/usr/local/lib \
    -lTgBot -lcurl -lssl -lcrypto -lpthread -lboost_system \
    -o bugulbot

# Запуск
CMD ["./bugulbot"]
