import 'package:flutter/material.dart';
import '../services/supabase_services.dart';

class ReservarTab extends StatefulWidget {
  final Function() onReservar;
  const ReservarTab({super.key, required this.onReservar});
  @override
  State<ReservarTab> createState() => _ReservarTabState();
}

class _ReservarTabState extends State<ReservarTab> {
  String _nombre = '';
  String _fecha = '';
  String _fechaDb = '';   // la misma fecha en formato aaaa-mm-dd para Supabase
  String _hora = '';
  final TextEditingController _inputFieldController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();

  String _opcionSeleccionadaDropdown = 'Sin dato';
  List<Map<String, dynamic>> _servicios = [];

  @override
  void initState() {
    super.initState();
    _cargarServicios();
  }

  // Se cargan una sola vez para el dropdown (no en build, porque cada
  // letra del nombre hace setState y volvería a consultar Supabase)
  void _cargarServicios() async {
    try {
      final servicios = await getServicios();
      if (!mounted) return;
      setState(() {
        _servicios = servicios;
      });
    } catch (e) {
      if (!mounted) return;
      _alertaError('No se pudieron cargar los servicios:\n$e');
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? calendario = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      locale: const Locale('es', 'ES'),
    );
    if (calendario != null) {
      setState(() {
        _fecha = '${calendario.day}/${calendario.month}/${calendario.year}';
        _fechaDb = calendario.toIso8601String().substring(0, 10);
        _inputFieldController.text = _fecha;
      });
    }
    return calendario;
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora != null) {
      setState(() {
        _hora = '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
        _horaController.text = _hora;
      });
    }
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [
      DropdownMenuItem(value: 'Sin dato', child: Text('Sin dato')),
    ];
    for (var servicio in _servicios) {
      lista.add(DropdownMenuItem(value: servicio['nombre'], child: Text(servicio['nombre'])));
    }
    return lista;
  }

  void _reservar() {
    String errores = '';
    if (_nombre.trim().isEmpty) {
      errores = errores + 'Falta ingresar el nombre\n';
    }
    if (_fecha.isEmpty) {
      errores = errores + 'Falta elegir la fecha\n';
    }
    if (_hora.isEmpty) {
      errores = errores + 'Falta elegir la hora\n';
    }
    if (_opcionSeleccionadaDropdown == 'Sin dato') {
      errores = errores + 'Falta elegir el servicio\n';
    }

    if (errores.isNotEmpty) {
      _alertaError(errores);
    } else {
      _alertaExito();
    }
  }

  void _alertaError(String errores) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errores),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _alertaExito() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar turno'),
          content: Text('Nombre: $_nombre\nFecha: $_fecha\nHora: $_hora\nServicio: $_opcionSeleccionadaDropdown'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _guardarTurno();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _guardarTurno() async {
    // Busca el id del servicio elegido en el dropdown
    final servicio = _servicios.firstWhere((s) => s['nombre'] == _opcionSeleccionadaDropdown);
    try {
      await addTurno(_nombre.trim(), _fechaDb, _hora, servicio['id']);
      widget.onReservar();
    } catch (e) {
      if (!mounted) return;
      _alertaError('No se pudo guardar el turno:\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        TextField(
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: 'Nombre del cliente',
            icon: Icon(Icons.person),
          ),
          onChanged: (valor) {
            setState(() {
              _nombre = valor;
            });
          },
        ),
        SizedBox(height: 20),
        TextField(
          controller: _inputFieldController,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: 'Fecha del turno',
            suffixIcon: Icon(Icons.calendar_today),
            icon: Icon(Icons.date_range),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _selectDate(context);
          },
        ),
        SizedBox(height: 20),
        TextField(
          controller: _horaController,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            labelText: 'Hora del turno',
            suffixIcon: Icon(Icons.access_time),
            icon: Icon(Icons.schedule),
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _selectTime(context);
          },
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.content_cut),
            SizedBox(width: 30),
            Expanded(
              child: DropdownButton(
                value: _opcionSeleccionadaDropdown,
                items: getOpcionesDropdown(),
                onChanged: (opt) {
                  setState(() {
                    _opcionSeleccionadaDropdown = opt.toString();
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: _reservar,
            child: Text('Reservar turno'),
          ),
        ),
      ],
    );
  }
}