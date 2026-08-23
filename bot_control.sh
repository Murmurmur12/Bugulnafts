#!/bin/bash

# ============================================
# Скрипт управления BugulBot
# ============================================

BOT_PATH="/Users/droidposledov/Documents/Bugulnafts/bugulbot"
PID_FILE="/tmp/bugulbot.pid"
LOG_FILE="/tmp/bugulbot.log"

# Функция запуска бота
start() {
    # Проверяем, не запущен ли уже бот
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "🤖 Бот уже запущен! PID: $PID"
            return 1
        else
            rm "$PID_FILE"
        fi
    fi
    
    # Проверяем существование бинарника
    if [ ! -f "$BOT_PATH" ]; then
        echo "❌ Ошибка: бинарник не найден в $BOT_PATH"
        echo "Сначала скомпилируй:"
        echo "cd ~/Documents/Bugulnafts"
        echo "clang++ -std=c++20 main.cpp -I./include -I/opt/homebrew/include -L/opt/homebrew/lib -lTgBot -lcurl -lssl -lcrypto -lpthread -o bugulbot"
        return 1
    fi
    
    echo "🚀 Запускаю BugulBot..."
    # Запускаем в фоне с nohup
    nohup "$BOT_PATH" > "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"
    echo "✅ Бот запущен! PID: $(cat $PID_FILE)"
    echo "📝 Логи: $LOG_FILE"
    echo "ℹ️ Для просмотра логов: ./bot_control.sh logs"
}

# Функция остановки бота
stop() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "🛑 Останавливаю бота (PID: $PID)..."
            kill "$PID"
            # Ждём немного
            sleep 1
            # Если процесс ещё жив, убиваем принудительно
            if kill -0 "$PID" 2>/dev/null; then
                echo "⚠️ Процесс не остановился, принудительно убиваю..."
                kill -9 "$PID"
            fi
            rm "$PID_FILE"
            echo "✅ Бот остановлен"
        else
            echo "⚠️ Бот не запущен, но PID-файл существует"
            rm "$PID_FILE"
        fi
    else
        echo "⚠️ Бот не запущен"
    fi
}

# Функция перезапуска
restart() {
    echo "🔄 Перезапуск бота..."
    stop
    sleep 2
    start
}

# Функция проверки статуса
status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "✅ Бот запущен!"
            echo "PID: $PID"
            echo "📝 Последние 5 строк лога:"
            echo "-----------------------------------"
            tail -n 5 "$LOG_FILE" 2>/dev/null || echo "(лог пуст)"
            echo "-----------------------------------"
        else
            echo "❌ Бот не запущен (PID-файл устарел)"
            rm "$PID_FILE"
        fi
    else
        echo "❌ Бот не запущен"
    fi
}

# Функция просмотра логов в реальном времени
logs() {
    if [ -f "$LOG_FILE" ]; then
        echo "📝 Просмотр логов (Ctrl+C для выхода):"
        echo "======================================="
        tail -f "$LOG_FILE"
    else
        echo "❌ Лог-файл не найден"
    fi
}

# Функция проверки здоровья
health() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "✅ Бот жив!"
            echo "PID: $PID"
            echo "Аптайм: $(ps -p $PID -o etime= 2>/dev/null | xargs)"
            echo "Память: $(ps -p $PID -o rss= 2>/dev/null | awk '{printf "%.1f MB", $1/1024}')"
        else
            echo "❌ Бот мёртв"
            rm "$PID_FILE"
        fi
    else
        echo "❌ Бот не запущен"
    fi
}

# Главное меню
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    logs)
        logs
        ;;
    health)
        health
        ;;
    *)
        echo "🤖 BugulBot - управление"
        echo "========================="
        echo "Использование: $0 {команда}"
        echo ""
        echo "Команды:"
        echo "  start    - запустить бота"
        echo "  stop     - остановить бота"
        echo "  restart  - перезапустить бота"
        echo "  status   - показать статус"
        echo "  logs     - смотреть логи в реальном времени"
        echo "  health   - проверить здоровье процесса"
        echo ""
        echo "Пример:"
        echo "  ./bot_control.sh start"
        exit 1
        ;;
esac

exit 0
