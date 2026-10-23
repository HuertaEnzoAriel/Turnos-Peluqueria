# 18 · DatePicker (selector de fecha)

## Qué necesito
- **`stful`**.
- Un `TextEditingController` para mostrar la fecha en el campo.
- Un `TextField` con `readOnly: true` y `onTap` que abre el calendario.
- Función `async` con `await showDatePicker(...)`.
- (Opcional, para español) `flutter_localizations` en pubspec + delegates en `MaterialApp`.

## Paso a paso

### Paso 1: Variable controller
```dart
final _fechaCtrl = TextEditingController();
```

### Paso 2: Campo que abre el calendario
```dart
TextField(
  controller: _fechaCtrl,
  readOnly: true,                        // no abre el teclado
  decoration: InputDecoration(
    labelText: 'Fecha de nacimiento',
    icon: const Icon(Icons.calendar_today),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  ),
  onTap: () => _seleccionarFecha(context),
)
```

### Paso 3: Función que abre el calendario
```dart
Future<void> _seleccionarFecha(BuildContext context) async {
  final DateTime? fecha = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900),           // ⚠️ rango AMPLIO
    lastDate: DateTime(2100),
  );

  if (fecha != null) {                   // null = apretó Cancelar
    setState(() {
      _fechaCtrl.text = '${fecha.day}/${fecha.month}/${fecha.year}';
    });
  }
}
```

⚠️ En los apuntes usan `lastDate: DateTime(2024)` o `2025`. Hoy es **2026**: `DateTime.now()` queda afuera del rango y **la app se cae**. Siempre rango amplio.

### Paso 4: Calendario en español (opcional)
**4a.** En `pubspec.yaml`, dentro de `dependencies:`
```yaml
  flutter_localizations:
    sdk: flutter
```
**4b.** En `main.dart`:
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
...
MaterialApp(
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [Locale('en'), Locale('es', 'ES')],
  ...
)
```
**4c.** En el `showDatePicker`:
```dart
locale: const Locale('es', 'ES'),
```
Parar y volver a correr la app.

⚠️ Como es una dependencia del SDK, debería funcionar offline. **Probalo antes en modo avión.** Si falla, sacá el paso 4 completo y el calendario queda en inglés, pero funciona.

## Código final
```dart
import 'package:flutter/material.dart';

class FechaPage extends StatefulWidget {
  const FechaPage({super.key});
  @override
  State<FechaPage> createState() => _FechaPageState();
}

class _FechaPageState extends State<FechaPage> {
  final _fechaCtrl = TextEditingController();

  @override
  void dispose() {
    _fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (fecha != null) {
      setState(() => _fechaCtrl.text = '${fecha.day}/${fecha.month}/${fecha.year}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fecha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _fechaCtrl,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Fecha de nacimiento',
            icon: const Icon(Icons.calendar_today),
            suffixIcon: const Icon(Icons.perm_contact_calendar),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onTap: () => _seleccionarFecha(context),
        ),
      ),
    );
  }
}
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Formato con ceros (05/09/2026) | `'${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}'` |
| Formato de los apuntes (2023-09-08 00:00:00.000) | `fecha.toString()` |
| Solo fechas pasadas (nacimiento) | `lastDate: DateTime.now()` |
| Elegir hora | `final hora = await showTimePicker(context: context, initialTime: TimeOfDay.now());` → `hora.format(context)` |
| Calcular edad | `DateTime.now().year - fecha.year` (aproximado) |

## Errores comunes
| Error | Solución |
|---|---|
| `initialDate must be on or before lastDate` | Ampliar `lastDate` |
| `No MaterialLocalizations found` / pantalla roja al usar `locale:` | Faltan los delegates en `MaterialApp` |
| El teclado se abre al tocar | Falta `readOnly: true` |
