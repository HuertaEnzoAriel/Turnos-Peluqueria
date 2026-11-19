# Turnos Peluquería

Aplicación móvil en Flutter para reservar y gestionar turnos de una peluquería.
Práctico N.º 3 (Integrador) de **Programación para Móviles**, Tecnicatura Universitaria
en Programación Web (FCEFN, UNSJ).

Es un producto mínimo viable (MVP), pensado para seguir sumando funcionalidades
de cara al examen final.

## Propósito

Los clientes reservan turnos desde el celular sin llamar a la peluquería, y la app
les avisa antes de que llegue el turno. El administrador mantiene el listado de
servicios con sus precios y lleva el seguimiento de cada turno.

## Funcionalidades

**Cuentas y sesión**
- Registro con nombre, apellido, email y contraseña (Supabase Auth).
- Inicio de sesión con la opción *Mantener sesión iniciada*.
- La sesión se cierra sola después de 5 minutos sin actividad.
- Dos roles: **cliente** (por defecto) y **admin**.

**Servicios** (CRUD completo, solo admin)
- Alta, consulta, modificación y borrado de servicios (nombre y precio).
- Validaciones: nombre obligatorio de al menos 3 letras y sin repetir, y precio
  numérico mayor a 0.
- No se puede borrar un servicio que tenga turnos reservados.

**Turnos**
- Reserva con fecha (`DatePicker`), hora (`TimePicker`) y servicio (`Dropdown`).
- Validaciones: campos obligatorios, horario de atención de 09:00 a 20:00, no se
  aceptan fechas ni horas pasadas y no se puede repetir un horario ya ocupado.
- *Mis turnos*: el cliente ve solo sus turnos y el admin ve todos.
- Estados: `pendiente → confirmado → completado`, `pendiente / confirmado → cancelado`
  y `confirmado → ausente`. El admin cambia el estado desde un menú. El cliente
  puede cancelar sus turnos deslizándolos.
- Recordatorio con notificación local 1 minuto antes del turno (tiempo corto
  para la demostración).

## Tecnologías

| Paquete | Uso |
|---|---|
| `supabase_flutter` | Base de datos PostgreSQL y autenticación |
| `flutter_dotenv` | Claves de Supabase en el archivo `.env` |
| `shared_preferences` | Preferencia de mantener la sesión y última actividad |
| `flutter_local_notifications` + `timezone` | Recordatorios de turnos |
| `flutter_svg` | Ícono de la AppBar |
| `flutter_localizations` | DatePicker en español |

## Arquitectura de la base de datos

El script completo está en [`supabase/schema.sql`](supabase/schema.sql).

```
auth.users (Supabase Auth)
   │ 1
   │                      ┌──────────────────────────┐
   ├──── 1 ── perfiles    │ id (uuid, PK → users)    │
   │                      │ email, nombre, apellido  │
   │                      │ rol: admin | cliente     │
   │                      └──────────────────────────┘
   │ 1
   └──── N ── turnos ─── N ──── 1 ── servicios
              ┌───────────────────────────┐   ┌────────────────────────┐
              │ id (PK)                   │   │ id (PK)                │
              │ nombre_cliente            │   │ nombre (único, ≥3)     │
              │ fecha, hora (09–20 hs)    │   │ precio (> 0)           │
              │ servicio_id (FK, restrict)│   │ icono                  │
              │ user_id (FK → users)      │   │ created_at             │
              │ estado                    │   └────────────────────────┘
              │ created_at                │
              └───────────────────────────┘
```

- **Integridad:** claves foráneas (`on delete restrict` para servicios), `check` de
  precio, nombre, horario y estado, y un índice único parcial que impide dos turnos
  activos en la misma fecha y hora.
- **Trigger:** al registrarse un usuario se crea su fila en `perfiles` con el rol
  `cliente`.
- **Seguridad (RLS):** sin sesión no se puede leer nada. Todos ven los servicios, pero
  solo el admin los modifica. Cada cliente ve y cancela solo sus turnos, y el admin
  gestiona todos.

## Permisos del dispositivo

| Permiso | Justificación |
|---|---|
| `POST_NOTIFICATIONS` | Mostrar el recordatorio antes del turno (Android 13+). |
| `SCHEDULE_EXACT_ALARM` | Que el recordatorio llegue a la hora exacta. |
| `INTERNET` | Conectarse a Supabase. |

**Cómo se gestiona el permiso de notificaciones:**
1. Al entrar a la pantalla principal, la app revisa si ya tiene el permiso.
2. Si no lo tiene, un `AlertDialog` explica para qué se usa y el usuario elige
   *Permitir* o *Ahora no*.
3. Solo si elige *Permitir* aparece el diálogo del sistema.
4. Un `SnackBar` informa el resultado. Si el usuario lo rechaza, la app sigue
   funcionando: los turnos se reservan igual, pero sin recordatorio, y se le avisa.

## Cómo ejecutarlo

1. Crear un proyecto en [Supabase](https://supabase.com) y correr
   `supabase/schema.sql` en **SQL Editor**.
2. Copiar `.env.example` como `.env` y completar `SUPABASE_URL` y
   `SUPABASE_PUBLISHABLE_KEY` (Project Settings → API).
3. Instalar las dependencias y ejecutar:
   ```bash
   flutter pub get
   flutter run
   ```
4. Para tener un admin, crear la cuenta desde la app y después correr en Supabase:
   ```sql
   update public.perfiles set rol = 'admin' where email = 'tu@mail.com';
   ```

## Estructura del proyecto

```
lib/
├── main.dart                      # Inicializa Supabase, sesión y notificaciones
└── src/
    ├── app_theme.dart             # Colores y tema
    ├── models/                    # Perfil, Servicio, Turno, EstadoTurno
    ├── pages/                     # Login, registro, principal y pestañas
    │   └── routes/routes.dart     # Rutas con nombre
    └── services/
        ├── supabase_services.dart     # Todas las consultas a la base
        └── notificaciones_service.dart# Permiso y recordatorios
supabase/schema.sql                # Tablas, reglas y políticas
```

## Mejoras planificadas

- Reprogramar un turno (cambiar fecha y hora) en lugar de cancelarlo y reservar otro.
- Mostrar solo los horarios disponibles al elegir la hora.
- Elegir con cuánta anticipación llega el recordatorio.
- Foto de perfil desde la cámara o la galería.
- Panel del admin con estadísticas (turnos por servicio, ausencias).
