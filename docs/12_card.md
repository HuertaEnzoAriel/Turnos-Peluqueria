# 12 · Card (tarjeta)

## Qué necesito
- `Card` = caja con bordes redondeados y sombra. Tiene UN `child`.
- Adentro casi siempre va una `Column` con lo que quiero mostrar.
- Puede ser `stless` (no cambia nada).

## Paso a paso: tarjeta de texto con botones

### Paso 1: La tarjeta vacía
```dart
Card(
  child: Column(
    children: [],
  ),
)
```

### Paso 2: Contenido: un ListTile
```dart
const ListTile(
  leading: Icon(Icons.photo_album, color: Colors.blue),
  title: Text('Título de la tarjeta'),
  subtitle: Text('Texto que describe la tarjeta'),
),
```

### Paso 3: Botones a la derecha abajo
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.end,   // a la derecha
  children: [
    TextButton(onPressed: () {}, child: const Text('Cancelar')),
    TextButton(onPressed: () {}, child: const Text('OK')),
  ],
),
```

### Paso 4: Sombra y bordes
```dart
Card(
  elevation: 10,                                                          // sombra
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // redondeo
  margin: const EdgeInsets.all(10),                                       // separación externa
  child: ...,
)
```

## Paso a paso: tarjeta con imagen

### Paso 1: Card con `clipBehavior` para que la imagen respete el redondeo
```dart
Card(
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  elevation: 5,
  child: Column(
    children: [
      // imagen y texto
    ],
  ),
)
```

### Paso 2: Imagen arriba
```dart
Image.asset(
  'assets/procer.png',
  height: 200,
  width: double.infinity,     // todo el ancho de la tarjeta
  fit: BoxFit.cover,
),
```

### Paso 3: Texto abajo
```dart
const Padding(
  padding: EdgeInsets.all(10),
  child: Text('Manuel Belgrano', style: TextStyle(fontSize: 18)),
),
```

## Código final: pantalla con dos tarjetas
```dart
import 'package:flutter/material.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.photo_album, color: Colors.blue),
                  title: Text('Título de la Tarjeta'),
                  subtitle: Text('Este texto forma parte del cuerpo de la tarjeta.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Cancelar')),
                    TextButton(onPressed: () {}, child: const Text('OK')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Image.asset('assets/procer.png', height: 250, width: double.infinity, fit: BoxFit.cover),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Descripción de la imagen'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Color de fondo de la tarjeta | `Card(color: Colors.amber[50], ...)` |
| Tarjeta tocable | Envolver el contenido con `InkWell(onTap: () {}, child: ...)` |
| Tarjeta de ancho fijo centrada | `Center(child: SizedBox(width: 300, child: Card(...)))` |
| "Tarjeta" hecha con Container | `Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 8))]), child: ClipRRect(borderRadius: BorderRadius.circular(30), child: ...))` |

## Errores comunes
| Error | Solución |
|---|---|
| La imagen se sale de las esquinas redondeadas | Falta `clipBehavior: Clip.antiAlias` |
| Overflow con varias tarjetas | Poner las tarjetas en `ListView`, no en `Column` |
