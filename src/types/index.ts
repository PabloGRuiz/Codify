export interface UserProfile {
  id: string;
  username: string;
  avatar_url?: string;
  xp: number;
  streak_days: number;
  last_login?: string;
  role: string;
  reputation_stars: number;
}

export interface Course {
  id: string;
  title: string;
  description: string;
  tags?: string[];
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
