import 'package:flutter/material.dart';
import '../app_theme.dart';

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
        Text('Bienvenido, $email', style: TextStyle(fontSize: 16, color: AppColores.negro)),
        SizedBox(height: 10),
        for (final s in _servicios)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColores.negro,
                child: Icon(s['icono'], color: AppColores.dorado),
              ),
              title: Text(s['nombre'], style: TextStyle(fontWeight: FontWeight.w600)),
              trailing: Text(
                '\$${s['precio']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColores.doradoOscuro,
                ),
              ),
            ),
          ),
      ],
    );
  }
}