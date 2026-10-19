import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _aceptaTerminos = false;
  bool _terminosError = false;

  final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\W]{8,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _enviarFormulario() {
    setState(() {
      _terminosError = !_aceptaTerminos;
    });

    if (_formKey.currentState!.validate() && _aceptaTerminos) {
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registro exitoso para ${_emailController.text.trim()}'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Crear Cuenta',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingrese sus credenciales para registrarse en el sistema',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Campo Correo Electrónico
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El correo es obligatorio';
                    } else if (!_emailRegex.hasMatch(value.trim())) {
                      return 'Ingrese un formato de correo electrónico válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Contraseña
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es obligatoria';
                    } else if (!_passwordRegex.hasMatch(value)) {
                      return 'Debe tener mínimo 8 caracteres, incluir mayúscula, minúscula y número';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Confirmar Contraseña
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme su contraseña';
                    } else if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Términos y Condiciones
                Row(
                  children: [
                    Checkbox(
                      value: _aceptaTerminos,
                      onChanged: (bool? value) {
                        setState(() {
                          _aceptaTerminos = value ?? false;
                          if (_aceptaTerminos) _terminosError = false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text('Acepto los términos y condiciones de la plataforma'),
                    ),
                  ],
                ),
                if (_terminosError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Debe aceptar los términos y condiciones para continuar',
                      style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 24),

                // Botón Enviar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _enviarFormulario,
                  child: const Text('Registrar Cuenta', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}