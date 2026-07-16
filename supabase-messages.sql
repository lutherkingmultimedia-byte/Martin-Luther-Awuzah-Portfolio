-- =========================================================
-- RUN IN SUPABASE SQL EDITOR (Transaction mode OFF)
-- Creates/updates the messages table for contact form -> admin inbox
-- =========================================================

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  email text not null,
  subject text default '',
  message text not null,
  reply text default '',
  replied_at timestamptz
);

alter table public.messages enable row level security;

drop policy if exists "Messages anon insert" on public.messages;
create policy "Messages anon insert"
  on public.messages for insert with check (true);

drop policy if exists "Messages auth read" on public.messages;
create policy "Messages auth read"
  on public.messages for select to authenticated using (true);

drop policy if exists "Messages auth update" on public.messages;
create policy "Messages auth update"
  on public.messages for update to authenticated using (true) with check (true);

drop policy if exists "Messages auth delete" on public.messages;
create policy "Messages auth delete"
  on public.messages for delete to authenticated using (true);

-- Reload PostgREST schema cache
notify pgrst, 'reload schema';

-- Verify:
--   select count(*) from public.messages;
