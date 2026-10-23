# 07 · Texto, estilos y colores

Es clave para que la app quede **idéntica** a la que te muestran.

## Paso a paso: un texto con estilo

### Paso 1: Texto básico
```dart
const Text('Manuel Belgrano')
```

### Paso 2: Agregar estilo
```dart
const Text(
  'Manuel Belgrano',
  style: TextStyle(
    fontSize: 24,                     // tamaño
    fontWeight: FontWeight.bold,      // negrita
    color: Colors.blue,               // color
    fontStyle: FontStyle.italic,      // cursiva
    letterSpacing: 1.5,               // espacio entre letras
  ),
)
```

### Paso 3: Alinear el texto
```dart
Text('Texto largo...', textAlign: TextAlign.center)   // left, right, justify
```

### Paso 4: Mostrar una variable
```dart
Text('Nombre: $_nombre')              // variable simple
Text('Total: ${_lista.length}')       // expresión → con llaves
Text('$_conteo')                      // número a texto
```

### Paso 5: Reutilizar un estilo
Definilo una vez arriba de `build` y usalo muchas veces:
```dart
final _titulo = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
...
Text('Hola', style: _titulo),
Text('Chau', style: _titulo),
```

## Colores

### Formas de escribir un color
| Forma | Ejemplo |
|---|---|
| Color predefinido | `Colors.red`, `Colors.blue`, `Colors.green` |
| Tono más claro/oscuro | `Colors.red[100]` (clarito) ... `Colors.red[900]` (oscuro) |
| Variante "accent" | `Colors.redAccent`, `Colors.blueAccent` |
| Hexadecimal | `const Color(0xFFE57373)` → `0xFF` + código hex |
| RGB | `Color.fromRGBO(229, 115, 115, 1)` |
| Transparente | `Colors.transparent` |
| Con transparencia | `Colors.black26`, `Colors.black54` |

Para copiar un color de una captura: si te dan el hex `#E57373`, escribí `Color(0xFFE57373)`.

### Dónde se pone el color
| Elemento | Propiedad |
|---|---|
| AppBar | `AppBar(backgroundColor: Colors.red, foregroundColor: Colors.white)` |
| Fondo de la pantalla | `Scaffold(backgroundColor: Colors.grey[200])` |
| Texto | `TextStyle(color: Colors.red)` |
| Ícono | `Icon(Icons.star, color: Colors.amber)` |
| Botón | `ElevatedButton.styleFrom(backgroundColor: ..., foregroundColor: ...)` |
| Botón flotante | `FloatingActionButton(backgroundColor: ...)` |
| Container | `Container(color: ...)` o dentro de `BoxDecoration(color: ...)` |

### Color de TODA la app de una vez
En `main.dart`, dentro de `MaterialApp`:
```dart
theme: ThemeData(
  colorSchemeSeed: Colors.blue,     // genera toda la paleta a partir de este color
  useMaterial3: true,
),
```
Si querés el estilo "viejo" (AppBar azul fuerte con texto blanco como en los apuntes):
```dart
theme: ThemeData(
  useMaterial3: false,
  primarySwatch: Colors.blue,
),
```

## AppBar como en la imagen del examen
```dart
AppBar(
  title: const Text('Datos del prócer'),
  centerTitle: true,                     // título centrado
  backgroundColor: Colors.red[300],      // rojo suave
  foregroundColor: Colors.white,         // texto e íconos blancos
  elevation: 4,                          // sombra
)
```

## Íconos
```dart
const Icon(Icons.person, size: 30, color: Colors.blue)
```
Para buscar un ícono: escribí `Icons.` y el autocompletado muestra la lista con vista previa. Nombres útiles: `person`, `home`, `add`, `remove`, `delete`, `edit`, `search`, `star`, `favorite`, `calendar_today`, `email`, `lock`, `info`, `arrow_back`, `arrow_forward_ios`, `check`, `close`, `school`, `flag`, `history_edu`.

## Errores comunes
| Error | Solución |
|---|---|
| `The argument type 'int' can't be assigned to 'String'` | `Text('$numero')` |
| Color del AppBar no cambia | Con Material 3 a veces el tema lo pisa: poner `backgroundColor` directo en el AppBar |
| `Invalid constant value` | Sacar el `const` de adelante si adentro hay una variable |
