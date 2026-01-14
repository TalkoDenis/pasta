#!/bin/bash

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "---------------------------------------"
echo "🚀 Starting Functional Tests (No Memory Check)"
echo "---------------------------------------"

echo "🧹 Cleaning up..."
rm -f ../bin/pasta

echo "🔨 Compiling..."
# УБРАЛИ флаг -gh (теперь компилируем без отладчика памяти)
# Оставили -B (полная пересборка) для надежности
mkdir -p ../bin
fpc ../src/pasta.lpr -Fu../src -o../bin/pasta -B > /dev/null

if [ $? -ne 0 ]; then
    echo -e "${RED}Compilation FAILED! Fix code errors first.${NC}"
    exit 1
fi
echo "Compilation OK."

run_test() {
    INPUT_CMD="$1"
    EXPECTED_OUTPUT="$2"
    
    # Запускаем программу и ловим весь вывод
    ACTUAL_OUTPUT=$(echo -e "$INPUT_CMD\nexit" | ../bin/pasta 2>&1)

    # Проверяем только наличие ожидаемой строки
    if echo "$ACTUAL_OUTPUT" | grep -Fq "$EXPECTED_OUTPUT"; then
        echo -e "${GREEN}[PASS]${NC} Test '$INPUT_CMD'"
    else
        echo -e "${RED}[FAIL] Logic Error${NC} in '$INPUT_CMD'"
        echo "   Expected to find: '$EXPECTED_OUTPUT'"
        echo "   Actual output:"
        echo "   ------------------"
        echo "$ACTUAL_OUTPUT"
        echo "   ------------------"
        exit 1
    fi
}

# --- СПИСОК ТЕСТОВ ---

# 1. Проверка минимума
run_test "min 10 5 20" "Minimum: 5.0000"

# 2. Проверка максимума
run_test "max 100 -50 200" "Maximum: 200.0000"

# 3. Проверка среднего
run_test "avg 1 2 3" "Average: 2.0000"

# 4. Проверка стандартного отклонения
run_test "std 4 8 0 -4 -8" "Std Dev: 6.3246"

# 5. Проверка защиты от дурака (пустой ввод)
run_test "min" "No data."

# 6. Проверка игнорирования текста (мусора)
run_test "min 10 hello 5 world" "Minimum: 5.0000"

echo "---------------------------------------"
echo -e "${GREEN}🎉 ALL LOGIC TESTS PASSED!${NC}"
exit 0
