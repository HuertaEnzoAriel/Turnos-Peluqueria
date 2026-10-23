# 05 · Imagen (cargar, ancho, posición)

## Qué necesito
- El archivo de imagen en la carpeta `assets/` (en la raíz del proyecto).
- Declararlo en `pubspec.yaml`.
- `Image.asset(...)` en el código.
- Si el ancho o la posición cambian con un botón/slider → `stful` + variables.

⚠️ **Sin internet no funciona `NetworkImage` ni `Image.network`.**

## Paso a paso: mostrar una imagen

### Paso 1: Copiar la imagen
Arrastrala a `assets/`. Nombre simple: `procer.png` (minúsculas, sin espacios, sin tildes, sin ñ).

### Paso 2: Declararla en `pubspec.yaml`
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/
```
Guardá. **Parar la app y volver a correrla** (o Hot Restart). El hot reload no alcanza.

### Paso 3: Mostrarla
```dart
Image.asset('assets/procer.png')
```
El texto tiene que ser **idéntico** al nombre del archivo, incluidas mayúsculas y extensión (`.png` ≠ `.PNG` ≠ `.jpg`).

### Paso 4: Darle tamaño
```dart
Image.asset(
  'assets/procer.png',
  width: 200,
  height: 250,
)
```
Si ponés solo `width`, el alto se ajusta solo manteniendo la proporción.

### Paso 5: Cómo se acomoda en ese tamaño (`fit`)
```dart
Image.asset('assets/procer.png', width: 200, height: 250, fit: BoxFit.cover)
```
| `fit` | Resultado |
|---|---|
| `BoxFit.contain` | Se ve **entera**, puede sobrar espacio |
| `BoxFit.cover` | **Llena** el espacio, recorta lo que sobra (la más usada) |
| `BoxFit.fill` | Llena estirando (se deforma) |
| `BoxFit.fitWidth` | Ocupa todo el ancho |
| `BoxFit.fitHeight` | Ocupa todo el alto |

### Paso 6: Posicionarla
| Quiero | Envuelvo con (`Ctrl + .` → Wrap with...) |
|---|---|
| Centrada | `Center(child: Image.asset(...))` |
| Centrada horizontalmente dentro de una Column | La Column con `crossAxisAlignment: CrossAxisAlignment.center` (es el default) |
| A la derecha / izquierda | `Align(alignment: Alignment.centerRight, child: ...)` |
| Arriba al centro | `Align(alignment: Alignment.topCenter, child: ...)` |
| Separada del borde | `Padding(padding: const EdgeInsets.all(20), child: ...)` |
| Separada solo arriba | `Padding(padding: const EdgeInsets.only(top: 30), child: ...)` |
| En coordenadas exactas | Dentro de un `Stack`: `Positioned(top: 50, left: 30, child: ...)` |

Valores de `Alignment`: `topLeft`, `topCenter`, `topRight`, `centerLeft`, `center`, `centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight`.

### Paso 7: Bordes redondeados
```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: Image.asset('assets/procer.png', width: 200, height: 250, fit: BoxFit.cover),
)
```

### Paso 8: Borde/marco alrededor
```dart
Container(
  decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 3)),
  child: Image.asset('assets/procer.png', width: 200),
)
```

## Paso a paso: cambiar el ancho con un Slider

1. `stful`.
2. Variable: `double _ancho = 200;`
3. Slider que cambia `_ancho` con `setState`.
4. Imagen con `width: _ancho`.

```dart
import 'package:flutter/material.dart';

class ImagenPage extends StatefulWidget {
  const ImagenPage({super.key});
  @override
  State<ImagenPage> createState() => _ImagenPageState();
}

class _ImagenPageState extends State<ImagenPage> {
  double _ancho = 200;
  Alignment _posicion = Alignment.center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imagen')),
      body: Column(
        children: [
          Slider(
            value: _ancho,
            min: 50,
            max: 350,
            onChanged: (valor) => setState(() => _ancho = valor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => setState(() => _posicion = Alignment.centerLeft), child: const Text('Izq')),
              ElevatedButton(onPressed: () => setState(() => _posicion = Alignment.center), child: const Text('Centro')),
              ElevatedButton(onPressed: () => setState(() => _posicion = Alignment.centerRight), child: const Text('Der')),
            ],
          ),
          Expanded(                         // ocupa el resto de la pantalla
            child: Align(
              alignment: _posicion,
              child: Image.asset('assets/procer.png', width: _ancho, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Pantalla tipo "prócer" (imagen arriba + datos + botón)
```dart
body: Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      const SizedBox(height: 20),
      Image.asset('assets/procer.png', width: 150, height: 180, fit: BoxFit.cover),
      const SizedBox(height: 20),
      const ListTile(
        leading: Icon(Icons.person),
        title: Text('Nombre'),
        subtitle: Text('Manuel Belgrano'),
      ),
      const ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text('Nacimiento'),
        subtitle: Text('1770'),
      ),
      const SizedBox(height: 20),
      ElevatedButton(onPressed: () {}, child: const Text('Ver más')),
    ],
  ),
),
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Imagen circular | `CircleAvatar(radius: 60, backgroundImage: const AssetImage('assets/procer.png'))` |
| Imagen de fondo de toda la pantalla | `Container(decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/fondo.png'), fit: BoxFit.cover)), child: ...)` |
| Que ocupe todo el ancho | `Image.asset('...', width: double.infinity, fit: BoxFit.cover)` |
| Cambiar la imagen con un botón | Variable `String _img = 'assets/a.png';` → `Image.asset(_img)` → botón con `setState(() => _img = 'assets/b.png')` |
| Placeholder sin archivo | `const FlutterLogo(size: 150)` o `Icon(Icons.image, size: 150)` |
| Imagen con fade al cargar | `FadeInImage(placeholder: const AssetImage('assets/loading.gif'), image: const AssetImage('assets/procer.png'))` |

## Errores comunes
| Error | Solución |
|---|---|
| `Unable to load asset: assets/...` | Nombre distinto (mayúsculas/extensión), falta en pubspec, o no reiniciaste la app |
| Error al guardar pubspec.yaml | Indentación: `assets:` a 2 espacios, `- assets/` a 4 espacios |
| Franja amarilla/negra (overflow) | La imagen es más grande que la pantalla: darle `width`/`height` o envolver en `SingleChildScrollView` |
| La imagen se ve deformada | Usar `BoxFit.cover` o `contain`, no `fill` |
