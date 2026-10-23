# 11 · ListView y ListTile

## Qué necesito
- `ListTile` = una fila de lista (ícono + título + subtítulo + algo a la derecha).
- `ListView` = contenedor con scroll para muchas filas.
- Para listas generadas desde datos: una `List` y `ListView.builder`.

## Paso a paso: una fila (ListTile)

### Paso 1: Fila básica
```dart
const ListTile(title: Text('Manuel Belgrano'))
```

### Paso 2: Agregar partes
```dart
ListTile(
  leading: const Icon(Icons.person, color: Colors.blue),   // izquierda
  title: const Text('Manuel Belgrano'),                    // título
  subtitle: const Text('Creador de la bandera'),           // debajo en gris
  trailing: const Icon(Icons.arrow_forward_ios),           // derecha
  onTap: () {},                                            // al tocar
)
```

### Paso 3: Que haga algo al tocar
```dart
onTap: () => Navigator.pushNamed(context, 'detalle'),
```

## Paso a paso: lista fija (pocos elementos)
```dart
body: ListView(
  children: const [
    ListTile(leading: Icon(Icons.flag), title: Text('Belgrano')),
    Divider(),
    ListTile(leading: Icon(Icons.flag), title: Text('San Martín')),
    Divider(),
    ListTile(leading: Icon(Icons.flag), title: Text('Sarmiento')),
  ],
),
```

## Paso a paso: lista desde datos (ListView.builder)

### Paso 1: Los datos (arriba del build)
```dart
final List<String> _proceres = ['Belgrano', 'San Martín', 'Sarmiento', 'Moreno'];
```

### Paso 2: El builder
```dart
body: ListView.builder(
  itemCount: _proceres.length,              // cuántas filas
  itemBuilder: (context, index) {           // cómo se dibuja cada fila
    return ListTile(
      leading: CircleAvatar(child: Text(_proceres[index][0])),   // inicial
      title: Text(_proceres[index]),
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: _proceres[index]),
    );
  },
),
```

### Paso 3 (opcional): con separadores
Cambiar `ListView.builder` por `ListView.separated` y agregar:
```dart
separatorBuilder: (context, index) => const Divider(),
```

## Paso a paso: datos con varios campos (lista de Maps)
```dart
final List<Map<String, String>> _proceres = [
  {'nombre': 'Belgrano', 'dato': 'Creó la bandera', 'img': 'assets/belgrano.png'},
  {'nombre': 'San Martín', 'dato': 'Cruzó los Andes', 'img': 'assets/sanmartin.png'},
];

ListView.builder(
  itemCount: _proceres.length,
  itemBuilder: (context, i) {
    final p = _proceres[i];
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(p['img']!)),
      title: Text(p['nombre']!),
      subtitle: Text(p['dato']!),
    );
  },
)
```
El `!` dice "sé que este dato no es nulo".

## Paso a paso: agregar y borrar de la lista (stful)
```dart
final List<String> _items = [];
final _ctrl = TextEditingController();

void _agregar() {
  if (_ctrl.text.isEmpty) return;
  setState(() {
    _items.add(_ctrl.text);
    _ctrl.clear();
  });
}

void _borrar(int i) => setState(() => _items.removeAt(i));

// en build:
Column(
  children: [
    Row(children: [
      Expanded(child: TextField(controller: _ctrl)),
      IconButton(onPressed: _agregar, icon: const Icon(Icons.add)),
    ]),
    Expanded(                                     // ⚠️ obligatorio: ListView dentro de Column
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(_items[i]),
          trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => _borrar(i)),
        ),
      ),
    ),
  ],
)
```

## Si quiero...
| Quiero | Hago |
|---|---|
| Lista horizontal | `ListView(scrollDirection: Axis.horizontal, ...)` (con altura fija: envolver en `SizedBox(height: 150, ...)`) |
| Espacio alrededor de la lista | `ListView(padding: const EdgeInsets.all(10), ...)` |
| Filas con fondo/tarjeta | Envolver cada `ListTile` en `Card` |
| ListTile con switch/checkbox | `SwitchListTile` / `CheckboxListTile` (archivo 16) |
| Deslizar para borrar | Envolver en `Dismissible(key: Key(item), onDismissed: (_) => setState(() => lista.remove(item)), child: ListTile(...))` |

## Errores comunes
| Error | Solución |
|---|---|
| `Vertical viewport was given unbounded height` | ListView dentro de Column → `Expanded(child: ListView(...))` |
| `RangeError (index)` | `itemCount` mayor que la lista real |
| La lista no se actualiza al agregar | Falta `setState` |
