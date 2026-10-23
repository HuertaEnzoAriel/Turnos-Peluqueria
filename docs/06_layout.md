# 06 · Layout: acomodar cosas en pantalla

## Qué necesito
Saber qué "caja" usar según lo que quiero. Todas se agregan igual: **cursor sobre el widget → `Ctrl + .` → Wrap with...**

Regla: widgets con **`child:`** tienen UN hijo. Widgets con **`children: [ ]`** tienen VARIOS.

## Recetario: "quiero X → uso Y"

### Quiero centrar algo
```dart
Center(child: Text('Hola'))
```

### Quiero cosas una debajo de otra
```dart
Column(
  children: [
    Text('Uno'),
    Text('Dos'),
  ],
)
```

### Quiero cosas una al lado de otra
```dart
Row(
  children: [
    Icon(Icons.star),
    Text('Favorito'),
  ],
)
```

### Quiero centrar una Column en la pantalla
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,   // centro vertical
    children: [...],
  ),
)
```

### Quiero alinear los elementos de una Column o Row
**Eje principal** (`mainAxisAlignment`) = la dirección en la que se apilan (Column → vertical, Row → horizontal).
**Eje cruzado** (`crossAxisAlignment`) = el otro.

| `mainAxisAlignment` | Efecto |
|---|---|
| `start` | Al inicio (default) |
| `center` | Al centro |
| `end` | Al final |
| `spaceBetween` | Primero y último pegados a los bordes, resto repartido |
| `spaceAround` | Espacio alrededor de cada uno |
| `spaceEvenly` | Espacios iguales |

| `crossAxisAlignment` | Efecto |
|---|---|
| `start` | Pegados a la izquierda (en Column) |
| `center` | Centrados (default) |
| `end` | A la derecha (en Column) |
| `stretch` | Estirados a todo el ancho |

### Quiero espacio entre elementos
```dart
const SizedBox(height: 20),   // en Column
const SizedBox(width: 20),    // en Row
```

### Quiero espacio alrededor (margen interno)
```dart
Padding(
  padding: const EdgeInsets.all(16),        // todos los lados
  child: ...,
)
```
Variantes de `EdgeInsets`:
- `EdgeInsets.all(16)`
- `EdgeInsets.symmetric(horizontal: 20, vertical: 10)`
- `EdgeInsets.only(top: 30, left: 10)`

### Quiero una caja con color, tamaño, borde, sombra
```dart
Container(
  width: 150,
  height: 100,
  margin: const EdgeInsets.all(10),     // espacio AFUERA
  padding: const EdgeInsets.all(10),    // espacio ADENTRO
  decoration: BoxDecoration(
    color: Colors.blue,                 // ⚠️ el color va ACÁ si usás decoration
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 6))],
  ),
  child: const Text('Caja'),
)
```

### Quiero que algo ocupe el espacio que sobra
```dart
Row(
  children: [
    const Text('Izq'),
    Expanded(child: Container(color: Colors.red, height: 50)),   // ocupa todo lo restante
    const Text('Der'),
  ],
)
```
- Dos `Expanded` → se reparten mitad y mitad.
- `Expanded(flex: 2, ...)` + `Expanded(flex: 1, ...)` → 2/3 y 1/3.
- `const Spacer()` → espacio vacío que empuja.

### Quiero poner cosas encima de otras (superpuestas)
```dart
Stack(
  children: [
    Container(color: Colors.blue, width: 300, height: 300),         // fondo
    Positioned(top: 20, left: 20, child: const Text('Arriba izq')),
    Positioned(bottom: 20, right: 20, child: const Text('Abajo der')),
    const Center(child: Text('Centro')),
  ],
)
```
- `Positioned` solo funciona **dentro de un Stack**.
- Valores negativos (`top: -50`) lo sacan parcialmente de la pantalla.
- `Align(alignment: Alignment.bottomCenter, child: ...)` también sirve dentro del Stack.

### Quiero que la pantalla haga scroll (tiene mucho contenido)
```dart
body: SingleChildScrollView(
  child: Column(children: [...]),
)
```

### Quiero una línea separadora
```dart
const Divider(),                                  // horizontal
const Divider(thickness: 2, color: Colors.grey),
```

### Quiero una cuadrícula
```dart
GridView.count(
  crossAxisCount: 2,                // 2 columnas
  children: [Container(color: Colors.red), Container(color: Colors.blue)],
)
```

### Quiero círculos con degradé
```dart
Container(
  width: 200,
  height: 200,
  decoration: const BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.purple, Colors.pinkAccent],
    ),
  ),
)
```

## Paso a paso para replicar una pantalla de una imagen
1. Mirá la pantalla de **arriba hacia abajo**: cada "bloque" es un hijo de una `Column`.
2. Si en un bloque hay cosas **una al lado de otra**, ese bloque es una `Row`.
3. Si hay cosas **encima de otras**, ese bloque es un `Stack`.
4. Espacios entre bloques → `SizedBox`.
5. Márgenes de la pantalla → envolver todo en `Padding`.
6. Si no entra en la pantalla → envolver en `SingleChildScrollView`.

Ejemplo:
```
[ AppBar azul "Datos" ]      -> AppBar(backgroundColor: Colors.blue)
[    imagen centrada   ]      -> Image.asset (la Column centra en horizontal por default)
[ ícono  texto   texto ]      -> ListTile o Row
[ ícono  texto   texto ]      -> ListTile o Row
[      [ botón ]       ]      -> ElevatedButton
```

## Errores comunes
| Error | Solución |
|---|---|
| Franja amarilla/negra `RenderFlex overflowed` | No entra: `SingleChildScrollView`, `Expanded` o achicar |
| `Vertical viewport was given unbounded height` | `ListView` dentro de `Column` → envolver el ListView con `Expanded` |
| `Cannot provide both a color and a decoration` | En Container, mover `color:` dentro de `BoxDecoration` |
| `Positioned` no se mueve / error | Tiene que estar dentro de un `Stack` |
| La Column no se centra verticalmente | Falta `mainAxisAlignment: MainAxisAlignment.center` |
