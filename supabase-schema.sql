-- Rabix Style initial schema. Run in Supabase SQL Editor.
-- IMPORTANT: Review policies before going live. Never expose service_role keys.
create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text not null default '',
  category text not null default 'T-Shirts',
  price numeric(10,2) not null check (price >= 0),
  old_price numeric(10,2) check (old_price is null or old_price >= 0),
  image_url text,
  sizes text[] not null default array['S','M','L','XL'],
  colors text[] not null default array['Black','White'],
  stock integer not null default 0 check (stock >= 0),
  tag text not null default 'RABIX STYLE',
  is_new boolean not null default false,
  featured boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  phone text not null,
  address text not null,
  district text not null,
  area text not null default '',
  payment_method text not null default 'COD' check (payment_method = 'COD'),
  items jsonb not null,
  subtotal numeric(10,2) not null check (subtotal >= 0),
  delivery_charge numeric(10,2) not null check (delivery_charge >= 0),
  total numeric(10,2) not null check (total >= 0),
  status text not null default 'pending' check (status in ('pending','confirmed','processing','shipped','delivered','cancelled')),
  created_at timestamptz not null default now()
);

alter table public.products enable row level security;
alter table public.orders enable row level security;

-- Public can only read active products.
drop policy if exists "Public read active products" on public.products;
create policy "Public read active products" on public.products
for select to anon, authenticated using (active = true);

-- Signed-in admins can manage all products. This starter uses authenticated access;
-- restrict admin membership to specific users before production (see README).
drop policy if exists "Authenticated manage products" on public.products;
create policy "Authenticated manage products" on public.products
for all to authenticated using (auth.uid() is not null) with check (auth.uid() is not null);

-- Public checkout can create pending COD orders. Public cannot read or update orders.
drop policy if exists "Public create pending COD orders" on public.orders;
create policy "Public create pending COD orders" on public.orders
for insert to anon, authenticated with check (
  status = 'pending' and payment_method = 'COD'
  and subtotal >= 0 and delivery_charge >= 0 and total = subtotal + delivery_charge
);

-- Only signed-in users can read/update orders. Restrict this to admins before production.
drop policy if exists "Authenticated read orders" on public.orders;
create policy "Authenticated read orders" on public.orders
for select to authenticated using (auth.uid() is not null);
drop policy if exists "Authenticated update orders" on public.orders;
create policy "Authenticated update orders" on public.orders
for update to authenticated using (auth.uid() is not null) with check (auth.uid() is not null);

-- Optional public image bucket. Create a bucket named "product-images" in Storage UI.
-- Configure public read for product-images; restrict uploads to authenticated admins.
