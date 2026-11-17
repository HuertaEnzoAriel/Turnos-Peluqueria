import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notificaciones_service.dart';

final supabase = Supabase.instance.client;

// ---------------- SESIÓN ----------------

// La sesión se cierra tras 5 minutos sin actividad del usuario
const int minutosSesion = 5;

// Última vez que el usuario tocó la pantalla (en memoria, para no leer el
// disco en cada toque) y última vez que se guardó en el dispositivo
DateTime? _ultimaActividad;
DateTime _ultimoGuardado = DateTime.fromMillisecondsSinceEpoch(0);

Future<void> _guardarActividad(DateTime momento) async {
  _ultimoGuardado = momento;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('ultima_actividad', momento.millisecondsSinceEpoch);
}

// Se llama al iniciar sesión. mantener = el switch "Mantener sesión iniciada"
// del login: si es false, la sesión se cierra al cerrar la app.
Future<void> guardarInicioSesion(bool mantener) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('mantener_sesion', mantener);
  _ultimaActividad = DateTime.now();
  await _guardarActividad(_ultimaActividad!);
}

// Se llama en cada toque o gesto del usuario (ver main.dart).
// Guarda en el dispositivo como mucho una vez cada 10 segundos.
void registrarActividad() {
  if (supabase.auth.currentSession == null) return;
  final ahora = DateTime.now();
  _ultimaActividad = ahora;
  if (ahora.difference(_ultimoGuardado).inSeconds >= 10) {
    _guardarActividad(ahora);
  }
}

// Cuánto falta para que venza la sesión (Duration.zero si ya venció o no hay datos)
Future<Duration> tiempoRestanteSesion() async {
  var ultima = _ultimaActividad;
  if (ultima == null) {
    // App recién abierta: se lee la última actividad guardada
    final prefs = await SharedPreferences.getInstance();
    final guardada = prefs.getInt('ultima_actividad');
    if (guardada == null) return Duration.zero;
    ultima = DateTime.fromMillisecondsSinceEpoch(guardada);
  }
  final vence = ultima.add(Duration(minutes: minutosSesion));
  final restante = vence.difference(DateTime.now());
  return restante.isNegative ? Duration.zero : restante;
}

// Se llama al abrir la app. Supabase ya restauró la sesión guardada;
// acá se la cierra si no se pidió mantenerla o si pasaron 5 minutos
// desde la última actividad.
Future<void> revisarSesion() async {
  if (supabase.auth.currentSession == null) return;
  final prefs = await SharedPreferences.getInstance();
  final mantener = prefs.getBool('mantener_sesion') ?? false;
  final restante = await tiempoRestanteSesion();
  if (!mantener || restante == Duration.zero) {
    // scope local: borra la sesión del dispositivo sin necesitar internet
    await supabase.auth.signOut(scope: SignOutScope.local);
  }
}

// ---------------- LOGIN ----------------

// mantener = true → la sesión sigue abierta si se cierra y se vuelve a abrir la app
// Devuelve null si entró bien, o el mensaje de error para mostrar
Future<String?> login(String email, String password, bool mantener) async {
  try {
    await supabase.auth.signInWithPassword(email: email, password: password);
    await guardarInicioSesion(mantener);
    return null;
  } on AuthException catch (e) {
    if (e.code == 'invalid_credentials') {
      return 'Email o contraseña incorrectos';
    }
    return e.message;
  }
}

// Crea la cuenta (siempre como 'cliente', lo hace el trigger de la base).
// Devuelve null si salió bien, o el mensaje de error para mostrar
// nombre y apellido viajan como metadata y el trigger los copia a "perfiles"
Future<String?> registrarse(String nombre, String apellido, String email, String password) async {
  try {
    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'nombre': nombre, 'apellido': apellido},
    );
    // Si la cuenta queda logueada, la sesión también dura 5 minutos
    if (supabase.auth.currentSession != null) {
      await guardarInicioSesion(false);
    }
    return null;
  } on AuthException catch (e) {
    if (e.code == 'user_already_exists') {
      return 'Ya existe una cuenta con ese email';
    }
    if (e.code == 'weak_password') {
      return 'La contraseña es muy débil (mínimo 6 caracteres)';
    }
    return e.message;
  }
}

// true si el usuario logueado tiene rol 'admin'
Future<bool> esAdmin() async {
  final user = supabase.auth.currentUser;
  if (user == null) return false;
  final perfil = await supabase
      .from('perfiles')
      .select('rol')
      .eq('id', user.id)
      .maybeSingle();
  return perfil != null && perfil['rol'] == 'admin';
}

// "Nombre Apellido" del usuario logueado, o null si no tiene (cuentas viejas)
Future<String?> getNombreCompleto() async {
  final user = supabase.auth.currentUser;
  if (user == null) return null;
  final perfil = await supabase
      .from('perfiles')
      .select('nombre, apellido')
      .eq('id', user.id)
      .maybeSingle();
  if (perfil == null || perfil['nombre'] == null) return null;
  return '${perfil['nombre']} ${perfil['apellido'] ?? ''}'.trim();
}

Future<void> logout() async {
  _ultimaActividad = null;
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

// Falla con código 23503 si el servicio ya tiene turnos (on delete restrict)
Future<void> borrarServicio(int id) async {
  await supabase.from('servicios').delete().eq('id', id);
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
Future<int> addTurno(String nombreCliente, String fecha, String hora, int servicioId) async {
  final turno = await supabase.from('turnos').insert({
    'nombre_cliente': nombreCliente,
    'fecha': fecha,
    'hora': hora,
    'servicio_id': servicioId,
  }).select('id').single();
  return turno['id'];
}


Future<void> borrarTurno(int id) async {
  await supabase.from('turnos').delete().eq('id', id);
  await cancelarRecordatorio(id);
}
