-- =========================================================
-- RUN THIS FIRST (Supabase SQL Editor, Transaction mode OFF)
-- Creates the projects table + public read + auth write policies
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

-- Verify (expect a count, no error):
--   select count(*) from public.projects;
