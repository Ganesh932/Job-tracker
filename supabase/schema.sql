-- Job Tracker Gmail integration schema
create extension if not exists pgcrypto;

create table if not exists public.applications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  company text not null,
  role text,
  source text default 'Other',
  status text not null default 'Applied',
  recruiter_name text,
  recruiter_email text,
  recruiter_phone text,
  applied_date date,
  contacted_date date,
  interview_date timestamptz,
  location text,
  job_url text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.gmail_connections (
  user_id uuid primary key references auth.users(id) on delete cascade,
  provider text not null default 'google',
  google_subject text,
  email text,
  access_token text,
  refresh_token text,
  token_expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.gmail_messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  gmail_message_id text not null,
  thread_id text,
  sender text,
  subject text,
  received_at timestamptz,
  snippet text,
  parsed jsonb,
  processed_at timestamptz,
  created_at timestamptz not null default now(),
  unique(user_id, gmail_message_id)
);

create table if not exists public.application_events (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null references public.applications(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  event_type text not null,
  event_date timestamptz not null default now(),
  details jsonb,
  created_at timestamptz not null default now()
);

alter table public.applications enable row level security;
alter table public.gmail_connections enable row level security;
alter table public.gmail_messages enable row level security;
alter table public.application_events enable row level security;

create policy "users manage own applications" on public.applications for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users manage own gmail connection" on public.gmail_connections for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users manage own gmail messages" on public.gmail_messages for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "users manage own application events" on public.application_events for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
