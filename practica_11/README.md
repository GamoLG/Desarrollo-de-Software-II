Guía Práctica N° 11: Pruebas en Flutter

Estrategias de Pruebas Unitarias, Integrales y Cobertura de Código para Entornos de Producción

Curso: Desarrollo de Software II

Institución: Universidad Nacional de San Antonio Abad del Cusco (UNSAAC)

Departamento: Departamento Académico de Ingeniería Informática y de Sistemas

Autor: GamoLG

📌 Descripción del Proyecto

Este repositorio contiene la implementación integral y profesional de la Guía Práctica N° 11, unificando pruebas unitarias con mocking, pruebas de extremo a extremo (E2E) sobre interfaces reactivas y la automatización del control de calidad en pipelines de Integración Continua (CI/CD) bajo estándares corporativos.

El proyecto cuenta con una interfaz unificada mediante NavigationBar que aloja tanto el módulo de gestión de inventarios como el módulo de gestión de proyectos To-Do, permitiendo la interoperabilidad sin colisión de dependencias ni de llaves de prueba.

🏗️ Arquitectura del Proyecto

practica_11/
├── .github/
│   └── workflows/
│       └── flutter_ci.yml          # Pipeline CI/CD automatizado en GitHub Actions
├── scripts/
│   └── check_coverage.sh           # Script bash de sanitización y control de umbral >= 85%
├── lib/
│   ├── main.dart                   # Interfaz unificada (NavigationBar, Carrito y To-Do)
│   └── inventory/                  # Módulo de lógica de negocio (Ejercicio 1)
│       ├── exceptions.dart         # Excepciones de dominio (InsufficientStockException)
│       ├── models.dart             # Modelos de datos inmutables (Product, Coupon)
│       ├── services.dart           # Contratos e interfaces abstractas para inyección
│       └── inventory_manager.dart  # Lógica del carrito, stock y cálculo impositivo
├── test/
│   └── inventory_manager_test.dart # Suite de pruebas unitarias aisladas con Mocktail
├── integration_test/
│   └── todo_flow_test.dart         # Suite de pruebas E2E automatizadas con ValueKey
├── pubspec.yaml                    # Configuración de dependencias y SDK
└── README.md                       # Documentación técnica y guía de sustentación


🛠️ Tecnologías y Dependencias

Flutter SDK: >=3.0.0 <4.0.0

flutter_test: Framework oficial de pruebas unitarias y de widgets.

mocktail (^1.0.4): Simulación de dependencias sin generación de código (build_runner), garantizando seguridad de tipos y control de nulos.

integration_test: Automatización de flujos completos en dispositivos físicos o emuladores.

LCOV / awk: Análisis, sanitización y cálculo matemático del porcentaje de cobertura neta.

GitHub Actions: Orquestación CI/CD sobre contenedores Ubuntu para validación en pull requests y pushes a main.

📋 Resumen de Ejercicios Implementados

1. Ejercicio Propuesto N° 1: Sistema de Gestión de Inventario (Unit Testing)

Objetivo: Aislar y certificar el comportamiento del motor de compras sin depender de infraestructura remota.

Servicios Mockeados:

StockApiService: Simulación de disponibilidad de stock remoto.

LocationService: Inyección de tasas impositivas dinámicas regionales (ej. IGV 18%).

CouponRepository: Validación de cupones promocionales con fechas de caducidad.

Casos Validados (7/7 tests en verde):

Incremento acumulativo de existencias de un ítem en el carrito.

Disparo de InsufficientStockException ante pedidos que exceden el stock remoto.

Validación de argumentos ante cantidades inválidas ($\le 0$).

Cálculo de totales agregando la tasa tributaria regional.

Descuento aplicado correctamente para cupones válidos (PROMO20).

Rechazo de cupones vencidos conservando el subtotal original.

Tolerancia y manejo ante cupones inexistentes (null).

2. Ejercicio Propuesto N° 2: Automatización E2E de Flujo de Tareas (Todo Application)

Objetivo: Simular la interacción real de un usuario en un dispositivo físico (M2003J15SC).

Puntos del flujo automatizado:

Constatación del estado inicial vacío (empty_tasks_view).

Interacción con el botón flotante (fab_add_task) para abrir el diálogo modal.

Ingreso de texto en el input (input_task_description) y selección de prioridad Alta en el selector desplegable (dropdown_priority).

Persistencia en memoria tras presionar guardar (btn_save_task) y verificación del chip (chip_priority_Alta).

Eliminación de la tarea mediante botón reactivo (btn_delete_task_0) y verificación del retorno al estado vacío.

3. Ejercicio Propuesto N° 3: Pipeline de Calidad de Cobertura y CI/CD

Objetivo: Bloquear automáticamente cualquier integración de código que incumpla los estándares mínimos corporativos ($\ge 85\%$).

Componentes:

check_coverage.sh: Script en Bash que ejecuta las pruebas con flag --coverage, purga archivos irrelevantes (main.dart, autogenerados .g.dart, .freezed.dart) mediante lcov --remove y evalúa el total de líneas instrumentadas (LF) contra las cubiertas (LH). Si la cobertura es menor al 85%, aborta con código de salida exit 1.

flutter_ci.yml: Pipeline configurado para ejecutarse en entornos ubuntu-latest, instalando Flutter, corriendo análisis estático (flutter analyze), evaluando el script de cobertura y subiendo el artefacto clean_lcov.info.

💻 Guía de Comandos para Sustentación

Para demostrar el funcionamiento frente al docente, ejecuta los siguientes comandos desde la terminal del proyecto:

1. Sustentación de Pruebas Unitarias con Mocktail (Ejercicio 1)

Ejecuta la suite con detalle extendido:

flutter test test/inventory_manager_test.dart -r expanded


Resultado esperado:

00:00 +0: loading test/inventory_manager_test.dart
00:00 +1: InventoryManager - addProduct: Debe agregar el producto y acumular stock...
00:00 +2: InventoryManager - addProduct: Debe lanzar InsufficientStockException...
00:00 +3: InventoryManager - addProduct: Debe lanzar ArgumentError si se ingresa...
00:00 +4: InventoryManager - calculateTotal: Calcula el total aplicando la tasa...
00:00 +5: InventoryManager - calculateTotal: Aplica descuento cuando el cupón es válido
00:00 +6: InventoryManager - calculateTotal: Ignora cupón vencido y aplica precio regular
00:00 +7: InventoryManager - calculateTotal: Maneja correctamente cupones inexistentes
00:00 +7: All tests passed!


2. Sustentación de Pruebas de Integración E2E (Ejercicio 2)

Verifica que el dispositivo móvil o emulador esté detectado:

flutter devices


Ejecuta la prueba automatizada extremo a extremo:

flutter test integration_test/todo_flow_test.dart


Resultado esperado:
La aplicación se abrirá de manera autónoma en el dispositivo, completará la creación de la tarea, verificará el chip de prioridad y removerá el registro, imprimiendo:

02:55 +1: All tests passed!


3. Sustentación de Cobertura de Código Local (Ejercicio 3)

Genera el reporte nativo LCOV:

flutter test --coverage


Ejecuta el script de sanitizado y cálculo del umbral:

bash scripts/check_coverage.sh


Resultado esperado:

========================================================
 [CI/CD] 1. Ejecutando pruebas y generando cobertura...
========================================================
========================================================
 [CI/CD] 2. Sanitizando lcov.info (excluyendo autogenerados)...
========================================================
========================================================
 [CI/CD] 3. Calculando métrica neta de cobertura...
========================================================
Líneas Instrumentadas (LF): 28
Líneas Cubiertas (LH):      28
Porcentaje de Cobertura:    100.00%
Umbral mínimo obligatorio:  85.0%
========================================================
 [PASSED] Cobertura aprobada (100.00% >= 85.0%).
========================================================


4. Sustentación del Pipeline CI/CD en GitHub Actions

Ingresa a la sección Actions del repositorio:
https://github.com/GamoLG/Desarrollo-de-Software-II/actions

Muestra la ejecución del flujo Flutter CI Quality Pipeline.

Demuestra que todos los pasos (Checkout, Setup Flutter, Pub Get, Analyze, LCOV, Check Coverage) cuentan con el check de aprobación ($\checkmark$).

Muestra la sección Artifacts con el archivo code-coverage-report disponible para auditoría externa.

🛡️ Buenas Prácticas Aplicadas

Principio de Inversión de Dependencias (DIP): Los componentes de negocio interactúan únicamente a través de contratos (abstract class), desacoplando la lógica de clientes HTTP reales o motores de almacenamiento.

Determinismo en Testing: Ninguna prueba unitaria realiza llamadas a la red ni consulta el reloj del sistema sin control, garantizando suites confiables y reproducibles.

Uso de ValueKeys en UI Testing: La suite E2E localiza los elementos mediante identificadores explícitos (ValueKey), evitando dependencias frágiles basadas en textos o posiciones relativas.

Calidad Continua Gatekeeping: Ningún código puede desplegarse o fusionarse si la cobertura cae por debajo del 85%, previniendo deuda técnica en etapas tempranas.
