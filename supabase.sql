-- Protocolo de supervivencia: guardado en la nube + ranking.
-- Pegalo entero en Supabase → SQL Editor → Run. Se puede correr más de una vez.

-- Partidas: cada jugador solo puede ver y modificar la suya.
create table if not exists public.saves (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.saves enable row level security;

drop policy if exists "saves_select_own" on public.saves;
drop policy if exists "saves_insert_own" on public.saves;
drop policy if exists "saves_update_own" on public.saves;
create policy "saves_select_own" on public.saves for select to authenticated using (auth.uid() = user_id);
create policy "saves_insert_own" on public.saves for insert to authenticated with check (auth.uid() = user_id);
create policy "saves_update_own" on public.saves for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Ranking: todos lo pueden ver, cada uno solo escribe su propia fila.
create table if not exists public.leaderboard (
  user_id     uuid primary key references auth.users(id) on delete cascade,
  name        text not null check (char_length(name) between 1 and 40),
  avatar_url  text,
  prestige    int    not null default 0 check (prestige between 0 and 1000),
  max_level   int    not null default 1 check (max_level between 1 and 50),
  peak_level  int    not null default 1 check (peak_level between 1 and 50),
  total_coins bigint not null default 0 check (total_coins >= 0),
  difficulty  text,
  updated_at  timestamptz not null default now()
);
alter table public.leaderboard enable row level security;

drop policy if exists "leaderboard_select_all" on public.leaderboard;
drop policy if exists "leaderboard_insert_own" on public.leaderboard;
drop policy if exists "leaderboard_update_own" on public.leaderboard;
create policy "leaderboard_select_all" on public.leaderboard for select to anon, authenticated using (true);
create policy "leaderboard_insert_own" on public.leaderboard for insert to authenticated with check (auth.uid() = user_id);
create policy "leaderboard_update_own" on public.leaderboard for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create index if not exists leaderboard_rank_idx on public.leaderboard (prestige desc, max_level desc, total_coins desc);

grant select on public.leaderboard to anon, authenticated;
grant select, insert, update on public.leaderboard to authenticated;
grant select, insert, update on public.saves to authenticated;
