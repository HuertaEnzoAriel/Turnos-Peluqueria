import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final _plugin = FlutterLocalNotificationsPlugin();

// Parte de Android del plugin (null si la app corre en otra plataforma)
AndroidFlutterLocalNotificationsPlugin? get _android =>
    _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

// Se llama en main(). Solo prepara el plugin: el permiso se pide después,
// en la pantalla principal, explicándole antes al usuario para qué sirve.
Future<void> initNotificaciones() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Argentina/San_Juan'));

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _plugin.initialize(
    settings: const InitializationSettings(android: android),
  );
}

// true si el usuario ya dio permiso de notificaciones
// (en Android 12 o menos no hace falta pedirlo, siempre da true)
Future<bool> tienePermisoNotificaciones() async {
  return await _android?.areNotificationsEnabled() ?? false;
}

// Android 13+: muestra el diálogo del sistema para permitir notificaciones.
// Devuelve true si el usuario aceptó.
Future<bool> pedirPermisoNotificaciones() async {
  final aceptado = await _android?.requestNotificationsPermission() ?? false;
  // Alarmas exactas (para que el aviso llegue justo a tiempo).
  // En Android 14+ abre Ajustes → "Alarmas y recordatorios".
  if (aceptado && !(await _android?.canScheduleExactNotifications() ?? true)) {
    await _android?.requestExactAlarmsPermission();
  }
  return aceptado;
}

// fecha: aaaa-mm-dd, hora: hh:mm  (mismo formato que addTurno)
// Devuelve false si no se pudo programar por falta de permiso o por un error.
// Nunca lanza excepción: el turno ya está guardado y no debe parecer que falló.
Future<bool> programarRecordatorio(int turnoId, String fecha, String hora) async {
  try {
    if (!await tienePermisoNotificaciones()) return false;

    final f = fecha.split('-');
    final h = hora.split(':');
    final turno = tz.TZDateTime(
      tz.local,
      int.parse(f[0]), int.parse(f[1]), int.parse(f[2]),
      int.parse(h[0]), int.parse(h[1]),
    );
    // Aviso 1 minuto antes del turno (corto a propósito para la demo)
    final aviso = turno.subtract(const Duration(minutes: 1));

    // Si falta menos de 1 minuto no hay nada que programar (no es un error)
    if (aviso.isBefore(tz.TZDateTime.now(tz.local))) return true;

    // Sin permiso de alarmas exactas se programa igual, pero puede llegar
    // con unos minutos de demora (Android agrupa las alarmas inexactas)
    final exacta = await _android?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id: turnoId,
      title: 'Recordatorio de turno',
      body: 'Tenés un turno hoy a las $hora',
      scheduledDate: aviso,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'turnos_channel',
          'Turnos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: exacta
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> cancelarRecordatorio(int turnoId) async {
  await _plugin.cancel(id: turnoId);
}
