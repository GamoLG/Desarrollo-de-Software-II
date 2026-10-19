import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'producto_model.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  String? _categoriaSeleccionada;
  final List<String> _categorias = ['Electrónica', 'Hogar', 'Alimentos', 'Ropa'];

  final List<Producto> _productos = [];

  @override
  void dispose() {
    _nombreController.dispose();
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _agregarProducto() {
    if (_formKey.currentState!.validate()) {
      final nuevoProducto = Producto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreController.text.trim(),
        cantidad: int.parse(_cantidadController.text.trim()),
        precio: double.parse(_precioController.text.trim()),
        categoria: _categoriaSeleccionada!,
      );

      setState(() {
        _productos.insert(0, nuevoProducto);
      });

      _formKey.currentState!.reset();
      _nombreController.clear();
      _cantidadController.clear();
      _precioController.clear();
      setState(() {
        _categoriaSeleccionada = null;
      });

      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto agregado al inventario exitosamente'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _eliminarProducto(int index) {
    final productoEliminado = _productos[index];
    setState(() {
      _productos.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Se eliminó ${productoEliminado.nombre}'),
        action: SnackBarAction(
          label: 'Deshacer',
          onPressed: () {
            setState(() {
              _productos.insert(index, productoEliminado);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Productos'),
        backgroundColor: Colors.teal.shade800,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Parte Superior: Formulario de Registro
            Card(
              margin: const EdgeInsets.all(12.0),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Registrar Nuevo Producto',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Nombre
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre del Producto',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length <= 3) {
                            return 'Debe ser mayor a 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Cantidad y Precio en fila
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cantidadController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese cantidad';
                                }
                                final n = int.tryParse(value);
                                if (n == null || n <= 0) {
                                  return 'Debe ser > 0';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: _precioController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Precio Unitario (S/.)',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingrese precio';
                                }
                                final p = double.tryParse(value);
                                if (p == null || p <= 0) {
                                  return 'Precio > 0';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Dropdown Categoría
                      DropdownButtonFormField<String>(
                        value: _categoriaSeleccionada,
                        isDense: true,
                        decoration: const InputDecoration(
                          labelText: 'Categoría',
                          border: OutlineInputBorder(),
                        ),
                        items: _categorias.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _categoriaSeleccionada = val;
                          });
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Seleccione una categoría';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _agregarProducto,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar Producto'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Encabezado de la lista
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Productos Registrados (${_productos.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Total: S/. ${_productos.fold<double>(0, (sum, item) => sum + item.subtotal).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.teal.shade900,
                    ),
                  ),
                ],
              ),
            ),

            // Parte Inferior: Lista Dinámica Renderizada
            Expanded(
              child: _productos.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text('No hay productos agregados', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                  final prod = _productos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: Icon(Icons.shopping_bag, color: Colors.teal.shade800),
                      ),
                      title: Text(
                        prod.nombre,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Categoría: ${prod.categoria} | Cant: ${prod.cantidad} x S/. ${prod.precio.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'S/. ${prod.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.teal,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _eliminarProducto(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}