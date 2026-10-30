import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// ---------------- LOGIN ----------------

// Devuelve null si entró bien, o el mensaje de error para mostrar
Future<String?> login(String email, String password) async {
  try {
    await supabase.auth.signInWithPassword(email: email, password: password);
    return null;
  } on AuthException catch (e) {
    if (e.code == 'invalid_credentials') {
      return 'Email o contraseña incorrectos';
    }
    return e.message;
  }
}

Future<void> logout() async {
  await supabase.auth.signOut();
}

// ---------------- SERVICIOS ----------------

Future<List<Map<String, dynamic>>> getServicios() async {
  return await supabase.from('servicios').select('id, nombre, precio, icono').order('id');
}

Future<void> addServicio(String nombre, int precio) async {
  await supabase.from('servicios').insert({'nombre': nombre, 'precio': precio});
}

Future<void> updateServicio(int id, String nombre, int precio) async {
  await supabase.from('servicios').update({'nombre': nombre, 'precio': precio}).eq('id', id);
}

// ---------------- TURNOS ----------------

// servicios(nombre) trae el nombre del servicio usando la relación servicio_id → servicios.id
Future<List<Map<String, dynamic>>> getTurnos() async {
  return await supabase
      .from('turnos')
      .select('id, nombre_cliente, fecha, hora, servicios(nombre)')
      .order('fecha')
      .order('hora');
}

// fecha en formato aaaa-mm-dd y hora en formato hh:mm
Future<void> addTurno(String nombreCliente, String fecha, String hora, int servicioId) async {
  await supabase.from('turnos').insert({
    'nombre_cliente': nombreCliente,
    'fecha': fecha,
    'hora': hora,
    'servicio_id': servicioId,
  });
}

Future<void> borrarTurno(int id) async {
  await supabase.from('turnos').delete().eq('id', id);
}
