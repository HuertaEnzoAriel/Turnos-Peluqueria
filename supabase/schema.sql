-- =============================================================
-- Turnos Peluquería - esquema de base de datos para Supabase
-- Pegar todo en: Supabase → SQL Editor → New query → Run
-- Se puede correr más de una vez sin romper nada.
-- =============================================================


-- -------------------------------------------------------------
-- 1. Tabla SERVICIOS  (pestaña "Servicios" y página de edición)
-- -------------------------------------------------------------
create table if not exists public.servicios (
  id          bigint generated always as identity primary key,
  nombre      text    not null unique check (char_length(trim(nombre)) >= 3),
  precio      integer not null check (precio > 0),
  -- Nombre del ícono de Material (Icons.content_cut → 'content_cut').
  -- Flutter no puede guardar un IconData, así que se guarda el nombre.
  icono       text    not null default 'content_cut',
  created_at  timestamptz not null default now()
);


-- -------------------------------------------------------------
-- 2. Tabla TURNOS  (pestañas "Reservar" y "Mis turnos")
-- -------------------------------------------------------------
create table if not exists public.turnos (
  id             bigint generated always as identity primary key,
  nombre_cliente text   not null check (char_length(trim(nombre_cliente)) > 0),
  fecha          date   not null,
  hora           time   not null,
  servicio_id    bigint not null references public.servicios (id) on delete restrict,
  created_at     timestamptz not null default now()
);

-- Si la tabla ya existía de antes (sin la hora), le agrega la columna
alter table public.turnos add column if not exists hora time;

create index if not exists turnos_servicio_id_idx on public.turnos (servicio_id);


-- -------------------------------------------------------------
-- 3. Datos iniciales (los mismos 4 servicios que tenía la app)
-- -------------------------------------------------------------
insert into public.servicios (nombre, precio, icono) values
  ('Corte de pelo',  8000, 'content_cut'),
  ('Barba',          5000, 'face'),
  ('Color',         15000, 'palette'),
  ('Peinado',        7000, 'brush')
on conflict (nombre) do nothing;
-- -------------------------------------------------------------
-- 4. Reglas de turnos (se pueden correr más de una vez)
-- -------------------------------------------------------------
-- Cada turno pertenece al usuario que lo reservó
alter table public.turnos
  add column if not exists user_id uuid default auth.uid()
  references auth.users (id) on delete cascade;

-- No se puede reservar el mismo día y hora dos veces.
-- (Si ya hay turnos repetidos, borrarlos a mano antes de correr esto.)
create unique index if not exists turnos_fecha_hora_unico
  on public.turnos (fecha, hora);

-- Horario de atención: de 09:00 a 20:00
-- ("not valid" = no revisa los turnos viejos, solo los nuevos)
alter table public.turnos drop constraint if exists turnos_horario_atencion;
alter table public.turnos add constraint turnos_horario_atencion
  check (hora between time '09:00' and time '20:00') not valid;

-- -------------------------------------------------------------
-- 5. Roles (admin / cliente)
-- Cada usuario de Supabase Auth tiene una fila en "perfiles".
-- Al crear una cuenta desde la app el trigger le pone 'cliente'.
-- Para hacer admin a alguien (a mano):
--   update public.perfiles set rol = 'admin' where email = 'tu@mail.com';
-- -------------------------------------------------------------
create table if not exists public.perfiles (
  id    uuid primary key references auth.users (id) on delete cascade,
  email text,
  rol   text not null default 'cliente' check (rol in ('admin', 'cliente'))
);

-- Nombre y apellido: se cargan en el registro (la app los manda como
-- metadata del usuario y el trigger de abajo los copia acá).
-- Los usuarios viejos quedan con null.
alter table public.perfiles add column if not exists nombre   text;
alter table public.perfiles add column if not exists apellido text;

create or replace function public.crear_perfil()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.perfiles (id, email, rol, nombre, apellido)
  values (
    new.id,
    new.email,
    'cliente',
    nullif(trim(new.raw_user_meta_data->>'nombre'), ''),
    nullif(trim(new.raw_user_meta_data->>'apellido'), '')
  );
  return new;
end;
$$;

drop trigger if exists al_crear_usuario on auth.users;
create trigger al_crear_usuario
  after insert on auth.users
  for each row execute function public.crear_perfil();

-- Los usuarios que ya existían quedan como admin
insert into public.perfiles (id, email, rol)
select id, email, 'admin' from auth.users
on conflict (id) do nothing;

revoke all on public.perfiles from anon;
grant select on public.perfiles to authenticated;
alter table public.perfiles enable row level security;
drop policy if exists "perfiles_select" on public.perfiles;
create policy "perfiles_select" on public.perfiles
  for select to authenticated using (id = auth.uid());


-- -------------------------------------------------------------
-- 6. Permisos
-- La app inicia sesión con Supabase Auth, así que las consultas
-- llegan con el rol "authenticated". Sin login (rol "anon", solo
-- con la clave publishable) no se puede leer ni modificar nada.
--  - Servicios: todos los ven; solo el admin crea, edita y borra.
--  - Turnos: el cliente ve/crea/borra solo los suyos; el admin ve
--    y borra todos.
-- (La cátedra, para practicar, desmarca "Enable RLS" en el Table
-- Editor; acá se deja activado con políticas, como en producción.)
-- -------------------------------------------------------------
create or replace function public.es_admin()
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select exists (
    select 1 from public.perfiles
    where id = auth.uid() and rol = 'admin'
  );
$$;

revoke all on public.servicios, public.turnos from anon;
grant select, insert, update, delete on public.servicios to authenticated;
grant select, insert, delete on public.turnos to authenticated;

alter table public.servicios enable row level security;
alter table public.turnos    enable row level security;

drop policy if exists "servicios_select" on public.servicios;
drop policy if exists "servicios_insert" on public.servicios;
drop policy if exists "servicios_update" on public.servicios;
drop policy if exists "servicios_delete" on public.servicios;
drop policy if exists "turnos_select"    on public.turnos;
drop policy if exists "turnos_insert"    on public.turnos;
drop policy if exists "turnos_delete"    on public.turnos;

create policy "servicios_select" on public.servicios
  for select to authenticated using (true);

create policy "servicios_insert" on public.servicios
  for insert to authenticated with check (public.es_admin());

create policy "servicios_update" on public.servicios
  for update to authenticated
  using (public.es_admin()) with check (public.es_admin());

create policy "servicios_delete" on public.servicios
  for delete to authenticated using (public.es_admin());

create policy "turnos_select" on public.turnos
  for select to authenticated
  using (user_id = auth.uid() or public.es_admin());

create policy "turnos_insert" on public.turnos
  for insert to authenticated
  with check (fecha >= current_date and user_id = auth.uid());

create policy "turnos_delete" on public.turnos
  for delete to authenticated
  using (user_id = auth.uid() or public.es_admin());
