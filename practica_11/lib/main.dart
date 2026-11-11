import 'package:flutter/material.dart';
import 'inventory/exceptions.dart';
import 'inventory/inventory_manager.dart';
import 'inventory/models.dart';
import 'inventory/services.dart';

void main() {
  runApp(const Practica11App());
}

// Implementaciones locales para la vista del Ejercicio 1
class LocalStockService implements StockApiService {
  final Map<String, int> _stock = {'prod_001': 10, 'prod_002': 5, 'prod_003': 1};
  @override
  Future<int> getAvailableStock(String productId) async => _stock[productId] ?? 0;
}

class LocalLocationService implements LocationService {
  @override
  Future<double> getRegionalTaxRate() async => 0.18; // IGV 18%
}

class LocalCouponRepository implements CouponRepository {
  @override
  Future<Coupon?> findCoupon(String code) async {
    if (code.toUpperCase() == 'PROMO20') {
      return Coupon(
        code: 'PROMO20',
        discountPercent: 0.20,
        expirationDate: DateTime.now().add(const Duration(days: 30)),
      );
    }
    return null;
  }
}

class Practica11App extends StatelessWidget {
  const Practica11App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 11: Pruebas Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const RootNavigationScreen(),
    );
  }
}

class RootNavigationScreen extends StatefulWidget {
  const RootNavigationScreen({super.key});

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  int _currentIndex = 1; // Inicia en To-Do para la prueba E2E

  final List<Widget> _screens = const [
    InventoryScreen(),
    TodoListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        key: const ValueKey('nav_bar_root'),
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(
            key: ValueKey('tab_inventory'),
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventario (Ej 1)',
          ),
          NavigationDestination(
            key: ValueKey('tab_todo'),
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tareas E2E (Ej 2)',
          ),
        ],
      ),
    );
  }
}

// ==========================================
// VISTA EJERCICIO 1: INVENTARIO Y CARRITO
// ==========================================
class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late final InventoryManager _manager;
  final TextEditingController _couponController = TextEditingController();
  double _total = 0.0;
  String? _statusMessage;
  bool _isError = false;

  final List<Product> _catalog = const [
    Product(id: 'prod_001', name: 'Laptop Gaming TUF A15', price: 3800.0),
    Product(id: 'prod_002', name: 'Mouse Inalámbrico', price: 95.0),
    Product(id: 'prod_003', name: 'Monitor 144Hz IPS', price: 750.0),
  ];

  @override
  void initState() {
    super.initState();
    _manager = InventoryManager(
      stockApiService: LocalStockService(),
      locationService: LocalLocationService(),
      couponRepository: LocalCouponRepository(),
    );
  }

  Future<void> _addToCart(Product p) async {
    try {
      await _manager.addProduct(p, 1);
      final newTotal = await _manager.calculateTotal(couponCode: _couponController.text);
      setState(() {
        _total = newTotal;
        _isError = false;
        _statusMessage = 'Añadido: ${p.name} al carrito';
      });
    } on InsufficientStockException catch (e) {
      setState(() {
        _isError = true;
        _statusMessage = 'Stock insuficiente (Disponibles: ${e.available})';
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _statusMessage = e.toString();
      });
    }
  }

  Future<void> _applyCoupon() async {
    final newTotal = await _manager.calculateTotal(couponCode: _couponController.text);
    setState(() {
      _total = newTotal;
      _statusMessage = 'Cupón aplicado / actualizado';
      _isError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 1: Gestor de Inventario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _isError ? Colors.red.shade100 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage!,
                  style: TextStyle(color: _isError ? Colors.red.shade900 : Colors.green.shade900),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _catalog.length,
                itemBuilder: (ctx, i) {
                  final item = _catalog[i];
                  final qty = _manager.cart[item] ?? 0;
                  return Card(
                    child: ListTile(
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('S/ ${item.price.toStringAsFixed(2)} | En carrito: $qty'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.indigo),
                        onPressed: () => _addToCart(item),
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _couponController,
                            decoration: const InputDecoration(
                              labelText: 'Cupón (ej. PROMO20)',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _applyCoupon, child: const Text('Aplicar')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total (+18% IGV):', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('S/ ${_total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// VISTA EJERCICIO 2: TAREAS (TODO E2E)
// ==========================================
class TaskItem {
  final String id;
  final String title;
  final String priority;

  const TaskItem({
    required this.id,
    required this.title,
    required this.priority,
  });
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TaskItem> _tasks = [];

  void _showAddTaskDialog() {
    String description = '';
    String priority = 'Alta';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nueva Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const ValueKey('input_task_description'),
                decoration: const InputDecoration(labelText: 'Descripción de tarea'),
                onChanged: (val) => description = val,
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                key: const ValueKey('dropdown_priority'),
                value: priority,
                isExpanded: true,
                items: ['Baja', 'Media', 'Alta']
                    .map((p) => DropdownMenuItem(
                  key: ValueKey('priority_$p'),
                  value: p,
                  child: Text(p),
                ))
                    .toList(),
                onChanged: (newP) {
                  if (newP != null) setDialogState(() => priority = newP);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              key: const ValueKey('btn_save_task'),
              onPressed: () {
                if (description.trim().isNotEmpty) {
                  setState(() {
                    _tasks.add(TaskItem(
                      id: DateTime.now().toString(),
                      title: description.trim(),
                      priority: priority,
                    ));
                  });
                  Navigator.pop(dialogCtx);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 2: Gestor de Tareas')),
      body: _tasks.isEmpty
          ? const Center(
        child: Text(
          'No hay tareas pendientes',
          key: ValueKey('empty_tasks_view'),
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            key: ValueKey('task_item_$index'),
            title: Text(task.title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  key: ValueKey('chip_priority_${task.priority}'),
                  label: Text(task.priority),
                  backgroundColor: task.priority == 'Alta'
                      ? Colors.red.shade100
                      : Colors.blue.shade100,
                ),
                IconButton(
                  key: ValueKey('btn_delete_task_$index'),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => setState(() => _tasks.removeAt(index)),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const ValueKey('fab_add_task'),
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}