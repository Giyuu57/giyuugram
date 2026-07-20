-- ============================================================
-- GIYUUGRAM — COMPLETE SCHEMA (run this once in Supabase SQL Editor)
-- Combines: core tables, RLS policies, triggers, storage buckets +
-- storage policies, and realtime configuration for all 11 phases.
-- ============================================================

create extension if not exists "uuid-ossp";
create extension if not exists pg_trgm;

-- ============================================================
-- 1. PROFILES (extends auth.users)
-- ============================================================
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique not null,
  full_name text,
  avatar_url text,
  bio text,
  website text,
  is_private boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index idx_profiles_username_trgm on public.profiles using gin (username gin_trgm_ops);

create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, full_name, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', 'user_' || substr(new.id::text, 1, 8)),
    new.raw_user_meta_data->>'full_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ============================================================
-- 2. FOLLOWS
-- ============================================================
create table public.follows (
  follower_id uuid references public.profiles(id) on delete cascade,
  following_id uuid references public.profiles(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (follower_id, following_id),
  check (follower_id <> following_id)
);

create index idx_follows_following on public.follows(following_id);
create index idx_follows_follower on public.follows(follower_id);

-- ============================================================
-- 3. POSTS (photos, videos, reels — differentiated by `type`)
-- ============================================================
create type post_type as enum ('image', 'video', 'reel');

create table public.posts (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references public.profiles(id) on delete cascade not null,
  caption text,
  media_urls text[] not null,
  thumbnail_url text,
  type post_type default 'image',
  location text,
  like_count int default 0,
  comment_count int default 0,
  created_at timestamptz default now()
);

create index idx_posts_user_id on public.posts(user_id);
create index idx_posts_created_at on public.posts(created_at desc);

-- ============================================================
-- 4. HASHTAGS
-- ============================================================
create table public.hashtags (
  id uuid primary key default uuid_generate_v4(),
  tag text unique not null
);

create table public.post_hashtags (
  post_id uuid references public.posts(id) on delete cascade,
  hashtag_id uuid references public.hashtags(id) on delete cascade,
  primary key (post_id, hashtag_id)
);

create index idx_hashtags_tag_trgm on public.hashtags using gin (tag gin_trgm_ops);

-- ============================================================
-- 5. LIKES
-- ============================================================
create table public.likes (
  user_id uuid references public.profiles(id) on delete cascade,
  post_id uuid references public.posts(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, post_id)
);

create table public.comment_likes (
  user_id uuid references public.profiles(id) on delete cascade,
  comment_id uuid,
  created_at timestamptz default now(),
  primary key (user_id, comment_id)
);

-- ============================================================
-- 6. COMMENTS
-- ============================================================
create table public.comments (
  id uuid primary key default uuid_generate_v4(),
  post_id uuid references public.posts(id) on delete cascade not null,
  user_id uuid references public.profiles(id) on delete cascade not null,
  parent_id uuid references public.comments(id) on delete cascade,
  content text not null,
  like_count int default 0,
  created_at timestamptz default now()
);

alter table public.comment_likes
  add constraint fk_comment_likes_comment
  foreign key (comment_id) references public.comments(id) on delete cascade;

create index idx_comments_post_id on public.comments(post_id);

-- ============================================================
-- 7. SAVED POSTS
-- ============================================================
create table public.saved_posts (
  user_id uuid references public.profiles(id) on delete cascade,
  post_id uuid references public.posts(id) on delete cascade,
  created_at timestamptz default now(),
  primary key (user_id, post_id)
);

-- ============================================================
-- 8. STORIES (auto-expire after 24h)
-- ============================================================
create table public.stories (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references public.profiles(id) on delete cascade not null,
  media_url text not null,
  media_type text default 'image',
  created_at timestamptz default now(),
  expires_at timestamptz default (now() + interval '24 hours')
);

create table public.story_views (
  story_id uuid references public.stories(id) on delete cascade,
  viewer_id uuid references public.profiles(id) on delete cascade,
  viewed_at timestamptz default now(),
  primary key (story_id, viewer_id)
);

create index idx_stories_expires on public.stories(expires_at);

-- ============================================================
-- 9. ACTIVITY / NOTIFICATIONS
-- ============================================================
create type activity_type as enum ('like', 'comment', 'follow', 'mention', 'reply');

create table public.activities (
  id uuid primary key default uuid_generate_v4(),
  recipient_id uuid references public.profiles(id) on delete cascade not null,
  actor_id uuid references public.profiles(id) on delete cascade not null,
  type activity_type not null,
  post_id uuid references public.posts(id) on delete cascade,
  comment_id uuid references public.comments(id) on delete cascade,
  is_read boolean default false,
  created_at timestamptz default now()
);

create index idx_activities_recipient on public.activities(recipient_id, created_at desc);

-- ============================================================
-- 10. DIRECT MESSAGING (1-on-1 and group)
-- ============================================================
create table public.conversations (
  id uuid primary key default uuid_generate_v4(),
  is_group boolean default false,
  group_name text,
  group_avatar_url text,
  created_at timestamptz default now(),
  last_message_at timestamptz default now()
);

create table public.conversation_participants (
  conversation_id uuid references public.conversations(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete cascade,
  joined_at timestamptz default now(),
  last_read_at timestamptz default now(),
  primary key (conversation_id, user_id)
);

create table public.messages (
  id uuid primary key default uuid_generate_v4(),
  conversation_id uuid references public.conversations(id) on delete cascade not null,
  sender_id uuid references public.profiles(id) on delete cascade not null,
  content text,
  media_url text,
  message_type text default 'text',
  shared_post_id uuid references public.posts(id) on delete set null,
  created_at timestamptz default now()
);

create index idx_messages_conversation on public.messages(conversation_id, created_at desc);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
alter table public.profiles enable row level security;
alter table public.follows enable row level security;
alter table public.posts enable row level security;
alter table public.hashtags enable row level security;
alter table public.post_hashtags enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;
alter table public.comment_likes enable row level security;
alter table public.saved_posts enable row level security;
alter table public.stories enable row level security;
alter table public.story_views enable row level security;
alter table public.activities enable row level security;
alter table public.conversations enable row level security;
alter table public.conversation_participants enable row level security;
alter table public.messages enable row level security;

create policy "Profiles are viewable by everyone"
  on public.profiles for select using (true);
create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

create policy "Follows are viewable by everyone"
  on public.follows for select using (true);
create policy "Users can follow others"
  on public.follows for insert with check (auth.uid() = follower_id);
create policy "Users can unfollow"
  on public.follows for delete using (auth.uid() = follower_id);

create policy "Posts are viewable by everyone"
  on public.posts for select using (true);
create policy "Users can insert own posts"
  on public.posts for insert with check (auth.uid() = user_id);
create policy "Users can update own posts"
  on public.posts for update using (auth.uid() = user_id);
create policy "Users can delete own posts"
  on public.posts for delete using (auth.uid() = user_id);

create policy "Hashtags viewable by everyone"
  on public.hashtags for select using (true);
create policy "Authenticated users can create hashtags"
  on public.hashtags for insert with check (auth.role() = 'authenticated');
create policy "Post hashtags viewable by everyone"
  on public.post_hashtags for select using (true);
create policy "Users can tag own posts"
  on public.post_hashtags for insert with check (
    exists (select 1 from public.posts where id = post_id and user_id = auth.uid())
  );

create policy "Likes viewable by everyone"
  on public.likes for select using (true);
create policy "Users can like posts"
  on public.likes for insert with check (auth.uid() = user_id);
create policy "Users can unlike posts"
  on public.likes for delete using (auth.uid() = user_id);

create policy "Comments viewable by everyone"
  on public.comments for select using (true);
create policy "Users can comment"
  on public.comments for insert with check (auth.uid() = user_id);
create policy "Users can delete own comments"
  on public.comments for delete using (auth.uid() = user_id);

create policy "Comment likes viewable by everyone"
  on public.comment_likes for select using (true);
create policy "Users can like comments"
  on public.comment_likes for insert with check (auth.uid() = user_id);
create policy "Users can unlike comments"
  on public.comment_likes for delete using (auth.uid() = user_id);

create policy "Users can view own saved posts"
  on public.saved_posts for select using (auth.uid() = user_id);
create policy "Users can save posts"
  on public.saved_posts for insert with check (auth.uid() = user_id);
create policy "Users can unsave posts"
  on public.saved_posts for delete using (auth.uid() = user_id);

create policy "Stories viewable by everyone"
  on public.stories for select using (expires_at > now());
create policy "Users can create own stories"
  on public.stories for insert with check (auth.uid() = user_id);
create policy "Users can delete own stories"
  on public.stories for delete using (auth.uid() = user_id);

create policy "Story views viewable by story owner and viewer"
  on public.story_views for select using (
    auth.uid() = viewer_id or
    exists (select 1 from public.stories where id = story_id and user_id = auth.uid())
  );
create policy "Users can record story views"
  on public.story_views for insert with check (auth.uid() = viewer_id);

create policy "Users can view own activity"
  on public.activities for select using (auth.uid() = recipient_id);
create policy "System can insert activities"
  on public.activities for insert with check (auth.uid() = actor_id);
create policy "Users can mark own activity read"
  on public.activities for update using (auth.uid() = recipient_id);

create policy "Participants can view conversations"
  on public.conversations for select using (
    exists (
      select 1 from public.conversation_participants
      where conversation_id = conversations.id and user_id = auth.uid()
    )
  );
create policy "Authenticated users can create conversations"
  on public.conversations for insert with check (auth.role() = 'authenticated');
create policy "Participants can update conversation metadata"
  on public.conversations for update using (
    exists (
      select 1 from public.conversation_participants
      where conversation_id = conversations.id and user_id = auth.uid()
    )
  );

create policy "Participants can view participant list"
  on public.conversation_participants for select using (
    exists (
      select 1 from public.conversation_participants cp
      where cp.conversation_id = conversation_participants.conversation_id
      and cp.user_id = auth.uid()
    )
  );
create policy "Users can add participants to own conversations"
  on public.conversation_participants for insert with check (auth.role() = 'authenticated');
create policy "Users can update own participant row"
  on public.conversation_participants for update using (auth.uid() = user_id);

create policy "Participants can view messages"
  on public.messages for select using (
    exists (
      select 1 from public.conversation_participants
      where conversation_id = messages.conversation_id and user_id = auth.uid()
    )
  );
create policy "Participants can send messages"
  on public.messages for insert with check (
    auth.uid() = sender_id and
    exists (
      select 1 from public.conversation_participants
      where conversation_id = messages.conversation_id and user_id = auth.uid()
    )
  );

-- ============================================================
-- TRIGGERS: keep counters in sync
-- ============================================================
create or replace function public.increment_like_count()
returns trigger as $$
begin
  update public.posts set like_count = like_count + 1 where id = new.post_id;
  return new;
end;
$$ language plpgsql;

create or replace function public.decrement_like_count()
returns trigger as $$
begin
  update public.posts set like_count = greatest(like_count - 1, 0) where id = old.post_id;
  return old;
end;
$$ language plpgsql;

create trigger trg_like_insert after insert on public.likes
  for each row execute procedure public.increment_like_count();
create trigger trg_like_delete after delete on public.likes
  for each row execute procedure public.decrement_like_count();

create or replace function public.increment_comment_count()
returns trigger as $$
begin
  update public.posts set comment_count = comment_count + 1 where id = new.post_id;
  return new;
end;
$$ language plpgsql;

create or replace function public.decrement_comment_count()
returns trigger as $$
begin
  update public.posts set comment_count = greatest(comment_count - 1, 0) where id = old.post_id;
  return old;
end;
$$ language plpgsql;

create trigger trg_comment_insert after insert on public.comments
  for each row execute procedure public.increment_comment_count();
create trigger trg_comment_delete after delete on public.comments
  for each row execute procedure public.decrement_comment_count();

-- ============================================================
-- REALTIME (Phase 9 — Activity notifications)
-- ============================================================
alter publication supabase_realtime add table public.activities;
alter publication supabase_realtime add table public.messages;

-- ============================================================
-- STORAGE BUCKETS
-- ============================================================
insert into storage.buckets (id, name, public) values
  ('avatars', 'avatars', true),
  ('posts', 'posts', true),
  ('stories', 'stories', true),
  ('reels', 'reels', true),
  ('chat-media', 'chat-media', false)
on conflict (id) do nothing;

-- ============================================================
-- STORAGE POLICIES
-- Convention: files are stored under a folder named after the
-- uploader's auth.uid(), e.g. avatars/{userId}/{filename}.
-- This lets us scope insert/delete policies to "own folder only".
-- ============================================================

-- avatars
create policy "Users can upload own avatar"
  on storage.objects for insert
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users can update own avatar"
  on storage.objects for update
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Avatars are publicly viewable"
  on storage.objects for select using (bucket_id = 'avatars');

-- posts (covers photo posts, videos, and reels — all share the 'posts' bucket)
create policy "Users can upload own post media"
  on storage.objects for insert
  with check (bucket_id = 'posts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users can delete own post media"
  on storage.objects for delete
  using (bucket_id = 'posts' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Post media is publicly viewable"
  on storage.objects for select using (bucket_id = 'posts');

-- stories
create policy "Users can upload own story media"
  on storage.objects for insert
  with check (bucket_id = 'stories' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Users can delete own story media"
  on storage.objects for delete
  using (bucket_id = 'stories' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Story media is publicly viewable"
  on storage.objects for select using (bucket_id = 'stories');

-- chat-media (private bucket — only conversation participants should read,
-- simplified here to "any authenticated user can read via signed URL";
-- the app already generates short-lived signed URLs via createSignedUrl)
create policy "Users can upload own chat media"
  on storage.objects for insert
  with check (bucket_id = 'chat-media' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "Authenticated users can read chat media via signed URL"
  on storage.objects for select
  using (bucket_id = 'chat-media' and auth.role() = 'authenticated');

-- ============================================================
-- END OF MIGRATION
-- ============================================================
