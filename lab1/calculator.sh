#!/bin/bash

# Проверяем, что переданы все три аргумента
if [ "$#" -ne 3 ]; then
  echo "Ошибка: требуется три аргумента. Формат: ./calculator.sh число оператор число"
  exit 1
fi

# Присваиваем переменные для удобства
num1=$1
operator=$2
num2=$3

case $operator in
  +)
    result=$(awk "BEGIN {print $num1 + $num2}")
    ;;
  -)
    result=$(awk "BEGIN {print $num1 - $num2}")
    ;;
  \*)
    result=$(awk "BEGIN {print $num1 * $num2}")
    ;;
  /)
    if [ "$num2" -eq 0 ]; then
      echo "Ошибка: деление на ноль."
      exit 1
    fi
    result=$(awk "BEGIN {print $num1 / $num2}")
    ;;
  *)
    echo "Ошибка: недопустимый оператор. Используйте +, -, *, или /."
    exit 1
    ;;
esac

echo "Результат: $result"