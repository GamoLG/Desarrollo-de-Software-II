import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:practica_11/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Flujo E2E - Automatización de Tareas (Todo Application):', () {
    testWidgets(
      'Valida: Vista vacía -> Agregar Tarea con Prioridad -> Eliminar y confirmar vacío',
          (WidgetTester tester) async {
        // 1. Iniciar la aplicación y constatar lista inicial vacía
        app.main();
        await tester.pumpAndSettle();

        expect(find.byKey(const ValueKey('empty_tasks_view')), findsOneWidget);
        expect(find.text('No hay tareas pendientes'), findsOneWidget);

        // 2. Tappear sobre el FloatingActionButton (fab_add_task)
        final fab = find.byKey(const ValueKey('fab_add_task'));
        expect(fab, findsOneWidget);
        await tester.tap(fab);
        await tester.pumpAndSettle();

        // 3. Ingresar descripción y asignar prioridad 'Alta'
        final descInput = find.byKey(const ValueKey('input_task_description'));
        expect(descInput, findsOneWidget);
        await tester.enterText(descInput, 'Entregar reporte de QA a producción');
        await tester.pumpAndSettle();

        final dropdown = find.byKey(const ValueKey('dropdown_priority'));
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        final priorityOption = find.byKey(const ValueKey('priority_Alta')).last;
        await tester.tap(priorityOption);
        await tester.pumpAndSettle();

        // 4. Presionar guardar (btn_save_task) y verificar renderizado con chip
        final btnSave = find.byKey(const ValueKey('btn_save_task'));
        await tester.tap(btnSave);
        await tester.pumpAndSettle();

        expect(find.text('Entregar reporte de QA a producción'), findsOneWidget);
        expect(find.byKey(const ValueKey('chip_priority_Alta')), findsOneWidget);

        // 5. Presionar botón de eliminación y confirmar retorno al estado vacío
        final btnDelete = find.byKey(const ValueKey('btn_delete_task_0'));
        expect(btnDelete, findsOneWidget);
        await tester.tap(btnDelete);
        await tester.pumpAndSettle();

        expect(find.text('Entregar reporte de QA a producción'), findsNothing);
        expect(find.byKey(const ValueKey('empty_tasks_view')), findsOneWidget);
      },
    );
  });
}