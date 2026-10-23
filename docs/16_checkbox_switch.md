# 16 · Checkbox y Switch

## Qué necesito
- **`stful`**.
- Variable `bool _activo = false;`
- `CheckboxListTile` o `SwitchListTile` (fila con texto + control) con `onChanged` + `setState`.

**Diferencia:** hacen lo mismo, solo cambia el aspecto (casilla vs interruptor).

## Paso a paso: Checkbox

### Paso 1: Variable
```dart
bool _bloquear = false;
```

### Paso 2: El checkbox con texto
```dart
CheckboxListTile(
  title: const Text('Bloquear slider'),
  value: _bloquear,
  onChanged: (valor) {
    setState(() {
      _bloquear = valor!;       // ⚠️ el ! porque el checkbox puede mandar null
    });
  },
)
```

## Paso a paso: Switch

### Paso 1: Misma variable (o otra)

### Paso 2: El switch con texto
```dart
SwitchListTile(
  title: const Text('Bloquear slider'),
  value: _bloquear,
  onChanged: (valor) {
    setState(() {
      _bloquear = valor;        // acá no hace falta el !
    });
  },
)
```

## Paso a paso: usar el valor

| Quiero | Código |
|---|---|
| Bloquear un slider | `onChanged: _bloquear ? null : (v) => setState(() => _valor = v)` |
| Bloquear un botón | `onPressed: _bloquear ? null : _accion` |
| Mostrar/ocultar algo | `if (_mostrar) const Text('Visible'),` dentro de `children` |
| Cambiar un color | `color: _activo ? Colors.green : Colors.red` |
| Mostrar el estado | `Text(_activo ? 'Activado' : 'Desactivado')` |

## Código final: slider + checkbox + switch (ejemplo de la cátedra)
```dart
import 'package:flutter/material.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({super.key});
  @override
  State<SliderPage> createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double _valorSlider = 200;
  bool _bloquearCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slider - Checks')),
      body: Container(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Slider(
              value: _valorSlider,
              min: 10,
              max: 400,
              onChanged: _bloquearCheck ? null : (v) => setState(() => _valorSlider = v),
            ),
            CheckboxListTile(
              title: const Text('Checkbox bloqueo slider'),
              value: _bloquearCheck,
              onChanged: (v) => setState(() => _bloquearCheck = v!),
            ),
            SwitchListTile(
              title: const Text('Switch bloqueo slider'),
              value: _bloquearCheck,
              onChanged: (v) => setState(() => _bloquearCheck = v),
            ),
            Expanded(child: Image.asset('assets/procer.png', width: _valorSlider)),
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
| Solo la casilla, sin texto | `Checkbox(value: _x, onChanged: (v) => setState(() => _x = v!))` |
| Solo el interruptor | `Switch(value: _x, onChanged: (v) => setState(() => _x = v))` |
| Casilla a la izquierda del texto | `controlAffinity: ListTileControlAffinity.leading` |
| Varias opciones excluyentes | `RadioListTile<String>(title: const Text('A'), value: 'A', groupValue: _opcion, onChanged: (v) => setState(() => _opcion = v!))` |
| Color | `activeColor: Colors.green` |

## Errores comunes
| Error | Solución |
|---|---|
| `A value of type 'bool?' can't be assigned to 'bool'` | En Checkbox usar `valor!` |
| No se tilda | Falta `setState` o `value:` no usa la variable |
