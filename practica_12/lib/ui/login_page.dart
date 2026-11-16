import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../repositories/tarea_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authService = AuthService();
  final _repo = TareaRepository();
  bool _esRegistro = false;
  bool _cargando = false;
  bool _ocultarPass = true;

  Future<void> _enviar() async {
    setState(() => _cargando = true);
    try {
      if (_esRegistro) {
        await _authService.registrar(_emailCtrl.text, _passCtrl.text);
      } else {
        await _authService.iniciarSesion(_emailCtrl.text, _passCtrl.text);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _entrarConGoogle() async {
    setState(() => _cargando = true);
    try {
      await _authService.iniciarSesionConGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error con Google: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diario en la Nube - UNSAAC')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: _repo.leerSaludoInicial(),
              builder: (context, snapshot) {
                return Card(
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      snapshot.data ?? 'Conectando con Firestore...',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtrl,
              obscureText: _ocultarPass,
              decoration: InputDecoration(
                labelText: 'Contraseña (mín. 6 caracteres)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _ocultarPass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _ocultarPass = !_ocultarPass);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_cargando)
              const CircularProgressIndicator()
            else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _enviar,
                  child: Text(_esRegistro ? 'Registrarse' : 'Iniciar Sesión'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _entrarConGoogle,
                  icon: const Icon(Icons.account_circle_outlined),
                  label: const Text('Continuar con Google'),
                ),
              ),
            ],
            TextButton(
              onPressed: () => setState(() => _esRegistro = !_esRegistro),
              child: Text(_esRegistro
                  ? '¿Ya tienes cuenta? Inicia sesión'
                  : '¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}