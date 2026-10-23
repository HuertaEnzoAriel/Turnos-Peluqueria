# 01 · Proyecto base

## Qué necesito
- VS Code con la extensión Flutter.
- Terminal (`Ctrl + Ñ` o `` Ctrl + ` ``).

## Paso a paso

### Paso 1: Crear el proyecto
En la terminal, parado en la carpeta donde lo querés:
```bash
flutter create --empty --offline practico
```
- `practico` = nombre del proyecto (minúsculas, sin espacios, sin guiones).
- `--empty` = sin el contador de ejemplo.
- `--offline` = no intenta descargar nada.

### Paso 2: Abrirlo
```bash
cd practico
code .
```

### Paso 3: Crear las carpetas
Clic derecho en `lib` → New Folder:
```
lib/
  main.dart
  src/
    pages/
      routes/
assets/          <- en la RAÍZ del proyecto (al lado de lib, no adentro)
```

### Paso 4: Poner la imagen (si hay imagen)
Arrastrá tu imagen a `assets/`. Nombre en minúsculas, sin espacios ni tildes: `assets/procer.png`.

### Paso 5: Declarar la imagen en `pubspec.yaml`
Buscá la sección `flutter:` al final y dejala así (2 espacios de indentación, sin tabs):
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/
```
`- assets/` incluye todo lo que haya en la carpeta.

Si vas a usar DatePicker en español, en `dependencies:` agregá:
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
```

### Paso 6: Escribir `lib/main.dart`
Borrá todo y pegá:
```dart
import 'package:flutter/material.dart';
import 'src/pages/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,   // saca la cinta DEBUG
      title: 'Práctico',
      initialRoute: '/',
      routes: getAplicationRoutes(),
    );
  }
}
```

### Paso 7: Crear `lib/src/pages/routes/routes.dart`
```dart
import 'package:flutter/material.dart';
import '../home_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return {
    '/': (context) => const HomePage(),
  };
}
```

### Paso 8: Crear `lib/src/pages/home_page.dart`
Escribí `stless` + Enter, poné de nombre `HomePage` y devolvé un Scaffold:
```dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: const Center(child: Text('Hola')),
    );
  }
}
```

### Paso 9: Correr
- Abajo a la derecha elegí el dispositivo (Windows, emulador, celular).
- `F5` para correr.
- Cada vez que guardás (`Ctrl + S`) se actualiza (hot reload).
- Si cambiaste `pubspec.yaml` o `main()`: **Hot Restart** (botón 🔄 verde de la barra de debug).

## Si quiero...
- **Sin rutas (una sola pantalla):** en `MaterialApp` cambiar `initialRoute` y `routes` por `home: const HomePage(),`.
- **Cambiar el color de toda la app:** en `MaterialApp` agregar `theme: ThemeData(colorSchemeSeed: Colors.red),`.

## Errores comunes
| Error | Solución |
|---|---|
| `Unable to load asset` | Revisar nombre exacto, indentación del pubspec, hacer Hot Restart |
| Error rojo en `import 'src/...'` | El archivo no existe o está en otra carpeta |
| No aparece el dispositivo | `flutter devices` en terminal |
