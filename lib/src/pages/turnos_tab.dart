import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/turno.dart';
import '../services/supabase_services.dart';
import '../models/estado_turno.dart';


class TurnosTab extends StatefulWidget {
  const TurnosTab({super.key});
  @override
  State<TurnosTab> createState() => _TurnosTabState();
}

class _TurnosTabState extends State<TurnosTab> {
  bool _admin = false;
  // Los turnos se guardan en el estado (en vez de un FutureBuilder) para
  // poder recargarlos sin mostrar el spinner y que la lista no parpadee
  List<Turno>? _turnos;
  Object? _error;

  @override
  void initState() {
    super.initState();
    esAdmin().then((valor) {
      if (mounted) setState(() => _admin = valor);
    }).catchError((_) {});
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final turnos = await getTurnos();
      if (!mounted) return;
      setState(() {
        _turnos = turnos;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<bool> _confirmarBorrado(Turno turno) async {
    final resultado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancelar turno'),
          content: Text('¿Seguro que querés cancelar el turno de ${turno.nombreCliente}?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );
    return resultado ?? false;   // null si se cierra tocando afuera
  }

  Future<void> _cambiarEstado(Turno turno, EstadoTurno estado) async {
    try {
      await cambiarEstadoTurno(turno.id, estado);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cambiar el estado: $e')),
      );
    }
    await _cargar();   // vuelve a leer de Supabase
  }

  // Chip con el estado. Si el admin puede cambiarlo, al tocarlo abre el menú
  Widget _chipEstado(Turno t) {
    final estado = t.estado;
    final puedeCambiar = _admin && estado.siguientes.isNotEmpty;
    // Estilo suave: fondo del color con poca opacidad y texto del color, sin borde
    final chip = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: estado.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            estado.texto,
            style: TextStyle(color: estado.color, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          if (puedeCambiar) Icon(Icons.keyboard_arrow_down, color: estado.color, size: 16),
        ],
      ),
    );
    if (!puedeCambiar) return chip;
    return PopupMenuButton<EstadoTurno>(
      tooltip: 'Cambiar estado',
      onSelected: (nuevo) => _cambiarEstado(t, nuevo),
      color: Colors.white,
      elevation: 6,
      offset: Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (context) => [
        for (final e in estado.siguientes)
          PopupMenuItem(
            value: e,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: e.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(e.icono, color: e.color, size: 16),
                ),
                SizedBox(width: 12),
                Text(e.texto, style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
      child: chip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final turnos = _turnos;
    if (turnos == null) {
      if (_error != null) {
        return Center(child: Text('No se pudieron cargar los turnos:\n$_error'));
      }
      return Center(child: CircularProgressIndicator());
    }
    if (turnos.isEmpty) {
      // La base solo devuelve los turnos del usuario (el admin ve todos)
      return Center(child: Text('Todavía no hay turnos reservados'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: turnos.length,
      itemBuilder: (context, i) {
        final t = turnos[i];
        final fecha = t.fecha;
        final hora = t.hora;
        final card = Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColores.negro,
              child: Icon(Icons.event, color: AppColores.dorado),
            ),
            title: Text(t.servicio!.nombre, style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${t.nombreCliente} - ${fecha.day}/${fecha.month}/${fecha.year} $hora'),
            trailing: _chipEstado(t),
          ),
        );

        // Solo se puede deslizar para cancelar si el turno sigue activo
        if (!t.estado.activo) return card;

        return Dismissible(
          key: ValueKey('${t.id}-${t.estado.valor}'),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (direction) async {
            final ok = await _confirmarBorrado(t);
            if (ok) _cambiarEstado(t, EstadoTurno.cancelado);
            return false;   // no se saca de la lista a mano, se recarga desde Supabase
          },
          background: Container(
            color: Colors.redAccent,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.cancel, color: Colors.white),
          ),
          child: card,
        );
      },
    );
  }
}
