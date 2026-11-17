import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final _plugin = FlutterLocalNotificationsPlugin();

Future<void> initNotificaciones() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Argentina/San_Juan'));

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  await _plugin.initialize(
    settings: const InitializationSettings(android: android),
  );

  // Android 13+: pide permiso al usuario
  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();
  await androidPlugin?.requestExactAlarmsPermission();
}

// fecha: aaaa-mm-dd, hora: hh:mm  (mismo formato que addTurno)
Future<void> programarRecordatorio(int turnoId, String fecha, String hora) async {
  final f = fecha.split('-');
  final h = hora.split(':');
  final turno = tz.TZDateTime(
    tz.local,
    int.parse(f[0]), int.parse(f[1]), int.parse(f[2]),
    int.parse(h[0]), int.parse(h[1]),
  );
  final aviso = turno.subtract(const Duration(minutes: 1));

  // si faltan menos de 1 hora, no tiene sentido programarla
  if (aviso.isBefore(tz.TZDateTime.now(tz.local))) return;

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
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

Future<void> cancelarRecordatorio(int turnoId) async {
  await _plugin.cancel(id: turnoId);
}
