# 19 · CircleAvatar (avatar circular)

## Qué necesito
- Puede ser `stless`.
- Una imagen en `assets/` (declarada en pubspec) o un texto (iniciales).

## Paso a paso

### Paso 1: Avatar con imagen
```dart
const CircleAvatar(
  radius: 50,                                          // tamaño (radio, no diámetro)
  backgroundImage: AssetImage('assets/procer.png'),
)
```

### Paso 2: Avatar con iniciales
```dart
const CircleAvatar(
  radius: 30,
  backgroundColor: Colors.amber,
  foregroundColor: Colors.black,
  child: Text('MB'),
)
```

### Paso 3: Avatar con ícono
```dart
const CircleAvatar(radius: 30, child: Icon(Icons.person))
```

### Paso 4: Ponerlo en el AppBar (arriba a la derecha)
```dart
AppBar(
  title: const Text('Avatar Page'),
  actions: [
    Container(
      padding: const EdgeInsets.all(5),
      child: const CircleAvatar(backgroundImage: AssetImage('assets/procer.png')),
    ),
    Container(
      margin: const EdgeInsets.only(right: 10),        // separarlo del borde
      child: const CircleAvatar(backgroundColor: Colors.amber, child: Text('FS')),
    ),
  ],
)
```

### Paso 5: En una lista
```dart
ListTile(
  leading: const CircleAvatar(backgroundImage: AssetImage('assets/procer.png')),
  title: const Text('Manuel Belgrano'),
)
```

## Código final
```dart
import 'package:flutter/material.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Page'),
        actions: [
          const Padding(
            padding: EdgeInsets.all(5),
            child: CircleAvatar(backgroundImage: AssetImage('assets/procer.png')),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: const CircleAvatar(backgroundColor: Colors.amber, child: Text('FS')),
          ),
        ],
      ),
      body: const Center(
        child: CircleAvatar(
          radius: 100,
          backgroundImage: AssetImage('assets/procer.png'),
        ),
      ),
    );
  }
}
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Borde alrededor del avatar | Anidar: `CircleAvatar(radius: 55, backgroundColor: Colors.blue, child: CircleAvatar(radius: 50, backgroundImage: ...))` |
| Imagen circular sin CircleAvatar | `ClipOval(child: Image.asset('...', width: 100, height: 100, fit: BoxFit.cover))` |
| Inicial desde un nombre | `Text(nombre[0])` |

## Errores comunes
| Error | Solución |
|---|---|
| `Unable to load asset` | Ver archivo 05 (pubspec + reiniciar) |
| Usé `Image.asset` en `backgroundImage` | `backgroundImage` pide `AssetImage('...')`, no `Image.asset(...)` |
