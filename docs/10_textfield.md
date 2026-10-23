# 10 · TextField (input de texto, email, password)

## Qué necesito
- **`stful`** si quiero mostrar lo que se escribe.
- Una variable `String _nombre = '';` o un `TextEditingController`.
- `onChanged` + `setState` para actualizar mientras escribe.

**TextField vs TextFormField:** `TextField` es el input simple. Si hay validación, usá `TextFormField` dentro de un `Form` (archivo 08).

## Paso a paso: input que muestra lo que escribo

### Paso 1: `stful`, variable arriba del build
```dart
String _nombre = '';
```

### Paso 2: El campo
```dart
TextField(
  onChanged: (valor) {
    setState(() {
      _nombre = valor;
    });
  },
)
```

### Paso 3: Decorarlo (`decoration: InputDecoration(...)`)
```dart
TextField(
  textCapitalization: TextCapitalization.sentences,   // primera letra en mayúscula
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),  // borde
    labelText: 'Nombre',                // etiqueta que sube al escribir
    hintText: 'Nombre de la persona',   // texto gris de ejemplo
    helperText: 'Solo nombre',          // ayuda debajo
    counter: Text('Letras ${_nombre.length}'),  // contador a la derecha abajo
    icon: const Icon(Icons.account_circle),     // ícono afuera a la izquierda
    prefixIcon: const Icon(Icons.edit),         // ícono adentro a la izquierda
    suffixIcon: const Icon(Icons.accessibility), // ícono adentro a la derecha
  ),
  onChanged: (valor) => setState(() => _nombre = valor),
)
```

### Paso 4: Mostrar lo escrito
```dart
ListTile(title: Text('Nombre es: $_nombre')),
```

## Variantes por tipo de campo
| Campo | Propiedad clave |
|---|---|
| Email | `keyboardType: TextInputType.emailAddress` (teclado con @) |
| Número | `keyboardType: TextInputType.number` |
| Teléfono | `keyboardType: TextInputType.phone` |
| Contraseña | `obscureText: true` |
| Varias líneas | `maxLines: 4` |
| Límite de caracteres | `maxLength: 20` |
| Solo lectura | `readOnly: true` |
| Deshabilitado | `enabled: false` |

## Paso a paso: leer el texto al apretar un botón (con controller)

### Paso 1: Variable controller
```dart
final _ctrl = TextEditingController();
String _mostrado = '';
```

### Paso 2: Conectar al campo
```dart
TextField(controller: _ctrl, decoration: const InputDecoration(labelText: 'Escribí algo'))
```

### Paso 3: Leerlo desde un botón
```dart
ElevatedButton(
  onPressed: () => setState(() => _mostrado = _ctrl.text),
  child: const Text('Mostrar'),
)
Text(_mostrado),
```

### Paso 4: Otras acciones con el controller
- Borrar: `_ctrl.clear();`
- Escribir por código: `_ctrl.text = 'Hola';`

### Paso 5: Liberarlo
```dart
@override
void dispose() {
  _ctrl.dispose();
  super.dispose();
}
```

## Código final: nombre, email, password y resumen
```dart
class InputPage extends StatefulWidget {
  const InputPage({super.key});
  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String _nombre = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inputs')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Nombre',
              counter: Text('Letras ${_nombre.length}'),
              icon: const Icon(Icons.account_circle),
            ),
            onChanged: (v) => setState(() => _nombre = v),
          ),
          const Divider(),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Email',
              icon: const Icon(Icons.email),
            ),
            onChanged: (v) => setState(() => _email = v),
          ),
          const Divider(),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Password',
              icon: const Icon(Icons.lock),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text('Nombre es: $_nombre'),
            subtitle: Text('Email: $_email'),
          ),
        ],
      ),
    );
  }
}
```

## Errores comunes
| Error | Solución |
|---|---|
| Lo escrito no aparece abajo | Falta `setState` en `onChanged` |
| Overflow al abrir el teclado | Usar `ListView` o `SingleChildScrollView` en vez de `Column` |
| `TextField` dentro de `Row` da error de ancho | Envolverlo en `Expanded` |
