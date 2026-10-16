import 'package:flutter/material.dart';

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
            leading: Icon(Icons.event, color: Colors.indigo),
            title: Text(t['servicio']!),
            subtitle: Text('${t['nombre']} - ${t['fecha']}'),
          ),
        );
      },
    );
  }
}