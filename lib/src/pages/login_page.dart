import 'package:flutter/material.dart';
import '../app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  void _ingresar() {
    if (_email.trim().isEmpty || _password.isEmpty) {
      _alertaError('Completá el email y la contraseña');
    } else if (_email.trim() != 'admin@peluqueria.com' || _password != '1234') {
      _alertaError('Email o contraseña incorrectos');
    } else {
      Navigator.pushReplacementNamed(context, 'home', arguments: _email.trim());
    }
  }

  void _alertaError(String mensaje) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColores.negro,
              child: Icon(Icons.content_cut, size: 60, color: AppColores.dorado),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'PELUQUERÍA',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: AppColores.negro,
            ),
          ),
          Text(
            'Cortes · Barba · Color',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColores.doradoOscuro),
          ),
          SizedBox(height: 40),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            onChanged: (valor) {
              setState(() {
                _email = valor;
              });
            },
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
            ),
            onChanged: (valor) {
              setState(() {
                _password = valor;
              });
            },
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _ingresar,
              child: Text('Ingresar'),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Demo: admin@peluqueria.com / 1234',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}