import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../services/supabase_services.dart';

class CrearCuentaPage extends StatefulWidget {
  const CrearCuentaPage({super.key});
  @override
  State<CrearCuentaPage> createState() => _CrearCuentaPageState();
}

class _CrearCuentaPageState extends State<CrearCuentaPage> {
  String _email = '';
  String _password = '';
  String _repetir = '';

  void _crear() async {
    final email = _email.trim();
    if (email.isEmpty || _password.isEmpty || _repetir.isEmpty) {
      _alerta('Error', 'Completá todos los campos');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _alerta('Error', 'El email no es válido');
      return;
    }
    if (_password.length < 6) {
      _alerta('Error', 'La contraseña debe tener al menos 6 caracteres');
      return;
    }
    if (_password != _repetir) {
      _alerta('Error', 'Las contraseñas no coinciden');
      return;
    }
    try {
      final error = await registrarse(email, _password);
      if (!mounted) return;
      if (error != null) {
        _alerta('Error', error);
        return;
      }
      // Si Supabase no pide confirmar el email, la cuenta ya queda logueada
      if (supabase.auth.currentSession != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          'home',
          (route) => false,
          arguments: email,
        );
      } else {
        await _alerta(
          'Cuenta creada',
          'Revisá tu email para confirmar la cuenta y después ingresá.',
        );
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      _alerta('Error', 'No se pudo conectar con el servidor:\n$e');
    }
  }

  Future<void> _alerta(String titulo, String mensaje) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _decoracion(String label, IconData icono) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: label,
      prefixIcon: Icon(icono),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear cuenta')),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColores.negro,
              child: Icon(Icons.person_add, size: 50, color: AppColores.dorado),
            ),
          ),
          SizedBox(height: 30),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: _decoracion('Email', Icons.email),
            onChanged: (valor) => _email = valor,
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: _decoracion('Contraseña', Icons.lock),
            onChanged: (valor) => _password = valor,
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: _decoracion('Repetir contraseña', Icons.lock_outline),
            onChanged: (valor) => _repetir = valor,
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _crear,
              child: Text('Crear cuenta'),
            ),
          ),
        ],
      ),
    );
  }
}
