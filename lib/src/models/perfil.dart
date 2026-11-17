// Modelo de la tabla "perfiles"
class Perfil {
  final String id;
  final String? email;
  final String rol; // 'admin' o 'cliente'
  final String? nombre;
  final String? apellido;

  Perfil({
    required this.id,
    this.email,
    required this.rol,
    this.nombre,
    this.apellido,
  });

  // Convierte una fila de Supabase (Map) en un Perfil
  factory Perfil.fromMap(Map<String, dynamic> map) {
    return Perfil(
      id: map['id'],
      email: map['email'],
      rol: map['rol'],
      nombre: map['nombre'],
      apellido: map['apellido'],
    );
  }

  bool get esAdmin => rol == 'admin';

  // "Nombre Apellido", o null si no tiene nombre (cuentas viejas)
  String? get nombreCompleto {
    if (nombre == null) return null;
    return '$nombre ${apellido ?? ''}'.trim();
  }
}
