import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/supabase_services.dart';

class TurnosTab extends StatefulWidget {
  const TurnosTab({super.key});
  @override
  State<TurnosTab> createState() => _TurnosTabState();
}

class _TurnosTabState extends State<TurnosTab> {
  Future<bool> _confirmarBorrado(Map<String, dynamic> turno) async {
    final resultado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancelar turno'),
          content: Text('¿Seguro que querés borrar el turno de ${turno['nombre_cliente']}?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Sí, borrar'),
            ),
          ],
        );
      },
    );
    return resultado ?? false;   // null si se cierra tocando afuera
  }

  void _borrar(List<Map<String, dynamic>> turnos, int i) async {
    final id = turnos[i]['id'];
    // Se saca de la lista antes del await: Dismissible exige que el
    // elemento ya no esté cuando se vuelve a dibujar
    turnos.removeAt(i);
    try {
      await borrarTurno(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo borrar el turno: $e')),
      );
      setState(() {});   // vuelve a leer de Supabase para que reaparezca
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTurnos(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('No se pudieron cargar los turnos:\n${snapshot.error}'));
        }
        final turnos = snapshot.data!;
        if (turnos.isEmpty) {
          return Center(child: Text('Todavía no reservaste turnos'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: turnos.length,
          itemBuilder: (context, i) {
            final t = turnos[i];
            // Supabase devuelve la fecha como aaaa-mm-dd y la hora como hh:mm:ss
            final fecha = DateTime.parse(t['fecha']);
            final hora = t['hora'] == null ? '' : t['hora'].substring(0, 5);
            return Dismissible(
              key: Key(t['id'].toString()),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (direction) => _confirmarBorrado(t),
              onDismissed: (direction) => _borrar(turnos, i),
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColores.negro,
                    child: Icon(Icons.event, color: AppColores.dorado),
                  ),
                  title: Text(t['servicios']['nombre'], style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${t['nombre_cliente']} - ${fecha.day}/${fecha.month}/${fecha.year} $hora'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
