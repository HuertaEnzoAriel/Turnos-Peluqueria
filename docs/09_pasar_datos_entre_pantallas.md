# 09 · Pasar datos entre pantallas

## Qué necesito
- Pantalla A (envía): `Navigator.pushNamed(context, 'ruta', arguments: dato)`.
- Pantalla B (recibe): `ModalRoute.of(context)!.settings.arguments` dentro de `build`.

## Paso a paso: enviar UN dato

### Paso 1: En la pantalla A, enviarlo
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, 'detalle', arguments: 'Manuel Belgrano');
  },
  child: const Text('Ver detalle'),
)
```

### Paso 2: En la pantalla B, recibirlo
Dentro de `build`, **antes del `return`**:
```dart
@override
Widget build(BuildContext context) {
  final nombre = ModalRoute.of(context)!.settings.arguments as String;

  return Scaffold(
    appBar: AppBar(title: const Text('Detalle')),
    body: Center(child: Text('Nombre: $nombre')),
  );
}
```
`as String` = "esto es un String". Si mandaste un número: `as int`.

## Paso a paso: enviar VARIOS datos (Map)

### Paso 1: Enviar un Map
```dart
Navigator.pushNamed(context, 'detalle', arguments: {
  'nombre': 'Manuel Belgrano',
  'nacimiento': 1770,
  'imagen': 'assets/belgrano.png',
});
```

### Paso 2: Recibir el Map
```dart
final datos = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

// usarlo:
Text(datos['nombre']),
Text('Nació en ${datos['nacimiento']}'),
Image.asset(datos['imagen']),
```

## Paso a paso: devolver un dato al volver

### Paso 1: Pantalla A espera el resultado (función `async`)
```dart
String _resultado = '';

void _abrir() async {
  final respuesta = await Navigator.pushNamed(context, 'elegir');
  if (respuesta != null) {
    setState(() => _resultado = respuesta as String);
  }
}
```

### Paso 2: Pantalla B devuelve el dato al cerrar
```dart
ElevatedButton(
  onPressed: () => Navigator.pop(context, 'Opción A'),
  child: const Text('Elegir A'),
)
```

## Alternativa sin rutas con nombre (por constructor)
Pantalla B recibe el dato en su constructor:
```dart
class DetallePage extends StatelessWidget {
  final String nombre;
  const DetallePage({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(nombre)));
  }
}
```
Pantalla A:
```dart
Navigator.push(context, MaterialPageRoute(builder: (context) => const DetallePage(nombre: 'Belgrano')));
```

## Ejemplo completo: formulario → resultado
Pantalla formulario (ver archivo 08) envía:
```dart
Navigator.pushNamed(context, 'resultado', arguments: {'nombre': _nombreCtrl.text, 'email': _emailCtrl.text});
```
Pantalla resultado:
```dart
import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  const ResultadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado'), backgroundColor: Colors.red[300]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nombre: ${datos['nombre']}', style: const TextStyle(fontSize: 20)),
            Text('Email: ${datos['email']}', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Volver')),
          ],
        ),
      ),
    );
  }
}
```

## Errores comunes
| Error | Solución |
|---|---|
| `Null check operator used on a null value` | Abriste la pantalla sin `arguments` (ej. desde otro botón). Enviá siempre el dato, o usá `as String?` y `?? 'sin dato'` |
| `type '_Map<String, Object>' is not a subtype of type 'String'` | Mandaste un Map y lo recibís `as String`. Recibilo `as Map<String, dynamic>` |
| Datos no se actualizan al volver | Falta `await` + `setState` en la pantalla A |
