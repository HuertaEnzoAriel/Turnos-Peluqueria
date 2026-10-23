# 15 · Slider

## Qué necesito
- **`stful`**.
- Variable `double _valor = 200;` (siempre `double`, no `int`).
- `Slider` con `value`, `min`, `max`, `onChanged` + `setState`.
- Algo que use `_valor` (ancho de imagen, tamaño de texto, etc.).

## Paso a paso

### Paso 1: `stful` y variable
```dart
double _valorSlider = 200;
```

### Paso 2: El Slider
```dart
Slider(
  value: _valorSlider,
  min: 10,
  max: 400,
  onChanged: (valor) {
    setState(() {
      _valorSlider = valor;
    });
  },
)
```
⚠️ El valor inicial tiene que estar **entre `min` y `max`**.

### Paso 3: Personalizarlo
```dart
Slider(
  value: _valorSlider,
  min: 10,
  max: 400,
  divisions: 20,                          // saltos fijos (opcional)
  label: '${_valorSlider.round()}',       // globito con el valor (solo se ve con divisions)
  activeColor: Colors.indigoAccent,       // parte llena
  inactiveColor: Colors.grey[300],        // parte vacía
  onChanged: (v) => setState(() => _valorSlider = v),
)
```

### Paso 4: Usar el valor
```dart
Image.asset('assets/procer.png', width: _valorSlider)       // ancho de imagen
Text('Hola', style: TextStyle(fontSize: _valorSlider / 10)) // tamaño de texto
Text('Valor: ${_valorSlider.round()}')                      // mostrar el número
```

### Paso 5: Bloquearlo
`onChanged: null` lo deshabilita. Con una condición:
```dart
onChanged: _bloqueado ? null : (v) => setState(() => _valorSlider = v),
```
(ver archivo 16 para el checkbox que bloquea)

## Código final: slider que cambia el ancho de una imagen
```dart
import 'package:flutter/material.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});
  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _valorSlider = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slider')),
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Slider(
              activeColor: Colors.indigoAccent,
              value: _valorSlider,
              min: 10,
              max: 400,
              onChanged: (v) => setState(() => _valorSlider = v),
            ),
            Text('Ancho: ${_valorSlider.round()}'),
            Expanded(
              child: Image.asset('assets/procer.png', width: _valorSlider, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Rango con dos puntas | `RangeSlider(values: _rango, min: 0, max: 100, onChanged: (r) => setState(() => _rango = r))` con `RangeValues _rango = const RangeValues(20, 80);` |
| Slider de enteros | `divisions: (max - min).toInt()` y mostrar con `.round()` |
| Slider vertical | `RotatedBox(quarterTurns: 3, child: Slider(...))` |

## Errores comunes
| Error | Solución |
|---|---|
| `Value X is not between minimum and maximum` | El valor inicial está fuera de `min`..`max` |
| `A value of type 'int' can't be assigned to 'double'` | Declarar `double _valor = 200;` (o `200.0`) |
| Se mueve pero no pasa nada | Falta `setState` o el widget no usa `_valorSlider` |
