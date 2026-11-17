import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/servicio.dart';
import '../services/supabase_services.dart';

class ServicioPage extends StatefulWidget {
  const ServicioPage({super.key});
  @override
  State<ServicioPage> createState() => _ServicioPageState();
}

class _ServicioPageState extends State<ServicioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  bool _cargado = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    super.dispose();
  }

  void _guardar(Servicio? servicio) async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreCtrl.text.trim();
      final precio = int.parse(_precioCtrl.text.trim());
      try {
        if (servicio == null) {
          await addServicio(nombre, precio);
        } else {
          await updateServicio(servicio.id, nombre, precio);
        }
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar el servicio: $e')),
        );
      }
    }
  }

  void _borrar(Servicio servicio) async {
    final confirmado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Borrar servicio'),
          content: Text('¿Seguro que querés borrar "${servicio.nombre}"?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Sí, borrar'),
            ),
          ],
        );
      },
    );
    if (confirmado != true) return;

    try {
      await borrarServicio(servicio.id);
      if (!mounted) return;
      Navigator.pop(context);
    } on PostgrestException catch (e) {
      if (!mounted) return;
      // 23503 = el servicio está usado por algún turno
      final mensaje = e.code == '23503'
          ? 'No se puede borrar: hay turnos reservados con este servicio'
          : 'No se pudo borrar el servicio: ${e.message}';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo borrar el servicio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final datos = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Servicio? servicio = datos['servicio'];   // null = servicio nuevo
    final List<String> existentes = datos['existentes'];

    // Si es edición, los datos actuales se cargan en los campos una sola vez
    if (servicio != null && !_cargado) {
      _nombreCtrl.text = servicio.nombre;
      _precioCtrl.text = '${servicio.precio}';
      _cargado = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(servicio == null ? 'Nuevo servicio' : 'Editar servicio')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Nombre del servicio',
                  icon: Icon(Icons.content_cut),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (valor.trim().length < 3) {
                    return 'Mínimo 3 letras';
                  }
                  if (existentes.contains(valor.trim())) {
                    return 'Ese servicio ya existe';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _precioCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Precio',
                  icon: Icon(Icons.attach_money),
                ),
                validator: (valor) {
                  final numero = int.tryParse(valor?.trim() ?? '');
                  if (numero == null) {
                    return 'Ingresá un número';
                  }
                  if (numero <= 0) {
                    return 'El precio tiene que ser mayor a 0';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _guardar(servicio),
                child: Text('Guardar'),
              ),
              if (servicio != null)
                TextButton.icon(
                  onPressed: () => _borrar(servicio),
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  label: Text('Borrar servicio', style: TextStyle(color: Colors.redAccent)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
