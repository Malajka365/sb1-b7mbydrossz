export interface VideoData {
  id: string;
  title: string;
  description: string;
  youtube_id: string;
  tags: { [key: string]: string[] };
  category: string;
  created_at: string;
  user_id: string;
}

export interface TagGroup {
  id: string;
  name: string;
  tags: string[];
  category: string;
  created_at: string;
  user_id: string;
}

export interface Profile {
  id: string;
  user_id: string;
  username: string;
  avatar_url?: string;
  created_at: string;
  updated_at: string;
}