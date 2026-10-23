import 'package:flutter/material.dart';

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

  void _guardar(Map<String, dynamic>? servicio) {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'nombre': _nombreCtrl.text.trim(),
        'precio': int.parse(_precioCtrl.text.trim()),
        'icono': servicio == null ? Icons.content_cut : servicio['icono'],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final datos = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Map<String, dynamic>? servicio = datos['servicio'];   // null = servicio nuevo
    final List<String> existentes = datos['existentes'];

    // Si es edición, los datos actuales se cargan en los campos una sola vez
    if (servicio != null && !_cargado) {
      _nombreCtrl.text = servicio['nombre'];
      _precioCtrl.text = '${servicio['precio']}';
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
            ],
          ),
        ),
      ),
    );
  }
}
