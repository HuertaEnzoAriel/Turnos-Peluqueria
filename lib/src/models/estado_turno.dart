import 'package:flutter/material.dart';

enum EstadoTurno {
  pendiente('pendiente', 'Pendiente', Colors.orange),
  confirmado('confirmado', 'Confirmado', Colors.blue),
  completado('completado', 'Completado', Colors.green),
  cancelado('cancelado', 'Cancelado', Colors.red),
  ausente('ausente', 'Ausente', Colors.grey);

  final String valor;   // lo que se guarda en Supabase
  final String texto;   // lo que ve el usuario
  final Color color;
  const EstadoTurno(this.valor, this.texto, this.color);

  static EstadoTurno desde(String? valor) =>
      EstadoTurno.values.firstWhere((e) => e.valor == valor, orElse: () => pendiente);

  // Ícono del estado (se usa en el menú del admin)
  IconData get icono {
    switch (this) {
      case pendiente:
        return Icons.schedule;
      case confirmado:
        return Icons.check_circle_outline;
      case completado:
        return Icons.done_all;
      case cancelado:
        return Icons.cancel_outlined;
      case ausente:
        return Icons.person_off_outlined;
    }
  }

  // true si el turno todavía puede cambiar (no es un estado final)
  bool get activo => this == pendiente || this == confirmado;

  // A qué estados puede pasar desde este (lo usa el menú del admin)
  List<EstadoTurno> get siguientes {
    switch (this) {
      case pendiente:
        return [confirmado, cancelado];
      case confirmado:
        return [completado, ausente, cancelado];
      default:
        return [];   // completado, cancelado y ausente son finales
    }
  }
}
