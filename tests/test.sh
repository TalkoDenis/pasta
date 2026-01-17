#!/bin/bash

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "---------------------------------------"
echo "Starting Functional Tests (No Memory Check)"
echo "---------------------------------------"

echo "Cleaning up..."
rm -f ../bin/pasta

echo "Compiling..."
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

# --- БАЗОВЫЕ ТЕСТЫ ---
run_test "min 10 5 20" "Minimum: 5.0000"
run_test "max 100 -50 200" "Maximum: 200.0000"
run_test "avg 1 2 3" "Average: 2.0000"
run_test "std 4 8 0 -4 -8" "Std Dev: 6.3246"

# --- ТЕСТЫ МЕДИАНЫ ---
run_test "median 100 10 50" "Median:  50.0000"
run_test "median 1 2 3 4" "Median:  2.5000"
run_test "median 999" "Median:  999.0000"

# --- ТЕСТЫ ОШИБОК ---
# ИСПРАВЛЕНИЕ 2: Обновили ожидаемый текст ошибки
run_test "min" "Error: No data loaded."
run_test "median" "Error: No data loaded."

echo "---------------------------------------"
echo -e "${GREEN}ALL LOGIC TESTS PASSED!${NC}"
exit 0
