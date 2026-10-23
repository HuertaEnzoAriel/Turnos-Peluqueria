# 04 · Botones (normales y flotantes)

## Qué necesito
- Saber **qué hace** el botón → una función o una acción en `onPressed`.
- Si el botón cambia algo en pantalla → la pantalla debe ser `stful` y la función usa `setState`.

## Tipos de botón
| Botón | Aspecto | Código |
|---|---|---|
| `ElevatedButton` | Relleno, con sombra | `ElevatedButton(onPressed: () {}, child: const Text('OK'))` |
| `TextButton` | Solo texto | `TextButton(onPressed: () {}, child: const Text('OK'))` |
| `OutlinedButton` | Con borde | `OutlinedButton(onPressed: () {}, child: const Text('OK'))` |
| `IconButton` | Solo ícono | `IconButton(onPressed: () {}, icon: const Icon(Icons.star))` |
| `FloatingActionButton` | Círculo flotante | `FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add))` |

## Paso a paso: botón normal

### Paso 1: Escribir el botón donde va
Dentro de los `children` de una `Column` o como `child` de un `Center`:
```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Aceptar'),
)
```

### Paso 2: Darle una acción
Opción A, acción corta en el lugar:
```dart
onPressed: () => Navigator.pushNamed(context, 'segunda'),
```
Opción B, función aparte (recomendado si hace más de una cosa):
```dart
onPressed: _aceptar,
...
void _aceptar() {
  setState(() {
    // cambiar variables
  });
}
```

### Paso 3: Estilo (color, tamaño, forma)
```dart
ElevatedButton(
  onPressed: _aceptar,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,         // color de fondo
    foregroundColor: Colors.white,        // color de texto/ícono
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),  // tamaño
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // redondeo
  ),
  child: const Text('Aceptar'),
)
```

### Paso 4: Separar varios botones
Entre botones en una Column: `const SizedBox(height: 10),`
Entre botones en una Row: `const SizedBox(width: 10),`

## Paso a paso: botón flotante

### Paso 1: Va en el Scaffold, no en el body
```dart
return Scaffold(
  appBar: ...,
  body: ...,
  floatingActionButton: FloatingActionButton(
    onPressed: _sumar,
    child: const Icon(Icons.add),
  ),
);
```

### Paso 2: Cambiar su posición (en el Scaffold)
```dart
floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
```
| Valor | Posición |
|---|---|
| `endFloat` | Abajo a la derecha (default) |
| `centerFloat` | Abajo al centro |
| `startFloat` | Abajo a la izquierda |
| `endTop` / `startTop` | Arriba |

### Paso 3: Varios botones flotantes
Envolver en `Column` (vertical) o `Row` (horizontal), con `heroTag` distinto en cada uno:
```dart
floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton(heroTag: 'a', onPressed: _a, child: const Icon(Icons.add)),
    const SizedBox(height: 10),
    FloatingActionButton(heroTag: 'b', onPressed: _b, child: const Icon(Icons.remove)),
  ],
),
```

### Paso 4: Flotante con texto
```dart
FloatingActionButton.extended(
  onPressed: _mover,
  icon: const Icon(Icons.play_arrow),
  label: const Text('Mover'),
)
```

### Paso 5: Color
```dart
FloatingActionButton(backgroundColor: Colors.orange, foregroundColor: Colors.white, ...)
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Botón con ícono y texto | `ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.send), label: const Text('Enviar'))` |
| Botón deshabilitado (gris) | `onPressed: null` |
| Deshabilitado según condición | `onPressed: _activo ? _accion : null` |
| Botón de **ancho completo** | Envolver en `SizedBox(width: double.infinity, child: ElevatedButton(...))` |
| Botón de tamaño fijo | `SizedBox(width: 200, height: 50, child: ElevatedButton(...))` |
| Botón circular normal | `style: ElevatedButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(20))` |
| Botones en fila centrados | `Row(mainAxisAlignment: MainAxisAlignment.center, children: [...])` |
| Botones repartidos en la fila | `mainAxisAlignment: MainAxisAlignment.spaceEvenly` |
| Botón en el AppBar | `AppBar(actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))])` |
| FAB chico | `FloatingActionButton.small(...)` |

## Errores comunes
| Síntoma | Causa |
|---|---|
| `multiple heroes that share the same tag` | Varios FAB sin `heroTag` distinto |
| La acción se ejecuta al abrir la pantalla | `onPressed: _accion()` → sacar los paréntesis |
| El botón no hace nada visible | Falta `setState` en la función |
| Columna de FABs ocupa toda la pantalla | Falta `mainAxisSize: MainAxisSize.min` |
