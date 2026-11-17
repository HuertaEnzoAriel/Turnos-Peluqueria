// Modelo de la tabla "servicios"
class Servicio {
  final int id;
  final String nombre;
  final int precio;
  final String icono;
  final DateTime? createdAt;

  Servicio({
    required this.id,
    required this.nombre,
    required this.precio,
    this.icono = 'content_cut',
    this.createdAt,
  });

  // Convierte una fila de Supabase (Map) en un Servicio
  factory Servicio.fromMap(Map<String, dynamic> map) {
    return Servicio(
      id: map['id'],
      nombre: map['nombre'],
      precio: map['precio'],
      icono: map['icono'] ?? 'content_cut',
      createdAt: map['created_at'] == null ? null : DateTime.parse(map['created_at']),
    );
  }

  // Map listo para insertar o actualizar (sin id ni created_at, los pone la base)
  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'precio': precio, 'icono': icono};
  }
}
