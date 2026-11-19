import 'servicio.dart';
import 'estado_turno.dart';


// Modelo de la tabla "turnos"
class Turno {
  final int id;
  final String nombreCliente;
  final DateTime fecha;
  final String hora; // formato hh:mm
  final int servicioId;
  final String? userId;
  final EstadoTurno estado;
  final DateTime? createdAt;
  final Servicio? servicio; // viene cuando la consulta incluye servicios(...)

  Turno({
    required this.id,
    required this.nombreCliente,
    required this.fecha,
    required this.hora,
    required this.servicioId,
    this.userId,
    this.createdAt,
    this.servicio,
    this.estado = EstadoTurno.pendiente,
  });

  // Convierte una fila de Supabase (Map) en un Turno
  factory Turno.fromMap(Map<String, dynamic> map) {
    // Supabase devuelve la hora como hh:mm:ss; se deja solo hh:mm
    final String? hora = map['hora'];
    return Turno(
      id: map['id'],
      nombreCliente: map['nombre_cliente'],
      fecha: DateTime.parse(map['fecha']),
      hora: hora == null ? '' : hora.substring(0, 5),
      servicioId: map['servicio_id'],
      userId: map['user_id'],
      createdAt: map['created_at'] == null ? null : DateTime.parse(map['created_at']),
      servicio: map['servicios'] == null ? null : Servicio.fromMap(map['servicios']),
      estado: EstadoTurno.desde(map['estado']),
    );
  }
}
