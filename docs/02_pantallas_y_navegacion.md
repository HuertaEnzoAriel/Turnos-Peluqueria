# 02 · Pantallas y navegación

## Qué necesito
- Un archivo por pantalla en `lib/src/pages/`.
- El archivo `routes.dart` (ver 01).
- Un botón que navegue.

Para agregar una pantalla hay que hacer **3 cosas**: crear el archivo, registrarla en rutas y poner un botón que lleve a ella.

## Paso a paso

### Paso 1: Crear el archivo de la pantalla
`lib/src/pages/segunda_page.dart` → escribir `stless` + Enter → nombre `SegundaPage`.

### Paso 2: Devolver un Scaffold
```dart
import 'package:flutter/material.dart';

class SegundaPage extends StatelessWidget {
  const SegundaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda')),
      body: const Center(child: Text('Estoy en la segunda pantalla')),
    );
  }
}
```

### Paso 3: Registrarla en `routes.dart`
```dart
import '../segunda_page.dart';        // 1) importar

Map<String, WidgetBuilder> getAplicationRoutes() {
  return {
    '/': (context) => const HomePage(),
    'segunda': (context) => const SegundaPage(),   // 2) agregar línea
  };
}
```
El texto `'segunda'` es el **nombre de la ruta**. Lo vas a usar en el botón.

### Paso 4: Botón para ir
En la pantalla de origen (ej. HomePage):
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, 'segunda');
  },
  child: const Text('Ir a segunda'),
)
```

### Paso 5: Volver
Con `pushNamed`, el AppBar muestra la flecha ← automáticamente. Si querés un botón propio:
```dart
ElevatedButton(
  onPressed: () => Navigator.pop(context),
  child: const Text('Volver'),
)
```

## Código final: Home con 3 botones a 3 pantallas
```dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'contador'),
              child: const Text('Contador'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'imagen'),
              child: const Text('Imagen'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, 'formulario'),
              child: const Text('Formulario'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Si quiero...
- **Menú tipo lista con flechas:** usar `ListTile` (ver archivo 11):
  ```dart
  ListTile(
    leading: const Icon(Icons.person),
    title: const Text('Contador'),
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: () => Navigator.pushNamed(context, 'contador'),
  )
  ```
- **Ir sin rutas con nombre:**
  ```dart
  Navigator.push(context, MaterialPageRoute(builder: (context) => const SegundaPage()));
  ```
- **Ir y que NO se pueda volver** (ej. después de un login):
  ```dart
  Navigator.pushReplacementNamed(context, 'segunda');
  ```
- **Sacar la flecha de volver:** `AppBar(automaticallyImplyLeading: false, ...)`.
- **Pasar datos a la otra pantalla:** ver archivo 09.

## Errores comunes
| Error | Solución |
|---|---|
| `Could not find a generator for route "x"` | La ruta no está en `routes.dart` o el nombre está mal escrito |
| Rojo en el nombre de la clase en routes.dart | Falta el `import` → `Ctrl + .` → Import library |
| `Navigator operation requested with a context that does not include a Navigator` | Estás navegando desde `MyApp`. Navegá desde una pantalla (HomePage) |
