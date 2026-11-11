#!/usr/bin/env bash

# Salir inmediatamente si ocurre un error inesperado
set -e

MIN_COVERAGE=85.0

echo "========================================================"
echo " [CI/CD] 1. Ejecutando pruebas y generando cobertura..."
echo "========================================================"
flutter test --coverage

if [ ! -f "coverage/lcov.info" ]; then
    echo "ERROR: No se encontró el archivo coverage/lcov.info."
    exit 1
fi

echo "========================================================"
echo " [CI/CD] 2. Sanitizando lcov.info (excluyendo autogenerados)..."
echo "========================================================"

# Verificar e instalar lcov si no está disponible (entorno Linux/CI)
if ! command -v lcov &> /dev/null; then
    echo "Instalando herramienta lcov..."
    sudo apt-get update && sudo apt-get install -y lcov
fi

# Eliminar archivos no evaluables de lógica pura según guía
lcov --ignore-errors unused,empty --remove coverage/lcov.info \
    'lib/main.dart' \
    'lib/*/*.g.dart' \
    'lib/*/*.freezed.dart' \
    'lib/generated/*' \
    -o coverage/clean_lcov.info

echo "========================================================"
echo " [CI/CD] 3. Calculando métrica neta de cobertura..."
echo "========================================================"

# Extraer total de líneas encontradas (LF) y líneas golpeadas (LH)
TOTAL_LF=$(grep -E '^LF:' coverage/clean_lcov.info | awk -F: '{sum += $2} END {print sum}')
TOTAL_LH=$(grep -E '^LH:' coverage/clean_lcov.info | awk -F: '{sum += $2} END {print sum}')

if [ -z "$TOTAL_LF" ] || [ "$TOTAL_LF" -eq 0 ]; then
    echo "ERROR: No se detectaron líneas evaluables de código."
    exit 1
fi

# Calcular porcentaje neto con awk
COVERAGE=$(awk -v lh="$TOTAL_LH" -v lf="$TOTAL_LF" 'BEGIN { printf "%.2f", (lh / lf) * 100 }')

echo "Líneas Instrumentadas (LF): $TOTAL_LF"
echo "Líneas Cubiertas (LH):      $TOTAL_LH"
echo "Porcentaje de Cobertura:    $COVERAGE%"
echo "Umbral mínimo obligatorio:  $MIN_COVERAGE%"

# Evaluar umbral
IS_PASS=$(awk -v cov="$COVERAGE" -v min="$MIN_COVERAGE" 'BEGIN { print (cov >= min) ? 1 : 0 }')

if [ "$IS_PASS" -eq 1 ]; then
    echo "========================================================"
    echo " [PASSED] Cobertura aprobada ($COVERAGE% >= $MIN_COVERAGE%)."
    echo "========================================================"
    exit 0
else
    echo "========================================================"
    echo " [FAILED] Cobertura insuficiente: $COVERAGE% (Mínimo: $MIN_COVERAGE%). Bloqueando pipeline."
    echo "========================================================"
    exit 1
fi