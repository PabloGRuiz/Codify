export interface UserProfile {
  id: string;
  username: string;
  avatar_url?: string;
  xp: number;
  level?: number;
  streak_days: number;
  last_login?: string;
  role: string;
  reputation_stars: number;
}

export interface Course {
  id: string;
  title: string;
  description: string;
  summary?: string;
  tags?: string[];
  image_url?: string;
  prerequisite_course_id?: string | null;
  min_level?: number;
  prerequisite_course?: {
    id: string;
    title: string;
  } | null;
}

export interface Module {
  id: string;
  course_id: string;
  title: string;
  description: string;
}

export interface Challenge {
  id: string;
  module_id: string;
  title: string;
  description: string;
  order_index: number;
  xp_reward: number;
}

export interface Notification {
  id: string;
  user_id: string;
  type: "course" | "forum" | "system" | "achievement";
  title: string;
  message: string;
  link?: string | null;
  read: boolean;
  created_at: string;
}
