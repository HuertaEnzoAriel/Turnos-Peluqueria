import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_theme.dart';
import '../services/supabase_services.dart';
import 'servicios_tab.dart';
import 'reservar_tab.dart';
import 'turnos_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _indice = 0;
  Timer? _timerSesion;
  bool _expirando = false;

  @override
  void initState() {
    super.initState();
    _programarExpiracion();
  }

  @override
  void dispose() {
    _timerSesion?.cancel();
    super.dispose();
  }

  // Cada segundo mira cuánto falta: la actividad del usuario lo va alejando.
  // Si pasan 5 minutos sin tocar nada, se cierra la sesión y vuelve al login.
  void _programarExpiracion() {
    _timerSesion = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (_expirando) return;
      final restante = await tiempoRestanteSesion();
      if (restante == Duration.zero) {
        _expirarSesion();
      }
    });
  }

  void _expirarSesion() async {
    _expirando = true;
    _timerSesion?.cancel();
    await logout();
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Sesión expirada'),
          content: Text('Pasaron $minutosSesion minutos sin actividad. Volvé a iniciar sesión.'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  // El turno ya se guardó en Supabase; "Mis turnos" lo vuelve a leer de ahí
  void _agregarTurno() {
    setState(() {
      _indice = 2;   // salta a "Mis turnos"
    });
  }

  @override
  Widget build(BuildContext context) {
    // Desde el login llega por arguments; si la app se abrió con la sesión
    // guardada no hay arguments, así que se toma del usuario de Supabase
    final String email = ModalRoute.of(context)!.settings.arguments as String? ??
        supabase.auth.currentUser?.email ??
        'sin dato';

    // Cada pestaña lee sus datos de Supabase (lib/src/services/supabase_services.dart)
    final List<Widget> pantallas = [
      ServiciosTab(email: email),
      ReservarTab(onReservar: _agregarTurno),
      TurnosTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/tijera.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColores.dorado, BlendMode.srcIn),
            ),
            SizedBox(width: 8),
            Text('PELUQUERÍA'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: pantallas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.content_cut), label: 'Servicios'),
          BottomNavigationBarItem(icon: Icon(Icons.event_available), label: 'Reservar'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Mis turnos'),
        ],
      ),
    );
  }
}