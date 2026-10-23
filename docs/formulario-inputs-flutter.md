# Formulario de Inputs en Flutter — App "Componentes"

> Material: *Componentes de Flutter - Parte 2*, secciones 7 a 11
> Cátedra: Programación para Móviles — Tecnicatura Universitaria en Programación Web — FCEFN, UNSJ

---

## Índice

1. [Qué pide la cátedra](#1-qué-pide-la-cátedra)
2. [Conceptos previos](#2-conceptos-previos)
3. [Pasos de integración en la app](#3-pasos-de-integración-en-la-app)
4. [Guía por input](#4-guía-por-input)
   - [4.1 Input de texto (Nombre)](#41-input-de-texto-nombre)
   - [4.2 Input de Email](#42-input-de-email)
   - [4.3 Input de Password](#43-input-de-password)
   - [4.4 Input de Fecha (Datepicker)](#44-input-de-fecha-datepicker)
   - [4.5 Dropdown (Lista desplegable)](#45-dropdown-lista-desplegable)
   - [4.6 ListTile de salida](#46-listtile-de-salida)
5. [Archivo completo input_page.dart](#5-archivo-completo-input_pagedart)
6. [Tabla de referencia de propiedades](#6-tabla-de-referencia-de-propiedades)
7. [Errores comunes](#7-errores-comunes)

---

## 1. Qué pide la cátedra

El "formulario" del práctico es la página **Inputs** de la app Componentes. No se usa el
widget `Form` con validación: se trabaja con **campos sueltos** (`TextField`) que guardan su
valor en variables del `State` mediante `onChanged` + `setState`, y un `ListTile` final que
muestra lo cargado en tiempo real.

El apunte menciona `TextFormField` solo de forma teórica:

> *TextFormField envuelve un TextField y lo integra con el Form adjunto. Esto proporciona una
> funcionalidad adicional, como la validación y la integración con otros widgets FormField.*

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Enter your username'
  ),
);
```

Pero **todos los ejemplos implementados usan `TextField`**, no `TextFormField`.

El formulario final (sección 11) contiene **5 inputs**:

| # | Input | Widget | Variable del State |
|---|-------|--------|--------------------|
| 1 | Nombre | `TextField` | `_nombre` |
| 2 | Email | `TextField` | `_email` |
| 3 | Password | `TextField` | *(no se guarda)* |
| 4 | Fecha de nacimiento | `TextField` + `showDatePicker` | `_fecha` |
| 5 | Profesión | `DropdownButton` | `_opcionSeleccionadaDropdown` |

Más el `ListTile` (`_crearPersona`) que muestra los valores.

---

## 2. Conceptos previos

### 2.1 Por qué StatefulWidget

Según el apunte de *Introducción al framework Flutter*:

> *Si la propiedad que se define dentro del widget posiblemente cambie en el tiempo, como por
> ejemplo, un cuadro de texto de un formulario donde el usuario debe completar su nombre. En
> ese caso, el componente debería ser del tipo statefulwidget.*

Un `StatelessWidget` solo admite propiedades `final` o `const`, que no pueden cambiar. Como
el usuario va a escribir en los campos, la página **debe** ser `StatefulWidget`.

Estructura obligatoria: **2 clases**.

```dart
// 1) El widget en sí
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

// 2) El manejador de estado (privado, lleva "State" en el nombre)
class _InputPageState extends State<InputPage> {
  // aquí van las propiedades y los métodos
}
```

### 2.2 El rol de setState

`setState` es lo que **redibuja el widget**. Sin `setState`, la variable cambia pero la
pantalla no se entera. Patrón que se repite en todos los inputs:

```dart
onChanged: (valor) {
  setState(() {
    _nombre = valor;   // 1) guardo el valor
  });                  // 2) setState redibuja
},
```

### 2.3 El guión bajo (_)

Las propiedades y métodos llevan `_` adelante para hacerlos **privados**: solo se usan dentro
de ese archivo/clase.

- `_nombre`, `_email`, `_fecha` → propiedades privadas
- `_crearInput()`, `_crearEmail()` → métodos privados
- `_InputPageState` → clase privada

### 2.4 InputDecoration

Es la propiedad de `TextField` que agrupa **toda la estética** del campo. Se repite casi igual
en los 4 inputs de texto:

```dart
decoration: InputDecoration(
  border: OutlineInputBorder(...),  // el borde
  hintText: '...',                  // texto de sugerencia
  labelText: '...',                 // etiqueta flotante
  helperText: '...',                // texto de ayuda abajo
  counter: Text('...'),             // contador abajo a la derecha
  suffixIcon: Icon(...),            // icono dentro, a la derecha
  icon: Icon(...),                  // icono fuera, a la izquierda
),
```

> *Para eliminar por completo la decoración (incluido el subrayado y el espacio reservado para
> la etiqueta), se debe configurar la propiedad "decoration" como nula de manera explícita.*

---

## 3. Pasos de integración en la app

Antes de escribir la página hay que darla de alta en los 4 archivos de la app, igual que con
Alertas, Avatars y Cards.

### Paso 1 — Entrada en `data/menu_opts.json`

```json
{
    "ruta" : "inputs",
    "icon" : "input",
    "texto": "Inputs"
}
```

- `ruta` → el nombre que usa `Navigator.pushNamed`
- `icon` → la llave del mapa `_icons`
- `texto` → lo que se ve en el menú

### Paso 2 — Icono en `utils/icono_string_util.dart`

Agregar al mapa `_icons`:

```dart
final _icons = <String, IconData>{
  'add_alert': Icons.add_alert,
  'accessibility': Icons.accessibility,
  'folder_open': Icons.folder_open,
  'donut_large': Icons.donut_large,
  'input': Icons.input,          // <-- nueva línea
};
```

Si falta esta línea, el menú se rompe: `getIcon()` recibe un string que no existe en el mapa.

### Paso 3 — Ruta en `routes/routes.dart`

```dart
import 'package:componentes/src/pages/input_page.dart';

Map<String, WidgetBuilder> getAplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'alert': (BuildContext context) => AlertPage(),
    'avatar': (BuildContext context) => AvatarPage(),
    'card': (BuildContext context) => CardPage(),
    'animatedContainer': (BuildContext context) => AnimatedContainerPage(),
    'inputs': (BuildContext context) => InputPage(),   // <-- nueva línea
  };
}
```

La llave `'inputs'` tiene que coincidir **exactamente** con el campo `"ruta"` del JSON.

### Paso 4 — Localización en español (para el Datepicker)

Este paso es solo necesario para el input de fecha, pero conviene hacerlo antes.

**En `pubspec.yaml`**, dentro de `dependencies`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_localizations:
    sdk: flutter
```

**En `main.dart`**:

```dart
import 'package:flutter/material.dart';
//Paquete para cambiar el idioma por defecto
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:componentes/src/pages/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
      ],
      initialRoute: '/',
      routes: getAplicationRoutes(),
    );
  }
}
```

### Paso 5 — Crear `pages/input_page.dart`

El contenido está en la sección 5 de esta guía.

---

## 4. Guía por input

### 4.1 Input de texto (Nombre)

#### Qué hace
Permite escribir texto libre, con la primera letra en mayúscula automática, y lleva un
contador de caracteres que se actualiza mientras se escribe.

#### Código

```dart
//Método para generar un input para texto
Widget _crearInput() {
  return TextField(
    //La capitalización permite colocar Mayúsculas a las palabras escritas
    //Esto es útil para colocar la primera letra en mayúscula del nombre
    //y apellido
    textCapitalization: TextCapitalization.sentences,
    //Decoration incluye las propiedades para cambiar el estilo de los input
    decoration: InputDecoration(
        //Propiedad para cambiar el estilo de los bordes de los inputs
        border: OutlineInputBorder(
            //Estilo del redondeo de las esquinas del input
            borderRadius: BorderRadius.circular(10.0)),
        //Etiqueta contadora de caracteres
        counter: Text('Letras ${_nombre.length}'),
        //Texto de sugerencia para completar un input
        hintText: 'Nombre de la persona',
        //Etiqueta del input
        labelText: 'Nombre',
        //Texto de ayuda ubicado debajo del input
        helperText: 'Solo nombre',
        //Icono que se incluye dentro del input
        suffixIcon: Icon(Icons.accessibility),
        //Icono que aparece al principio del input
        icon: Icon(Icons.account_circle)),
    //onChanged es un método que permite obtener el valor que se ingresa al
    //input para poder procesarlo. Recibe como parámetro el valor que se
    //escribe en la caja de texto
    onChanged: (valor) {
      //El setState va a permitir redibujar el widget para mostrar cada letra
      //que el usuario ingresa en la caja de texto
      setState(() {
        _nombre = valor;
      });
    },
  );
}
```

#### Propiedad por propiedad

| Propiedad | Para qué sirve |
|-----------|----------------|
| `textCapitalization: TextCapitalization.sentences` | Pone en mayúscula la primera letra de cada oración. Útil para nombres y apellidos. |
| `border: OutlineInputBorder(...)` | Dibuja el borde completo alrededor del campo (en vez del subrayado por defecto). |
| `borderRadius: BorderRadius.circular(10.0)` | Redondea las esquinas del borde 10 píxeles. |
| `counter: Text('Letras ${_nombre.length}')` | Texto abajo a la derecha. Usa interpolación `${}` porque se llama a una propiedad (`.length`), no a una variable simple. |
| `hintText` | Texto gris que se ve **dentro** del campo cuando está vacío. |
| `labelText` | Etiqueta que flota arriba del campo cuando se escribe. |
| `helperText` | Texto de ayuda abajo a la izquierda. |
| `suffixIcon` | Icono **dentro** del campo, al final. |
| `icon` | Icono **fuera** del campo, a la izquierda. |
| `onChanged` | Se dispara con **cada tecla**. Recibe el valor completo del campo. |

#### Detalle importante del contador

El contador funciona porque es un ciclo cerrado:

1. Escribo una letra → se dispara `onChanged`
2. `_nombre = valor` guarda el texto
3. `setState` redibuja todo el widget
4. Al redibujarse, se vuelve a ejecutar `Text('Letras ${_nombre.length}')` con el valor nuevo

Si sacás el `setState` y dejás solo `_nombre = valor`, el contador se queda en 0.

#### Declaración necesaria en el State

```dart
String _nombre = '';
```

---

### 4.2 Input de Email

#### Qué hace
Igual que el input de texto, pero el teclado del dispositivo muestra el carácter `@` para
facilitar la escritura de direcciones de correo.

#### Código

```dart
//Widget para generar un input para email
Widget _crearEmail() {
  return TextField(
    //keyboardType permite que en el teclado del dispositivo móvil se
    //encuentre accesible el arroba (@) con el fin de escribir las
    //direcciones de correo con mayor facilidad
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Email',
        labelText: 'Email',
        suffixIcon: Icon(Icons.alternate_email),
        icon: Icon(Icons.email)),
    onChanged: (valor) {
      setState(() {
        _email = valor;
      });
    },
  );
}
```

#### La propiedad que lo diferencia

> *En el input de tipo email, la propiedad que los diferencia de los demás es "keyboardType",
> que permite que en el teclado del dispositivo móvil se encuentre accesible el caracter
> arroba (@) con el fin de escribir las direcciones de correo con mayor facilidad.*

```dart
keyboardType: TextInputType.emailAddress
```

**Ojo:** `keyboardType` **no valida** que el texto sea un email. Solo cambia el teclado que se
muestra. La validación requeriría `TextFormField` dentro de un `Form`, que no se usa en este
práctico.

#### Diferencias respecto al input de Nombre

- No tiene `textCapitalization` (los emails van en minúscula)
- No tiene `counter` ni `helperText`
- Los iconos cambian: `Icons.email` (afuera) y `Icons.alternate_email` (adentro)

#### Declaración necesaria en el State

```dart
String _email = '';
```

---

### 4.3 Input de Password

#### Qué hace
Oculta los caracteres que se escriben, reemplazándolos por puntos o asteriscos.

#### Código

```dart
//Widget para generar un input para password
Widget _crearPassword() {
  return TextField(
    //obscureText permite ocultar los caracteres que se ingresan en un
    //input reemplazandolos por asteriscos
    obscureText: true,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Password',
        labelText: 'Password',
        suffixIcon: Icon(Icons.lock_open),
        icon: Icon(Icons.lock)),
    onChanged: (valor) {
      setState(() {});
    },
  );
}
```

#### La propiedad que lo diferencia

> *Para el caso del password, entra en juego la propiedad "obscureText" que permite ocultar los
> caracteres que se ingresan en un input reemplazandolos por asteriscos.*

```dart
obscureText: true
```

#### Particularidad: el setState vacío

```dart
onChanged: (valor) {
  setState(() {});
},
```

Fijate que **no se guarda nada** en ninguna variable. El password no se muestra en el
`ListTile` final, así que el apunte solo llama a `setState(() {})` vacío para redibujar.

Esto es intencional en el ejemplo. Si quisieras guardarlo, declararías `String _password = '';`
y harías `_password = valor;` adentro del `setState`.

#### Iconos

- `icon: Icon(Icons.lock)` → candado cerrado, afuera a la izquierda
- `suffixIcon: Icon(Icons.lock_open)` → candado abierto, adentro a la derecha

---

### 4.4 Input de Fecha (Datepicker)

#### Qué hace
Abre un **modal con un calendario** al tocar el campo. La fecha elegida se escribe
automáticamente dentro del input y no se puede editar a mano.

> *El selector de fechas de flutter, se muestra como un modal con el calendario sobre el cual se
> puede seleccionar un día en particular.*

Este es el input más complejo: necesita **dos métodos** y un **controlador**.

#### Paso 1 — Declarar el controlador

```dart
String _fecha = '';
TextEditingController _inputFieldController = new TextEditingController();
```

El `TextEditingController` es el puente que permite **escribir** texto en el input desde el
código, en lugar de que lo escriba el usuario.

#### Paso 2 — El campo visual

```dart
//Widget para generar un input para seleccionar una fecha
Widget _crearFecha(BuildContext context) {
  return TextField(
    //enableInteractiveSelection permite bloquear la copia de información
    //de dicho campo fecha
    enableInteractiveSelection: false,
    //Se asigna el enlace del calendario con el input
    controller: _inputFieldController,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        hintText: 'Fecha de nacimiento',
        labelText: 'Fecha de nacimiento',
        suffixIcon: Icon(Icons.perm_contact_calendar),
        icon: Icon(Icons.calendar_today)),
    //onTap permite lanzar un método para mostrar un modal con un
    //calendario sobre el cual seleccionar la fecha
    onTap: () {
      //Elimina el foco para poder mostrar el modal selector de fecha
      FocusScope.of(context).requestFocus(new FocusNode());
      _selectDate(context);
    },
  );
}
```

#### Paso 3 — El modal con el calendario

```dart
//Widget para lanzar un modal con el calendario para seleccionar fecha
_selectDate(BuildContext context) async {
  //Se genera una variable para inicializar los datos de un calendario selector
  DateTime? calendario = await showDatePicker(
      context: context,
      //Fecha actual
      initialDate: new DateTime.now(),
      //Fecha inicial desde la cual se puede empezar a seleccionar una fecha
      firstDate: new DateTime(2018),
      //Fecha final hasta la que se puede seleccionar una fecha
      lastDate: new DateTime(2030),
      //Cambio de idioma en el cuadro de calendario
      locale: Locale('es', 'ES'));

  //Validación para colocar la fecha seleccionada en la caja de texto
  if (calendario != null) {
    setState(() {
      //Se asigna la fecha seleccionada
      _fecha = calendario.toString();
      //Se coloca la fecha en el input
      _inputFieldController.text = _fecha;
    });
  }
}
```

#### Propiedad por propiedad

| Propiedad | Para qué sirve |
|-----------|----------------|
| `enableInteractiveSelection: false` | Bloquea seleccionar/copiar/pegar dentro del campo. El usuario no puede escribir la fecha a mano. |
| `controller: _inputFieldController` | Enlaza el campo con el controlador, para poder escribirle desde el código. |
| `onTap` | Se dispara al **tocar** el campo (no al escribir). Es el reemplazo de `onChanged` en este caso. |
| `FocusScope.of(context).requestFocus(new FocusNode())` | Quita el foco del campo. Sin esto, se abre el teclado del celular **encima** del calendario. |
| `initialDate` | Día que aparece seleccionado al abrir el calendario. |
| `firstDate` | Fecha mínima seleccionable. |
| `lastDate` | Fecha máxima seleccionable. |
| `locale: Locale('es', 'ES')` | Muestra el calendario en español ("SELECCIONAR FECHA", "CANCELAR", "ACEPTAR", nombres de meses). |

#### Por qué `async` / `await`

`showDatePicker` devuelve un `Future<DateTime?>`: el resultado **no está disponible al
instante**, hay que esperar a que el usuario elija un día y toque "ACEPTAR".

Del apunte de Dart:

> *El "Async" permite transformar una función en una tarea asíncrona. En cambio en "Await"
> permitirá esperar hasta que se resuelva esa tarea antes mencionada.*

Por eso:
- `_selectDate(...)` lleva `async`
- `showDatePicker(...)` lleva `await` adelante

#### Por qué el `if (calendario != null)`

El tipo es `DateTime?` — con signo de pregunta, o sea **con soporte de nulos**. Si el usuario
toca "CANCELAR", `calendario` vale `null`. Sin el `if`, al hacer `calendario.toString()` la app
rompe.

Del apunte de Dart:

> *Cuando una variable es null, es porque no tiene ninguna referencia a algún objeto o, cuando
> una variable no tiene ningún valor.*

#### Flujo completo

```
Usuario toca el campo
  → onTap
    → FocusScope quita el foco (evita que suba el teclado)
    → _selectDate(context)
      → await showDatePicker  ... se abre el modal y se espera
      → el usuario elige un día y acepta
      → calendario recibe un DateTime
      → if (calendario != null)
        → setState
          → _fecha = calendario.toString()
          → _inputFieldController.text = _fecha   ← esto escribe en el input
```

#### Nota sobre firstDate / lastDate

El apunte usa `firstDate: 2022` y `lastDate: 2024`. Hoy esos valores **rompen la app**, porque
`initialDate: DateTime.now()` queda fuera del rango permitido y `showDatePicker` lanza un error.

En esta guía se usa `lastDate: new DateTime(2030)` para que `DateTime.now()` entre en el rango.
Es el único cambio respecto al apunte original.

---

### 4.5 Dropdown (Lista desplegable)

#### Qué hace

> *Una lista desplegable permite al usuario seleccionar una opción entre varios elementos. Este
> componente se visualiza mediante un botón que muestra el elemento seleccionado actualmente,
> así como una flecha que abre un menú para seleccionar otro elemento de la lista.*

Necesita **dos métodos**: uno que arma la lista de opciones y otro que dibuja el widget.

#### Paso 1 — Declarar la lista y la opción elegida

```dart
//Elementos del dropdown
List<String> _profesiones = [
  'Sin dato',
  'Contador',
  'Abogado',
  'Ingeniero',
  'Periodista',
  'Programador'
];

//Opción que se selecciona en el dropdown
String _opcionSeleccionadaDropdown = 'Sin dato';
```

El valor inicial de `_opcionSeleccionadaDropdown` **tiene que existir** dentro de
`_profesiones`. Si ponés `'Sin dato'` pero la lista no lo contiene, la app rompe.

#### Paso 2 — Armar la lista de DropdownMenuItem

```dart
//Se genera la lista de elementos para el dropdown
List<DropdownMenuItem<String>> getOpcionesDropdown() {
  List<DropdownMenuItem<String>> lista = [];
  _profesiones.forEach((profesion) {
    lista.add(DropdownMenuItem(
      child: Text(profesion),
      value: profesion,
    ));
  });
  return lista;
}
```

Transforma una `List<String>` simple en una `List<DropdownMenuItem<String>>`, que es lo que
el `DropdownButton` sabe mostrar.

Cada `DropdownMenuItem` tiene dos partes:
- `child: Text(profesion)` → lo que **se ve** en pantalla
- `value: profesion` → el valor que **se guarda** al elegirlo

Se recorre con `forEach`, el mismo método que se usa en `_listaItems` de `home_page.dart`.

#### Paso 3 — El widget

```dart
//Widget para generar un dropdown
Widget _crearDropdown() {
  return Row(
    children: <Widget>[
      Icon(Icons.select_all),
      SizedBox(
        width: 30.0,
      ),
      Expanded(
          child: DropdownButton(
              //Valor por defecto del dropdown
              value: _opcionSeleccionadaDropdown,
              items: getOpcionesDropdown(),
              onChanged: (opt) {
                setState(() {
                  _opcionSeleccionadaDropdown = opt.toString();
                });
              }))
    ],
  );
}
```

#### Por qué Row + SizedBox + Expanded

El `DropdownButton` **no tiene** la propiedad `icon` externa de `InputDecoration`, así que el
icono se agrega a mano armando una fila:

| Widget | Rol |
|--------|-----|
| `Row` | Pone el icono y el dropdown uno al lado del otro, en horizontal. |
| `Icon(Icons.select_all)` | El icono de la izquierda, para que combine con los otros inputs. |
| `SizedBox(width: 30.0)` | Separación de 30 píxeles entre el icono y el dropdown. |
| `Expanded` | Estira el dropdown para que ocupe todo el ancho restante de la fila. |

Del apunte: *Expanded trata de estirar al widget que tiene como hijo para ocupar el resto de la
fila.*

#### Propiedades del DropdownButton

| Propiedad | Para qué sirve |
|-----------|----------------|
| `value` | La opción actualmente seleccionada. Tiene que existir dentro de `items`. |
| `items` | La lista de `DropdownMenuItem`. Se llama al método que la arma. |
| `onChanged` | Se dispara al elegir una opción. Recibe el `value` del item elegido. |

#### Por qué `opt.toString()`

`onChanged` devuelve un tipo dinámico/nulable. Como `_opcionSeleccionadaDropdown` es `String`,
se convierte con `.toString()` para que los tipos coincidan.

---

### 4.6 ListTile de salida

#### Qué hace
Muestra en pantalla, en tiempo real, los valores cargados en el formulario. Es la prueba
visual de que `onChanged` + `setState` funcionan.

#### Código

```dart
//Se genera un listTile para mostrar el texto que se carga en la caja de texto
Widget _crearPersona() {
  return ListTile(
    title: Text('Nombre es: $_nombre'),
    subtitle: Text('Email: $_email'),
    trailing: Text(_opcionSeleccionadaDropdown),
  );
}
```

#### Las tres posiciones del ListTile

| Propiedad | Dónde se ve |
|-----------|-------------|
| `title` | Línea principal, arriba. |
| `subtitle` | Línea secundaria, abajo del título, en gris. |
| `trailing` | Al final, alineado a la derecha. |

#### Interpolación

```dart
Text('Nombre es: $_nombre')          // variable simple → solo $
Text('Letras ${_nombre.length}')     // propiedad → ${ }
```

Del apunte de Dart: *En la interpolación dentro de una cadena de texto utilizaremos el signo de
moneda $*.

Cuando se accede a una **propiedad o método** (como `.length`), hacen falta las llaves `${}`.

#### Qué no aparece

El password y la fecha **no se muestran** en el `ListTile` del apunte. El password porque nunca
se guarda en una variable, y la fecha porque ya se ve dentro de su propio input.

---

## 5. Archivo completo input_page.dart

```dart
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String _nombre = '';
  String _email = '';
  String _fecha = '';

  //Elementos del dropdown
  List<String> _profesiones = [
    'Sin dato',
    'Contador',
    'Abogado',
    'Ingeniero',
    'Periodista',
    'Programador'
  ];

  //Opción que se selecciona en el dropdown
  String _opcionSeleccionadaDropdown = 'Sin dato';

  TextEditingController _inputFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inputs'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: [
          _crearInput(),
          Divider(),
          _crearEmail(),
          Divider(),
          _crearPassword(),
          Divider(),
          _crearFecha(context),
          Divider(),
          _crearDropdown(),
          Divider(),
          _crearPersona()
        ],
      ),
    );
  }

  //Widget para generar un input para texto
  Widget _crearInput() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          counter: Text('Letras ${_nombre.length}'),
          hintText: 'Nombre de la persona',
          labelText: 'Nombre',
          helperText: 'Solo nombre',
          suffixIcon: Icon(Icons.accessibility),
          icon: Icon(Icons.account_circle)),
      onChanged: (valor) {
        setState(() {
          _nombre = valor;
        });
      },
    );
  }

  //Widget para generar un input para email
  Widget _crearEmail() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: 'Email',
          labelText: 'Email',
          suffixIcon: Icon(Icons.alternate_email),
          icon: Icon(Icons.email)),
      onChanged: (valor) {
        setState(() {
          _email = valor;
        });
      },
    );
  }

  //Widget para generar un input para password
  Widget _crearPassword() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: 'Password',
          labelText: 'Password',
          suffixIcon: Icon(Icons.lock_open),
          icon: Icon(Icons.lock)),
      onChanged: (valor) {
        setState(() {});
      },
    );
  }

  //Widget para generar un input para seleccionar una fecha
  Widget _crearFecha(BuildContext context) {
    return TextField(
      enableInteractiveSelection: false,
      controller: _inputFieldController,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          hintText: 'Fecha de nacimiento',
          labelText: 'Fecha de nacimiento',
          suffixIcon: Icon(Icons.perm_contact_calendar),
          icon: Icon(Icons.calendar_today)),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  //Widget para lanzar un modal con el calendario para seleccionar fecha
  _selectDate(BuildContext context) async {
    DateTime? calendario = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2030),
        locale: Locale('es', 'ES'));

    if (calendario != null) {
      setState(() {
        _fecha = calendario.toString();
        _inputFieldController.text = _fecha;
      });
    }
  }

  //Se genera la lista de elementos para el dropdown
  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [];
    _profesiones.forEach((profesion) {
      lista.add(DropdownMenuItem(
        child: Text(profesion),
        value: profesion,
      ));
    });
    return lista;
  }

  //Widget para generar un dropdown
  Widget _crearDropdown() {
    return Row(
      children: <Widget>[
        Icon(Icons.select_all),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
            child: DropdownButton(
                value: _opcionSeleccionadaDropdown,
                items: getOpcionesDropdown(),
                onChanged: (opt) {
                  setState(() {
                    _opcionSeleccionadaDropdown = opt.toString();
                  });
                }))
      ],
    );
  }

  //Se genera un listTile para mostrar el texto que se carga en la caja de texto
  Widget _crearPersona() {
    return ListTile(
      title: Text('Nombre es: $_nombre'),
      subtitle: Text('Email: $_email'),
      trailing: Text(_opcionSeleccionadaDropdown),
    );
  }
}
```

### Sobre el body: ListView

```dart
body: ListView(
  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
  children: [ ... ],
),
```

Se usa `ListView` y no `Column` porque permite **hacer scroll**. Con un `Column`, si sube el
teclado del celular, el contenido no entra en pantalla y aparece el error de *Overflow*.

Del apunte: *Column... carece de capacidad de desplazamiento (scroll) por defecto, lo que puede
causar un error de Overflow si el contenido es excesivo.*

`EdgeInsets.symmetric` aplica el mismo margen a los lados opuestos: 10 px a izquierda y derecha,
20 px arriba y abajo.

Los `Divider()` entre cada input son las líneas separadoras horizontales.

---

## 6. Tabla de referencia de propiedades

### Propiedades propias de cada tipo de input

| Input | Propiedad clave | Valor |
|-------|-----------------|-------|
| Texto | `textCapitalization` | `TextCapitalization.sentences` |
| Email | `keyboardType` | `TextInputType.emailAddress` |
| Password | `obscureText` | `true` |
| Fecha | `enableInteractiveSelection` + `controller` + `onTap` | `false` / `_inputFieldController` / `_selectDate` |
| Dropdown | `value` + `items` + `onChanged` | — |

### Propiedades de InputDecoration

| Propiedad | Posición en pantalla |
|-----------|---------------------|
| `icon` | Fuera del campo, izquierda |
| `prefixIcon` | Dentro del campo, izquierda |
| `suffixIcon` | Dentro del campo, derecha |
| `labelText` | Etiqueta flotante |
| `hintText` | Dentro del campo, cuando está vacío |
| `helperText` | Debajo, izquierda |
| `counter` | Debajo, derecha |
| `border` | El contorno del campo |

### Iconos usados

| Input | `icon` (afuera) | `suffixIcon` (adentro) |
|-------|-----------------|------------------------|
| Nombre | `Icons.account_circle` | `Icons.accessibility` |
| Email | `Icons.email` | `Icons.alternate_email` |
| Password | `Icons.lock` | `Icons.lock_open` |
| Fecha | `Icons.calendar_today` | `Icons.perm_contact_calendar` |
| Dropdown | `Icons.select_all` (como widget aparte) | — |

Referencia completa de iconos: https://fonts.google.com/icons

---

## 7. Errores comunes

| Síntoma | Causa | Solución |
|---------|-------|----------|
| El contador de letras se queda en 0 | Falta `setState` en `onChanged` | Envolver la asignación en `setState(() { ... })` |
| El calendario sale en inglés | Falta `locale` o falta configurar `main.dart` | Agregar `locale: Locale('es', 'ES')` y los `localizationsDelegates` |
| La app rompe al abrir el calendario | `initialDate` está fuera del rango `firstDate`–`lastDate` | Ampliar `lastDate` (por ejemplo a 2030) |
| El teclado tapa el calendario | Falta quitar el foco | Agregar `FocusScope.of(context).requestFocus(new FocusNode())` en el `onTap` |
| La app rompe al cancelar el calendario | Falta validar el nulo | Envolver en `if (calendario != null)` |
| La app rompe al abrir la página del dropdown | El `value` inicial no existe en la lista `items` | Verificar que `_opcionSeleccionadaDropdown` esté dentro de `_profesiones` |
| El menú principal rompe al cargar | Falta la llave del icono en `_icons` | Agregar `'input': Icons.input` en `icono_string_util.dart` |
| Al tocar "Inputs" no navega | La `ruta` del JSON no coincide con la llave de `routes.dart` | Ambas tienen que decir exactamente `inputs` |
| Overflow al subir el teclado | Se usó `Column` en vez de `ListView` | Cambiar el `body` a `ListView` |
| La fecha no se escribe en el campo | Falta asignar al controlador | Agregar `_inputFieldController.text = _fecha;` dentro del `setState` |

---

## Resumen del patrón

Todos los inputs del formulario siguen la misma lógica de 4 pasos:

1. **Declarar** una propiedad privada en el `State` (`String _nombre = '';`)
2. **Dibujar** el campo en un método privado (`Widget _crearInput()`)
3. **Capturar** el valor con `onChanged` (o `onTap` en la fecha) y guardarlo con `setState`
4. **Mostrar** el resultado en el `ListTile` final

El único que rompe el patrón es la fecha, que necesita además un `TextEditingController` y un
método `async` para el modal.
