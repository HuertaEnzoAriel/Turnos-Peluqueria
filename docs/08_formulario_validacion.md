# 08 · Formulario con validación

## Qué necesito
- **`stful`**.
- Una llave del formulario: `final _formKey = GlobalKey<FormState>();`
- Un controller por campo para leer lo escrito: `final _nombreCtrl = TextEditingController();`
- Widget `Form` envolviendo los campos.
- `TextFormField` (no `TextField`) con su `validator`.
- Botón que llama a `_formKey.currentState!.validate()`.

**Lógica:** cada campo tiene una función `validator` que recibe lo escrito y devuelve:
- `null` → está bien.
- un `String` → está mal, y ese texto aparece en rojo debajo del campo.

## Paso a paso

### Paso 1: Crear `formulario_page.dart` con `stful`
Nombre: `FormularioPage`.

### Paso 2: Variables arriba del `build`
```dart
final _formKey = GlobalKey<FormState>();
final _nombreCtrl = TextEditingController();
final _emailCtrl = TextEditingController();
final _edadCtrl = TextEditingController();
```

### Paso 3: Liberar los controllers al salir (buena práctica)
```dart
@override
void dispose() {
  _nombreCtrl.dispose();
  _emailCtrl.dispose();
  _edadCtrl.dispose();
  super.dispose();
}
```

### Paso 4: Envolver los campos en un `Form`
```dart
body: Padding(
  padding: const EdgeInsets.all(16),
  child: Form(
    key: _formKey,                 // ⚠️ conectar la llave
    child: Column(
      children: [
        // campos acá
      ],
    ),
  ),
),
```

### Paso 5: Agregar un campo con validación
```dart
TextFormField(
  controller: _nombreCtrl,
  decoration: const InputDecoration(
    labelText: 'Nombre',
    icon: Icon(Icons.person),
    border: OutlineInputBorder(),
  ),
  validator: (valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    if (valor.trim().length < 3) {
      return 'Mínimo 3 letras';
    }
    return null;                  // todo bien
  },
),
const SizedBox(height: 15),
```

### Paso 6: Campo email
```dart
TextFormField(
  controller: _emailCtrl,
  keyboardType: TextInputType.emailAddress,
  decoration: const InputDecoration(labelText: 'Email', icon: Icon(Icons.email), border: OutlineInputBorder()),
  validator: (valor) {
    if (valor == null || valor.isEmpty) return 'El email es obligatorio';
    if (!valor.contains('@') || !valor.contains('.')) return 'Email inválido';
    return null;
  },
),
```

### Paso 7: Campo numérico
```dart
TextFormField(
  controller: _edadCtrl,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(labelText: 'Edad', icon: Icon(Icons.cake), border: OutlineInputBorder()),
  validator: (valor) {
    final numero = int.tryParse(valor ?? '');     // null si no es número
    if (numero == null) return 'Ingresá un número';
    if (numero < 1 || numero > 120) return 'Edad fuera de rango';
    return null;
  },
),
```

### Paso 8: Botón que valida
```dart
ElevatedButton(
  onPressed: _enviar,
  child: const Text('Enviar'),
),
```
```dart
void _enviar() {
  if (_formKey.currentState!.validate()) {
    // TODO válido → hacer algo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Hola ${_nombreCtrl.text}')),
    );
  }
  // si no es válido, los errores ya aparecen en rojo solos
}
```

### Paso 9 (si piden): ir a otra pantalla con los datos
```dart
if (_formKey.currentState!.validate()) {
  Navigator.pushNamed(context, 'resultado', arguments: {
    'nombre': _nombreCtrl.text,
    'email': _emailCtrl.text,
  });
}
```
Cómo recibirlos: ver archivo 09.

### Paso 10 (si piden): limpiar el formulario
```dart
_formKey.currentState!.reset();
_nombreCtrl.clear();
```

## Código final completo
```dart
import 'package:flutter/material.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});
  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _enviar() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, 'resultado', arguments: {
        'nombre': _nombreCtrl.text,
        'email': _emailCtrl.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: SingleChildScrollView(              // evita overflow con el teclado abierto
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre', icon: Icon(Icons.person)),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatorio' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
                validator: (v) => (v == null || !v.contains('@')) ? 'Email inválido' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña', icon: Icon(Icons.lock)),
                validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: _enviar, child: const Text('Enviar')),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Validaciones típicas (copiar el `validator`)
| Regla | Código |
|---|---|
| Obligatorio | `(v) => (v == null \|\| v.trim().isEmpty) ? 'Obligatorio' : null` |
| Mínimo N letras | `(v) => (v == null \|\| v.length < 3) ? 'Mínimo 3' : null` |
| Máximo N | `(v) => (v != null && v.length > 20) ? 'Máximo 20' : null` |
| Email | `(v) => (v == null \|\| !v.contains('@')) ? 'Email inválido' : null` |
| Solo número | `(v) => int.tryParse(v ?? '') == null ? 'Solo números' : null` |
| Confirmar contraseña | `(v) => v != _passCtrl.text ? 'No coinciden' : null` |

(Los `\|\|` en la tabla son `||` en el código.)

## Si quiero...
| Quiero | Hago |
|---|---|
| Validar mientras escribe | En `Form`: `autovalidateMode: AutovalidateMode.onUserInteraction` |
| Borde redondeado | `border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))` |
| Texto de ayuda gris abajo | `helperText: 'Solo nombre'` |
| Texto de ejemplo adentro | `hintText: 'Ej: Juan'` |
| Mostrar/ocultar contraseña | `bool _ver = false;` → `obscureText: !_ver` → `suffixIcon: IconButton(icon: Icon(_ver ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _ver = !_ver))` |

## Errores comunes
| Error | Solución |
|---|---|
| `Null check operator used on a null value` en `currentState!` | Falta `key: _formKey` en el `Form` |
| No aparecen los errores | Usaste `TextField` en vez de `TextFormField`, o no llamaste `validate()` |
| Overflow al abrir el teclado | Envolver en `SingleChildScrollView` |
| `_nombreCtrl.text` siempre vacío | Falta `controller: _nombreCtrl` en el campo |
