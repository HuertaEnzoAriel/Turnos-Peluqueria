# 03 · Contador

## Qué necesito
- **`stful`** (el número cambia → necesita estado).
- Una variable `int _conteo = 0;` **dentro de la clase State**.
- Funciones: `_sumar()`, `_restar()`, `_reset()` (y las que pidan: `_multiplicar()`, etc.).
- Cada función cambia la variable **dentro de `setState`**.
- Un `Text` que muestre la variable y botones que llamen a las funciones.

## Paso a paso

### Paso 1: Crear el archivo
`lib/src/pages/contador_page.dart`.

### Paso 2: Escribir `stful` + Enter
Nombre: `ContadorPage`. VS Code crea DOS clases:
- `ContadorPage` (no se toca)
- `_ContadorPageState` (**acá va todo**)

### Paso 3: Declarar la variable
Dentro de `_ContadorPageState`, **arriba del `build`**:
```dart
int _conteo = 0;
```
⚠️ Si la ponés dentro de `build`, se reinicia a 0 en cada redibujado y nunca cambia.

### Paso 4: Armar la pantalla con Scaffold
Reemplazá el `return Placeholder();` por:
```dart
return Scaffold(
  appBar: AppBar(title: const Text('Contador')),
  body: Text('$_conteo'),
);
```
`'$_conteo'` convierte el número a texto (Text solo acepta String).

### Paso 5: Centrarlo
Cursor sobre `Text` → `Ctrl + .` → **Wrap with Center**:
```dart
body: Center(child: Text('$_conteo')),
```

### Paso 6: Agregar un título arriba del número
Cursor sobre `Text` → `Ctrl + .` → **Wrap with Column**. Agregá el otro texto adentro de `children`:
```dart
body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,   // centra en vertical
    children: [
      const Text('Número de clicks:', style: TextStyle(fontSize: 25)),
      Text('$_conteo', style: const TextStyle(fontSize: 25)),
    ],
  ),
),
```
Sin `mainAxisAlignment: MainAxisAlignment.center` la columna queda pegada arriba.

### Paso 7: Crear la función `_sumar`
Debajo del `build` (pero dentro de la clase State):
```dart
void _sumar() {
  setState(() {
    _conteo++;
  });
}
```
`setState` = "cambié algo, redibujá la pantalla".

### Paso 8: Conectarla a un botón flotante
En el `Scaffold`, al lado de `body:`:
```dart
floatingActionButton: FloatingActionButton(
  onPressed: _sumar,               // SIN paréntesis: le paso la función
  child: const Icon(Icons.add),
),
```
⚠️ `onPressed: _sumar()` (con paréntesis) la ejecuta al dibujar y da error. Va sin paréntesis, o `onPressed: () => _sumar()`.

### Paso 9: Agregar restar y reset
```dart
void _restar() {
  setState(() {
    if (_conteo > 0) _conteo--;    // no baja de 0
  });
}

void _reset() {
  setState(() {
    _conteo = 0;
  });
}
```

### Paso 10: Poner varios botones flotantes
`floatingActionButton` acepta UN widget. Para varios, envolvelos en `Column` (vertical) o `Row` (horizontal):
```dart
floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,     // que la columna no ocupe toda la altura
  children: [
    FloatingActionButton(heroTag: 'reset', onPressed: _reset, child: const Icon(Icons.exposure_zero)),
    const SizedBox(height: 10),
    FloatingActionButton(heroTag: 'restar', onPressed: _restar, child: const Icon(Icons.remove)),
    const SizedBox(height: 10),
    FloatingActionButton(heroTag: 'sumar', onPressed: _sumar, child: const Icon(Icons.add)),
  ],
),
```
⚠️ Cada botón flotante necesita un **`heroTag` distinto**, si no da error al navegar.

### Paso 11 (si lo piden): botón normal debajo del número
Dentro de los `children` de la Column del body:
```dart
const SizedBox(height: 20),
ElevatedButton(
  onPressed: _multiplicar,
  child: const Text('Multiplicar por 2'),
),
```
```dart
void _multiplicar() {
  setState(() {
    _conteo *= 2;
  });
}
```

### Paso 12 (si lo piden): guardar resultados en una lista
```dart
final List<int> _guardados = [];   // variable arriba, junto a _conteo

void _guardar() => setState(() => _guardados.add(_conteo));
void _vaciar()  => setState(() => _guardados.clear());
```
Y mostrarla: `Text('Resultados guardados: $_guardados'),` → muestra `[0, 2, 4, 8]`.

## Código final completo
```dart
import 'package:flutter/material.dart';

class ContadorPage extends StatefulWidget {
  const ContadorPage({super.key});

  @override
  State<ContadorPage> createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  int _conteo = 0;
  final List<int> _guardados = [];
  final _estilo = const TextStyle(fontSize: 25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Número de clicks:', style: _estilo),
            Text('$_conteo', style: _estilo),
            const SizedBox(height: 10),
            Text('Resultados guardados: $_guardados'),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _multiplicar, child: const Text('Multiplicar por 2')),
            ElevatedButton(onPressed: _guardar, child: const Text('Guardar resultado')),
            ElevatedButton(onPressed: _vaciar, child: const Text('Vaciar resultados')),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(heroTag: 'reset', onPressed: _reset, child: const Icon(Icons.exposure_zero)),
          const SizedBox(height: 10),
          FloatingActionButton(heroTag: 'restar', onPressed: _restar, child: const Icon(Icons.remove)),
          const SizedBox(height: 10),
          FloatingActionButton(heroTag: 'sumar', onPressed: _sumar, child: const Icon(Icons.add)),
        ],
      ),
    );
  }

  void _sumar() => setState(() => _conteo++);
  void _restar() => setState(() { if (_conteo > 0) _conteo--; });
  void _reset() => setState(() => _conteo = 0);
  void _multiplicar() => setState(() => _conteo *= 2);
  void _guardar() => setState(() => _guardados.add(_conteo));
  void _vaciar() => setState(() => _guardados.clear());
}
```
Después: registrar `'contador': (context) => const ContadorPage(),` en routes.dart.

## Si quiero...
| Quiero | Hago |
|---|---|
| Botones flotantes en **horizontal** | Cambiar `Column` por `Row` en `floatingActionButton` (y `height` por `width` en los SizedBox) |
| Uno a la izquierda y dos a la derecha | `Row` con `const SizedBox(width: 30)` + botón + `const Spacer()` + botones |
| Botones flotantes **centrados abajo** | En el Scaffold: `floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,` |
| Sumar de a 5 | `_conteo += 5;` |
| Límite máximo 10 | `if (_conteo < 10) _conteo++;` |
| Número más grande/negrita | `style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)` |
| Color del número según valor | `style: TextStyle(color: _conteo > 5 ? Colors.red : Colors.black)` |
| Cambiar color de los botones | `FloatingActionButton(backgroundColor: Colors.orange, ...)` |

## Errores comunes
| Síntoma | Causa |
|---|---|
| Aprieto y el número no cambia | Falta `setState`, o la variable está dentro de `build`, o la clase es `stless` |
| `The argument type 'int' can't be assigned to 'String'` | `Text(_conteo)` → debe ser `Text('$_conteo')` |
| `multiple heroes that share the same tag` | Falta `heroTag` distinto en cada FAB |
| El botón se ejecuta solo al abrir | Pusiste `onPressed: _sumar()` con paréntesis |
