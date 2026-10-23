# 13 · AlertDialog y SnackBar

## Qué necesito
- Una función que muestre el diálogo: `_mostrarAlerta(context)`.
- Un botón que la llame.
- Para cerrar el diálogo: `Navigator.of(context).pop()`.
- Puede ser `stless` (el diálogo no necesita estado de la pantalla).

## Paso a paso: AlertDialog

### Paso 1: Botón que abre la alerta
```dart
ElevatedButton(
  onPressed: () => _mostrarAlerta(context),
  child: const Text('Mostrar alerta'),
)
```

### Paso 2: Crear la función (dentro de la clase, fuera del build)
```dart
void _mostrarAlerta(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,       // true = se cierra tocando afuera
    builder: (context) {
      return AlertDialog(
        title: const Text('Título'),
        content: const Text('Contenido de la alerta'),
        actions: [],
      );
    },
  );
}
```

### Paso 3: Botones de la alerta (`actions`)
```dart
actions: [
  TextButton(
    onPressed: () => Navigator.of(context).pop(),     // cierra
    child: const Text('Cancelar'),
  ),
  TextButton(
    onPressed: () {
      Navigator.of(context).pop();
      // hacer algo más acá
    },
    child: const Text('OK'),
  ),
],
```

### Paso 4: Contenido con varias cosas (texto + imagen)
```dart
content: Column(
  mainAxisSize: MainAxisSize.min,     // ⚠️ si no, la alerta ocupa toda la pantalla
  children: [
    const Text('¿Estás seguro?'),
    const SizedBox(height: 10),
    Image.asset('assets/procer.png', height: 100),   // o const FlutterLogo(size: 100)
  ],
),
```

### Paso 5: Bordes redondeados y color
```dart
AlertDialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  backgroundColor: Colors.white,
  ...
)
```

## Código final
```dart
import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _mostrarAlerta(context),
          child: const Text('Mostrar Alerta'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Título'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contenido de la tarjeta de alerta'),
              FlutterLogo(size: 100),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        );
      },
    );
  }
}
```

## Alerta de confirmación que devuelve Sí/No
```dart
void _confirmar() async {
  final respuesta = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('¿Borrar?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí')),
      ],
    ),
  );
  if (respuesta == true) {
    // borrar
  }
}
```

## Paso a paso: SnackBar (aviso abajo que desaparece solo)

### Paso 1: Llamarlo desde cualquier botón
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Guardado correctamente')),
);
```

### Paso 2: Opciones
```dart
SnackBar(
  content: const Text('Elemento borrado'),
  duration: const Duration(seconds: 2),
  backgroundColor: Colors.red,
  action: SnackBarAction(label: 'Deshacer', onPressed: () {}),
)
```

## Errores comunes
| Error | Solución |
|---|---|
| La alerta ocupa toda la altura | `mainAxisSize: MainAxisSize.min` en la Column del content |
| El botón OK no cierra | Falta `Navigator.of(context).pop()` |
| `No ScaffoldMessenger widget found` | El SnackBar se llama desde una pantalla sin `Scaffold`/`MaterialApp` arriba |
