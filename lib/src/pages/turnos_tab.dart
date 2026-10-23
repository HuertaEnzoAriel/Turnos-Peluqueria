import 'package:flutter/material.dart';
import '../app_theme.dart';

class TurnosTab extends StatelessWidget {
  final List<Map<String, String>> turnos;
  const TurnosTab({super.key, required this.turnos});

  @override
  Widget build(BuildContext context) {
    if (turnos.isEmpty) {
      return Center(child: Text('Todavía no reservaste turnos'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: turnos.length,
      itemBuilder: (context, i) {
        final t = turnos[i];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColores.negro,
              child: Icon(Icons.event, color: AppColores.dorado),
            ),
            title: Text(t['servicio']!, style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${t['nombre']} - ${t['fecha']}'),
          ),
        );
      },
    );
  }
}