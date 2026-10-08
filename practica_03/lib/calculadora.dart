import 'package:flutter/material.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _display = '0';
  double? _primerOperando;
  String? _operador;
  bool _esperandoSegundo = false;

  Color get _colorDisplay {
    final double? valor = double.tryParse(_display);
    if (valor == null || valor == 0) return Colors.grey.shade700;
    if (valor > 0) return Colors.blue.shade700;
    return Colors.red.shade700;
  }

  void _onNumero(String digito) {
    setState(() {
      if (_esperandoSegundo) {
        _display = digito == '.' ? '0.' : digito;
        _esperandoSegundo = false;
      } else {
        if (digito == '.') {
          if (!_display.contains('.')) _display += '.';
        } else {
          _display = (_display == '0') ? digito : _display + digito;
        }
      }
    });
  }

  void _onOperacion(String op) {
    setState(() {
      final double? actual = double.tryParse(_display);
      if (actual != null) {
        if (_primerOperando == null) {
          _primerOperando = actual;
        } else if (_operador != null && !_esperandoSegundo) {
          _calcular();
        }
      }
      _operador = op;
      _esperandoSegundo = true;
    });
  }

  void _calcular() {
    if (_primerOperando == null || _operador == null) return;
    final double segundo = double.tryParse(_display) ?? 0;
    double res = 0;

    switch (_operador) {
      case '+': res = _primerOperando! + segundo; break;
      case '-': res = _primerOperando! - segundo; break;
      case '×': res = _primerOperando! * segundo; break;
      case '÷': res = segundo != 0 ? _primerOperando! / segundo : double.nan; break;
    }

    setState(() {
      _display = res.isNaN ? 'Error' : res.toString().replaceAll(RegExp(r'\.0$'), '');
      _primerOperando = res.isNaN ? null : res;
      _operador = null;
      _esperandoSegundo = true;
    });
  }

  void _limpiar() {
    setState(() {
      _display = '0';
      _primerOperando = null;
      _operador = null;
      _esperandoSegundo = false;
    });
  }

  Widget _boton(String txt, {Color? bg, Color? fg, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg ?? Colors.grey.shade200,
          foregroundColor: fg ?? Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(txt, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> btns = [
      'C', '÷', '×', '-',
      '7', '8', '9', '+',
      '4', '5', '6', '=',
      '1', '2', '3', '0',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio Propuesto: Calculadora'),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: _colorDisplay),
                child: Text(_display),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: btns.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, i) {
                  final t = btns[i];
                  if (t == 'C') return _boton(t, bg: Colors.red.shade400, fg: Colors.white, onTap: _limpiar);
                  if (t == '=') return _boton(t, bg: Colors.blue.shade600, fg: Colors.white, onTap: _calcular);
                  if (['+', '-', '×', '÷'].contains(t)) {
                    return _boton(t, bg: Colors.orange.shade400, fg: Colors.white, onTap: () => _onOperacion(t));
                  }
                  return _boton(t, onTap: () => _onNumero(t));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}