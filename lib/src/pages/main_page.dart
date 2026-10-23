import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_theme.dart';
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

  final List<Map<String, dynamic>> _servicios = [
    {'nombre': 'Corte de pelo', 'precio': 8000, 'icono': Icons.content_cut},
    {'nombre': 'Barba', 'precio': 5000, 'icono': Icons.face},
    {'nombre': 'Color', 'precio': 15000, 'icono': Icons.palette},
    {'nombre': 'Peinado', 'precio': 7000, 'icono': Icons.brush},
  ];

  void _agregarTurno(Map<String, String> turno) {
    setState(() {
      _turnos.add(turno);
      _indice = 2;   // salta a "Mis turnos"
    });
  }

  // indice == null → servicio nuevo; si no, se edita el de esa posición
  void _abrirServicio(int? indice) async {
    // Nombres ya usados, para que no se repitan en el dropdown de Reservar
    List<String> existentes = ['Sin dato'];
    for (var s in _servicios) {
      existentes.add(s['nombre']);
    }
    if (indice != null) {
      existentes.remove(_servicios[indice]['nombre']);
    }

    final resultado = await Navigator.pushNamed(context, 'servicio', arguments: {
      'servicio': indice == null ? null : _servicios[indice],
      'existentes': existentes,
    });

    if (resultado != null) {
      _guardarServicio(resultado as Map<String, dynamic>, indice);
    }
  }

  void _guardarServicio(Map<String, dynamic> servicio, int? indice) {
    setState(() {
      if (indice == null) {
        _servicios.add(servicio);
      } else {
        _servicios[indice] = servicio;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String? ?? 'sin dato';

    final List<Widget> pantallas = [
      ServiciosTab(email: email, servicios: _servicios, onEditar: _abrirServicio),
      ReservarTab(servicios: _servicios, onReservar: _agregarTurno),
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
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: pantallas[_indice],
      // El botón de agregar solo se ve en la pestaña Servicios
      floatingActionButton: _indice == 0
          ? FloatingActionButton(
              backgroundColor: AppColores.negro,
              foregroundColor: AppColores.dorado,
              onPressed: () => _abrirServicio(null),
              child: Icon(Icons.add),
            )
          : null,
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