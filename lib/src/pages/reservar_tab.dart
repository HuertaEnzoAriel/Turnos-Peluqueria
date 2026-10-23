import 'package:flutter/material.dart';

class ReservarTab extends StatefulWidget {
  final List<Map<String, dynamic>> servicios;
  final Function(Map<String, String>) onReservar;
  const ReservarTab({super.key, required this.servicios, required this.onReservar});
  @override
  State<ReservarTab> createState() => _ReservarTabState();
}

class _ReservarTabState extends State<ReservarTab> {
  String _nombre = '';
  String _fecha = '';
  final TextEditingController _inputFieldController = TextEditingController();

  String _opcionSeleccionadaDropdown = 'Sin dato';

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
        _inputFieldController.text = _fecha;
      });
    }
    return calendario;
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [
      DropdownMenuItem(value: 'Sin dato', child: Text('Sin dato')),
    ];
    for (var servicio in widget.servicios) {
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
          content: Text('Nombre: $_nombre\nFecha: $_fecha\nServicio: $_opcionSeleccionadaDropdown'),
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
                widget.onReservar({
                  'nombre': _nombre,
                  'fecha': _fecha,
                  'servicio': _opcionSeleccionadaDropdown,
                });
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
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