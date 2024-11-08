#!/bin/bash

# Параметры подключения к базе данных
DB_NAME="proga"
DB_USER="dmitrii"
DB_HOST="localhost"
DB_PORT="5432"

# Директория с SQL-скриптами миграций
MIGRATIONS_DIR="./migrations"

# Функция для выполнения SQL-скрипта из файла
run_sql() {
    local file_name="$1"
    psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -p "$DB_PORT" -f "$file_name"
}

# Функция для выполнения SQL-скрипта в виде строки
run_sql_c() {
    local sql_query="$1"
    psql -U "$DB_USER" -d "$DB_NAME" -h "$DB_HOST" -p "$DB_PORT" -c "$sql_query" -t
}

# Создание таблицы migrations, если она не существует
initialize_migrations_table() {
    run_sql_c "CREATE TABLE IF NOT EXISTS migrations (
        id SERIAL PRIMARY KEY,
        migration_name VARCHAR(255) UNIQUE NOT NULL,
        applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );"
}

# Получение списка уже примененных миграций
get_applied_migrations() {
    run_sql_c "SELECT migration_name FROM migrations;" | tr -d ' '
}

# Основная функция для применения миграций
apply_migrations() {
    # Инициализация таблицы migrations
    initialize_migrations_table

    # Получаем список примененных миграций
    local applied_migrations
    applied_migrations=$(get_applied_migrations)

    # Перебираем все SQL-файлы в директории миграций
    for migration_file in "$MIGRATIONS_DIR"/*.sql; do
        migration_name=$(basename "$migration_file")

        # Проверка, была ли миграция уже применена
        if echo "$applied_migrations" | grep -q "$migration_name"; then
            echo "Миграция $migration_name уже применена."
        else
            echo "Применение миграции $migration_name..."
            if run_sql "$migration_file"; then
                # Запись информации о примененной миграции
                run_sql_c "INSERT INTO migrations (migration_name) VALUES ('$(printf "%q" "$migration_name")');"
                echo "Миграция $migration_name успешно применена."
            else
                echo "Ошибка при применении миграции $migration_name."
                exit 1
            fi
        fi
    done
}

# Запуск применения миграций
apply_migrations
