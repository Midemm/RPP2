#!/bin/bash

# Проверяем, передан ли аргумент (имя файла)
if [ -z "$1" ]; then
  echo "Ошибка: файл не указан."
  exit 1
fi

# Проверяем, существует ли файл
if [ -f "$1" ]; then
  echo "Количество строк: $(wc -l < "$1")"
  echo "Количество слов: $(wc -w < "$1")"
  echo "Количество символов: $(wc -m < "$1")"
else
  echo "Ошибка: файл '$1' не существует."
  exit 1
fi