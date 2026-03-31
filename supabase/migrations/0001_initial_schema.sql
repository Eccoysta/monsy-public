create extension if not exists pgcrypto;

create type habit_status as enum ('draft', 'active', 'paused', 'completed', 'dying');
create type plant_health_state as enum ('healthy', 'dying');

create or replace function set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nickname text not null check (char_length(trim(nickname)) between 1 and 24),
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_profiles_updated_at
before update on profiles
for each row execute function set_updated_at();

create table habits (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references profiles (id) on delete cascade,
  title text not null check (char_length(trim(title)) between 1 and 80),
  goal_days integer not null check (goal_days between 2 and 365),
  join_code char(5) not null unique check (join_code ~ '^[0-9]{5}$'),
  status habit_status not null default 'draft',
  member_count integer not null default 1 check (member_count >= 1),
  current_streak integer not null default 0 check (current_streak >= 0),
  current_level integer not null default 1 check (current_level between 1 and 16),
  plant_state plant_health_state not null default 'healthy',
  broken_streak_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_habits_updated_at
before update on habits
for each row execute function set_updated_at();

create index idx_habits_join_code on habits (join_code);
create index idx_habits_owner_id on habits (owner_id);

create table habit_members (
  habit_id uuid not null references habits (id) on delete cascade,
  profile_id uuid not null references profiles (id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'member')),
  joined_at timestamptz not null default now(),
  primary key (habit_id, profile_id)
);

create index idx_habit_members_profile_id on habit_members (profile_id);
create index idx_habit_members_habit_id on habit_members (habit_id);

create or replace function sync_habit_membership_count()
returns trigger
language plpgsql
as $$
declare
  target_habit_id uuid := coalesce(new.habit_id, old.habit_id);
begin
  update habits
  set member_count = (
    select count(*)::integer
    from habit_members
    where habit_id = target_habit_id
  )
  where id = target_habit_id;

  update habits
  set status = case
    when member_count >= 2 and status = 'draft' then 'active'
    else status
  end
  where id = target_habit_id;

  if tg_op = 'DELETE' then
    return old;
  end if;

  return new;
end;
$$;

create trigger trg_habit_members_insert
after insert on habit_members
for each row execute function sync_habit_membership_count();

create trigger trg_habit_members_delete
after delete on habit_members
for each row execute function sync_habit_membership_count();

create table verification_photos (
  id uuid primary key default gen_random_uuid(),
  habit_id uuid not null references habits (id) on delete cascade,
  uploaded_by uuid not null references profiles (id) on delete cascade,
  storage_path text not null,
  caption text,
  day_index integer not null default 1 check (day_index >= 1),
  created_at timestamptz not null default now()
);

create index idx_verification_photos_habit_id_created_at on verification_photos (habit_id, created_at desc);

create table verification_photo_approvals (
  photo_id uuid not null references verification_photos (id) on delete cascade,
  profile_id uuid not null references profiles (id) on delete cascade,
  approved boolean not null default true,
  created_at timestamptz not null default now(),
  primary key (photo_id, profile_id)
);

create index idx_verification_photo_approvals_profile_id on verification_photo_approvals (profile_id);

create table habit_growth_snapshots (
  id uuid primary key default gen_random_uuid(),
  habit_id uuid not null references habits (id) on delete cascade,
  level integer not null check (level between 1 and 16),
  health_state plant_health_state not null default 'healthy',
  streak_days integer not null default 0 check (streak_days >= 0),
  goal_days integer not null check (goal_days between 2 and 365),
  reason text,
  created_at timestamptz not null default now()
);

create index idx_habit_growth_snapshots_habit_id_created_at on habit_growth_snapshots (habit_id, created_at desc);

alter table profiles enable row level security;
alter table habits enable row level security;
alter table habit_members enable row level security;
alter table verification_photos enable row level security;
alter table verification_photo_approvals enable row level security;
alter table habit_growth_snapshots enable row level security;

-- RLS policies are intentionally left to be added once the app wiring is in place.
-- The first pass focuses on the schema shape, constraints, and growth/approval data model.

create or replace function generate_join_code()
returns char(5)
language plpgsql
as $$
declare
  candidate text;
begin
  loop
    candidate := lpad((floor(random() * 100000))::int::text, 5, '0');
    exit when not exists (
      select 1
      from habits
      where join_code = candidate::char(5)
    );
  end loop;

  return candidate::char(5);
end;
$$;
