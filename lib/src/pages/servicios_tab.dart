import 'package:flutter/material.dart';
import '../app_theme.dart';

class ServiciosTab extends StatelessWidget {
  final String email;
  final List<Map<String, dynamic>> servicios;
  final Function(int) onEditar;
  const ServiciosTab({
    super.key,
    required this.email,
    required this.servicios,
    required this.onEditar,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: servicios.length + 1,   // +1 por el saludo de arriba
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bienvenido, $email', style: TextStyle(fontSize: 16, color: AppColores.negro)),
                Text('Tocá un servicio para editarlo', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        final s = servicios[i - 1];
        return Card(
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
            onTap: () => onEditar(i - 1),
          ),
        );
      },
    );
  }
}
