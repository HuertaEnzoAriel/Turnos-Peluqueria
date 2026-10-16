import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final List<Map<String, String>> _turnos = [];

  void _agregarTurno(Map<String, String> turno) {
    setState(() {
      _turnos.add(turno);
      _indice = 2;   // salta a "Mis turnos"
    });
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    final List<Widget> pantallas = [
      ServiciosTab(email: email),
      ReservarTab(onReservar: _agregarTurno),
      TurnosTab(turnos: _turnos),
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
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 8),
            Text('Peluquería'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
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