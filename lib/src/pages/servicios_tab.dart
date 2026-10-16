import 'package:flutter/material.dart';

class ServiciosTab extends StatelessWidget {
  final String email;
  ServiciosTab({super.key, required this.email});

  final List<Map<String, dynamic>> _servicios = [
    {'nombre': 'Corte de pelo', 'precio': 8000, 'icono': Icons.content_cut},
    {'nombre': 'Barba', 'precio': 5000, 'icono': Icons.face},
    {'nombre': 'Color', 'precio': 15000, 'icono': Icons.palette},
    {'nombre': 'Peinado', 'precio': 7000, 'icono': Icons.brush},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text('Bienvenido, $email', style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        for (final s in _servicios)
          Card(
            child: ListTile(
              leading: Icon(s['icono'], color: Colors.indigo),
              title: Text(s['nombre']),
              trailing: Text('\$${s['precio']}'),
            ),
          ),
      ],
    );
  }
}