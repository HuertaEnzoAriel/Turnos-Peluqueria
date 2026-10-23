# Índice: un archivo por componente

Cada archivo tiene la misma estructura:
1. **Qué necesito** (stless o stful, variables, funciones)
2. **Paso a paso** numerado
3. **Código final completo** para copiar
4. **"Si quiero..."**: variantes (centrar, cambiar color, etc.)
5. **Errores comunes**

## Orden de estudio (de más probable a más raro)

| # | Archivo | Probabilidad |
|---|---|---|
| 01 | Proyecto base (crear, main, carpetas, pubspec) | ⭐⭐⭐ |
| 02 | Pantallas y navegación | ⭐⭐⭐ |
| 03 | Contador | ⭐⭐⭐ |
| 04 | Botones (normales y flotantes) | ⭐⭐⭐ |
| 05 | Imagen (cargar, ancho, posición) | ⭐⭐⭐ |
| 06 | Layout (centrar, filas, columnas, Stack) | ⭐⭐⭐ |
| 07 | Texto, estilos y colores | ⭐⭐⭐ |
| 08 | Formulario con validación | ⭐⭐⭐ |
| 09 | Pasar datos entre pantallas | ⭐⭐ |
| 10 | TextField (input, email, password) | ⭐⭐ |
| 11 | ListView y ListTile | ⭐⭐ |
| 12 | Card (tarjeta) | ⭐⭐ |
| 13 | AlertDialog y SnackBar | ⭐⭐ |
| 14 | AnimatedContainer / mover un componente | ⭐⭐ |
| 15 | Slider | ⭐⭐ |
| 16 | Checkbox y Switch | ⭐⭐ |
| 17 | Dropdown (lista desplegable) | ⭐ |
| 18 | DatePicker (selector de fecha) | ⭐ |
| 19 | CircleAvatar | ⭐ |
| 20 | Menú desde JSON (FutureBuilder) | ⭐ |
| 21 | Scroll infinito y pull to refresh | 🔹 |
| 22 | Drawer y BottomNavigationBar | 🔹 |

## Regla que sirve para TODOS
- ¿Algo cambia en pantalla cuando toco algo? → **`stful`** + variable en la clase `State` + **`setState`**.
- ¿Solo muestra cosas fijas? → **`stless`**.
- ¿Quiero envolver un widget en otro (Center, Padding, Column...)? → cursor encima + **`Ctrl + .`** → "Wrap with...".
- Sin internet: **nunca** `NetworkImage`. Siempre `Image.asset`.
