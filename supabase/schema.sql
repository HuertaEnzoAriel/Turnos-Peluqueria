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
-- 4. Permisos
-- La app inicia sesión con Supabase Auth, así que las consultas
-- llegan con el rol "authenticated". Sin login (rol "anon", solo
-- con la clave publishable) no se puede leer ni modificar nada.
-- Solo se habilita lo que la app hace: ver/crear/editar servicios
-- y ver/crear/borrar turnos.
-- (La cátedra, para practicar, desmarca "Enable RLS" en el Table
-- Editor; acá se deja activado con políticas, como en producción.)
-- -------------------------------------------------------------
revoke all on public.servicios, public.turnos from anon;
grant select, insert, update on public.servicios to authenticated;
grant select, insert, delete on public.turnos    to authenticated;

alter table public.servicios enable row level security;
alter table public.turnos    enable row level security;

drop policy if exists "servicios_select" on public.servicios;
drop policy if exists "servicios_insert" on public.servicios;
drop policy if exists "servicios_update" on public.servicios;
drop policy if exists "turnos_select"    on public.turnos;
drop policy if exists "turnos_insert"    on public.turnos;
drop policy if exists "turnos_delete"    on public.turnos;

create policy "servicios_select" on public.servicios
  for select to authenticated using (true);

create policy "servicios_insert" on public.servicios
  for insert to authenticated with check (true);

create policy "servicios_update" on public.servicios
  for update to authenticated using (true) with check (true);

create policy "turnos_select" on public.turnos
  for select to authenticated using (true);

create policy "turnos_insert" on public.turnos
  for insert to authenticated with check (fecha >= current_date);

create policy "turnos_delete" on public.turnos
  for delete to authenticated using (true);


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

create or replace function public.crear_perfil()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.perfiles (id, email, rol)
  values (new.id, new.email, 'cliente');
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
