-- ============================================================
-- Mochi & Moonlight — Supabase setup
-- Run ONCE in: Supabase dashboard → SQL Editor → New query → Run
-- BEFORE running: replace YOUR_EMAIL_HERE (appears 7 times) with the
-- exact email of the creator account you create under Authentication → Users.
-- ============================================================

-- 1) One-row table holding which photo/video is live
create table if not exists public.birthday_config (
  id          int primary key default 1 check (id = 1),
  photo_path  text,
  photo_fit   jsonb default '{"zoom":1,"x":50,"y":50,"mode":"cover"}'::jsonb,
  video_path  text,
  video_mime  text,
  updated_at  timestamptz default now()
);
insert into public.birthday_config (id) values (1) on conflict (id) do nothing;
alter table public.birthday_config enable row level security;

drop policy if exists "anyone can read config" on public.birthday_config;
create policy "anyone can read config" on public.birthday_config
  for select to anon, authenticated using (true);

drop policy if exists "creator can update config" on public.birthday_config;
create policy "creator can update config" on public.birthday_config
  for update to authenticated
  using ((auth.jwt() ->> 'email') = 'YOUR_EMAIL_HERE')
  with check ((auth.jwt() ->> 'email') = 'YOUR_EMAIL_HERE');

-- 2) Anonymous completion events (event name + server timestamp ONLY)
create table if not exists public.birthday_events (
  id         bigint generated always as identity primary key,
  event      text not null check (event in ('session_started','final_reached')),
  created_at timestamptz default now()
);
alter table public.birthday_events enable row level security;

drop policy if exists "anyone can log an event" on public.birthday_events;
create policy "anyone can log an event" on public.birthday_events
  for insert to anon, authenticated with check (true);

drop policy if exists "creator can read events" on public.birthday_events;
create policy "creator can read events" on public.birthday_events
  for select to authenticated using ((auth.jwt() ->> 'email') = 'YOUR_EMAIL_HERE');

-- 3) Public storage bucket (anyone can VIEW files; only the creator can write)
insert into storage.buckets (id, name, public)
values ('birthday-media', 'birthday-media', true)
on conflict (id) do update set public = true;

drop policy if exists "creator can upload media" on storage.objects;
create policy "creator can upload media" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'birthday-media' and (auth.jwt() ->> 'email') = 'YOUR_EMAIL_HERE');

drop policy if exists "creator can replace media" on storage.objects;
create policy "creator can replace media" on storage.objects
  for update to authenticated
  using (bucket_id = 'birthday-media' and (auth.jwt() ->> 'email') = 'YOUR_EMAIL_HERE');

drop policy if exists "creator can delete media" on storage.objects;
create policy "creator can delete media" on storage.objects
  for delete to authenticated
  using (bucket_id = 'birthday-media' and (auth.jwt() ->> 'email') = 'YOUR_EMAIL_HERE');
