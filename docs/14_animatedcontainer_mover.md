# 14 · AnimatedContainer / mover un componente

## Qué necesito
- **`stful`**.
- Variables para cada propiedad que cambia: `_ancho`, `_alto`, `_color`, `_radio`, `_izquierda`.
- `AnimatedContainer` (anima tamaño, color, bordes) con `duration`.
- Para mover: `Stack` + `AnimatedPositioned` (anima la posición).
- Función `_mover()` / `_cambiarForma()` con `setState`.
- `import 'dart:math';` si los valores son aleatorios.

**Lógica:** yo solo cambio las variables con `setState`; el `AnimatedContainer` hace la transición animada solo ("animación implícita").

## Paso a paso: AnimatedContainer que cambia de forma

### Paso 1: `stful` e import
```dart
import 'dart:math';
import 'package:flutter/material.dart';
```

### Paso 2: Variables
```dart
double _ancho = 50;
double _alto = 50;
Color _color = Colors.blue;
BorderRadius _radio = BorderRadius.circular(8);
```

### Paso 3: El AnimatedContainer centrado
```dart
body: Center(
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 500),   // cuánto dura la animación
    curve: Curves.fastOutSlowIn,                   // tipo de movimiento
    width: _ancho,
    height: _alto,
    decoration: BoxDecoration(color: _color, borderRadius: _radio),
  ),
),
```

### Paso 4: Función que cambia los valores
```dart
void _cambiarForma() {
  final random = Random();
  setState(() {
    _ancho = random.nextInt(300).toDouble() + 20;     // +20 para que nunca sea 0
    _alto = random.nextInt(300).toDouble() + 20;
    _color = Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
    _radio = BorderRadius.circular(random.nextInt(100).toDouble());
  });
}
```

### Paso 5: Botón que la llama
```dart
floatingActionButton: FloatingActionButton(
  onPressed: _cambiarForma,
  child: const Icon(Icons.play_arrow),
),
```

## Paso a paso: mover de izquierda a derecha SIN salirse de la pantalla

### Paso 1: Variable de posición
```dart
double _izquierda = 0;
```

### Paso 2: Poner el componente dentro de un Stack con AnimatedPositioned
```dart
body: Stack(
  children: [
    AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      top: 20,
      left: _izquierda,               // la posición horizontal
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: _ancho,
        height: _alto,
        decoration: BoxDecoration(color: _color, borderRadius: _radio),
      ),
    ),
  ],
),
```

### Paso 3: Calcular el límite
Ancho de la pantalla: `MediaQuery.of(context).size.width`.
La posición máxima para que no se salga: **ancho pantalla − ancho del componente**.

### Paso 4: Función `_mover`
Opción A, aleatorio:
```dart
void _mover() {
  final random = Random();
  final anchoPantalla = MediaQuery.of(context).size.width;
  setState(() {
    _ancho = random.nextInt(120).toDouble() + 40;          // entre 40 y 160
    _alto = random.nextInt(200).toDouble() + 40;
    _color = Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
    _radio = BorderRadius.circular(random.nextInt(60).toDouble());
    _izquierda = random.nextDouble() * (anchoPantalla - _ancho);   // nunca se sale
  });
}
```
Opción B, avanza de a pasos y vuelve al inicio:
```dart
void _mover() {
  final anchoPantalla = MediaQuery.of(context).size.width;
  setState(() {
    _izquierda += 60;
    if (_izquierda > anchoPantalla - _ancho) _izquierda = 0;
  });
}
```
Opción C, va y vuelve (rebota):
```dart
bool _haciaDerecha = true;

void _mover() {
  final max = MediaQuery.of(context).size.width - _ancho;
  setState(() {
    _izquierda += _haciaDerecha ? 60 : -60;
    if (_izquierda >= max) { _izquierda = max; _haciaDerecha = false; }
    if (_izquierda <= 0)   { _izquierda = 0;   _haciaDerecha = true; }
  });
}
```

### Paso 5: Botón "Mover"
```dart
floatingActionButton: FloatingActionButton.extended(
  onPressed: _mover,
  label: const Text('Mover'),
),
```

## Código final completo (ejercicio "Práctica5")
```dart
import 'dart:math';
import 'package:flutter/material.dart';

class MoverPage extends StatefulWidget {
  const MoverPage({super.key});
  @override
  State<MoverPage> createState() => _MoverPageState();
}

class _MoverPageState extends State<MoverPage> {
  final _random = Random();
  double _izquierda = 20;
  double _ancho = 50;
  double _alto = 50;
  Color _color = Colors.blue;
  double _radio = 10;

  void _mover() {
    final anchoPantalla = MediaQuery.of(context).size.width;
    setState(() {
      _ancho = _random.nextInt(120).toDouble() + 40;
      _alto = _random.nextInt(200).toDouble() + 40;
      _radio = _random.nextInt(60).toDouble();
      _color = Color.fromRGBO(_random.nextInt(256), _random.nextInt(256), _random.nextInt(256), 1);
      _izquierda = _random.nextDouble() * (anchoPantalla - _ancho);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Práctica5')),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            top: 20,
            left: _izquierda,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              width: _ancho,
              height: _alto,
              decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(_radio)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mover,
        label: const Text('Mover'),
      ),
    );
  }
}
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Mover en vertical | Variable `_arriba` y usar `top: _arriba` (límite: alto pantalla − alto componente − alto AppBar) |
| Animación más lenta | `Duration(seconds: 2)` |
| Otro tipo de movimiento | `curve: Curves.bounceOut` / `easeInOut` / `elasticOut` |
| Solo mover sin Stack | `AnimatedAlign(alignment: _alineacion, duration: ..., child: ...)` y cambiar `_alineacion` entre `Alignment.centerLeft` y `Alignment.centerRight` |
| Aparecer/desaparecer | `AnimatedOpacity(opacity: _visible ? 1 : 0, duration: ..., child: ...)` |

## Errores comunes
| Error | Solución |
|---|---|
| No se anima, salta de golpe | Usaste `Container` en vez de `AnimatedContainer`, o `Positioned` en vez de `AnimatedPositioned` |
| Se sale de la pantalla | Falta restar el ancho del componente al límite |
| `Undefined name 'Random'` | Falta `import 'dart:math';` |
| El componente desaparece | Ancho o alto quedó en 0 → sumar un mínimo (+20) |
