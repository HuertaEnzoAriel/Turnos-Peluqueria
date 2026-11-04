import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/supabase_services.dart';

class ServiciosTab extends StatefulWidget {
  final String email;
  const ServiciosTab({super.key, required this.email});
  @override
  State<ServiciosTab> createState() => _ServiciosTabState();
}

class _ServiciosTabState extends State<ServiciosTab> {
  // Supabase guarda el nombre del ícono; acá se pasa al ícono de Flutter
  final Map<String, IconData> _iconos = {
    'content_cut': Icons.content_cut,
    'face': Icons.face,
    'palette': Icons.palette,
    'brush': Icons.brush,
  };

  bool _admin = false;

  @override
  void initState() {
    super.initState();
    // Solo el admin puede agregar y editar servicios
    esAdmin().then((valor) {
      if (mounted) setState(() => _admin = valor);
    }).catchError((_) {});
  }

  // servicio == null → servicio nuevo; si no, se edita ese
  void _abrirServicio(Map<String, dynamic>? servicio, List<Map<String, dynamic>> servicios) async {
    // Nombres ya usados, para que no se repitan en el dropdown de Reservar
    List<String> existentes = ['Sin dato'];
    for (var s in servicios) {
      existentes.add(s['nombre']);
    }
    if (servicio != null) {
      existentes.remove(servicio['nombre']);
    }

    await Navigator.pushNamed(context, 'servicio', arguments: {
      'servicio': servicio,
      'existentes': existentes,
    });

    if (!mounted) return;
    setState(() {});   // vuelve a leer la lista de Supabase
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getServicios(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('No se pudieron cargar los servicios:\n${snapshot.error}'));
        }
        final servicios = snapshot.data!;
        return Scaffold(
          body: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: servicios.length + 1,   // +1 por el saludo de arriba
            itemBuilder: (context, i) {
              if (i == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido, ${widget.email}', style: TextStyle(fontSize: 16, color: AppColores.negro)),
                      if (_admin) Text('Tocá un servicio para editarlo', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                );
              }
              final s = servicios[i - 1];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColores.negro,
                    child: Icon(_iconos[s['icono']] ?? Icons.content_cut, color: AppColores.dorado),
                  ),
                  title: Text(s['nombre'], style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(
                    '\$${s['precio']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColores.doradoOscuro,
                    ),
                  ),
                  onTap: _admin ? () => _abrirServicio(s, servicios) : null,
                ),
              );
            },
          ),
          floatingActionButton: !_admin ? null : FloatingActionButton(
            backgroundColor: AppColores.negro,
            foregroundColor: AppColores.dorado,
            onPressed: () => _abrirServicio(null, servicios),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
