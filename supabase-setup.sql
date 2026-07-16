-- =========================================================
-- PART 1: DATABASE  (run this FIRST)
-- In the Supabase SQL Editor, turn OFF "Transaction"
-- so a later error can't roll back the table creation.
-- =========================================================

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  title text not null,
  category text not null,
  software text[] not null default '{}',
  completion_date date,
  description text default '',
  process text default '',
  challenges text default '',
  solution text default '',
  results text default '',
  technologies text default '',
  thumbnail text,
  gallery text[] not null default '{}',
  videos text[] not null default '{}',
  documents text[] not null default '{}',
  user_id uuid
);

alter table public.projects enable row level security;

drop policy if exists "Projects public read" on public.projects;
create policy "Projects public read"
  on public.projects for select using (true);

drop policy if exists "Projects auth insert" on public.projects;
create policy "Projects auth insert"
  on public.projects for insert to authenticated with check (true);

drop policy if exists "Projects auth update" on public.projects;
create policy "Projects auth update"
  on public.projects for update to authenticated using (true) with check (true);

drop policy if exists "Projects auth delete" on public.projects;
create policy "Projects auth delete"
  on public.projects for delete to authenticated using (true);

-- Reload PostgREST schema cache
notify pgrst, 'reload schema';

-- VERIFY (should return a count, not an error):
--   select count(*) from public.projects;

-- =========================================================
-- MESSAGES (contact form submissions -> admin inbox)
-- =========================================================

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  email text not null,
  subject text default '',
  message text not null
);

alter table public.messages enable row level security;

-- Anyone (anon) can submit a message
drop policy if exists "Messages anon insert" on public.messages;
create policy "Messages anon insert"
  on public.messages for insert with check (true);

-- Only signed-in users can read/delete
drop policy if exists "Messages auth read" on public.messages;
create policy "Messages auth read"
  on public.messages for select to authenticated using (true);

drop policy if exists "Messages auth delete" on public.messages;
create policy "Messages auth delete"
  on public.messages for delete to authenticated using (true);

-- Reload PostgREST schema cache
notify pgrst, 'reload schema';

-- VERIFY:
--   select count(*) from public.messages;

insert into storage.buckets (id, name, public)
values ('project-media', 'project-media', true)
on conflict (id) do nothing;

drop policy if exists "Media public read" on storage.objects;
create policy "Media public read"
  on storage.objects for select using (bucket_id = 'project-media');

drop policy if exists "Media auth upload" on storage.objects;
create policy "Media auth upload"
  on storage.objects for insert to authenticated with check (bucket_id = 'project-media');

drop policy if exists "Media auth delete" on storage.objects;
create policy "Media auth delete"
  on storage.objects for delete to authenticated using (bucket_id = 'project-media');
