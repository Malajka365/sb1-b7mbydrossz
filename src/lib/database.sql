-- Enable RLS (Row Level Security)
alter table videos enable row level security;
alter table tag_groups enable row level security;
alter table profiles enable row level security;

-- Videos policies
create policy "Videos are viewable by everyone"
  on videos for select
  using (true);

create policy "Authenticated users can insert videos"
  on videos for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "Users can update their own videos"
  on videos for update
  using (auth.uid() = user_id);

create policy "Users can delete their own videos"
  on videos for delete
  using (auth.uid() = user_id);

-- Tag groups policies
create policy "Tag groups are viewable by everyone"
  on tag_groups for select
  using (true);

create policy "Authenticated users can insert tag groups"
  on tag_groups for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "Users can update their own tag groups"
  on tag_groups for update
  using (auth.uid() = user_id);

create policy "Users can delete their own tag groups"
  on tag_groups for delete
  using (auth.uid() = user_id);

-- Profiles policies
create policy "Public profiles are viewable by everyone"
  on profiles for select
  using (true);

create policy "Users can insert their own profile"
  on profiles for insert
  with check (auth.uid() = id);

create policy "Users can update their own profile"
  on profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

create policy "Users can delete their own profile"
  on profiles for delete
  using (auth.uid() = id);

-- Ensure referential integrity
alter table profiles
  add constraint profiles_id_fkey
  foreign key (id)
  references auth.users(id)
  on delete cascade;

-- Handle updated_at timestamps
create function public.handle_updated_at()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger on_profiles_updated
  before update on profiles
  for each row
  execute procedure handle_updated_at();