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

export type ReportType = "theory_error" | "quiz_error" | "test_code_error" | "typo" | "other";
export type ReportStatus = "pending" | "in_review" | "resolved" | "dismissed";

export interface ContentReport {
  id: string;
  user_id: string;
  challenge_id?: string | null;
  course_id?: string | null;
  report_type: ReportType;
  title: string;
  description: string;
  status: ReportStatus;
  admin_notes?: string | null;
  created_at: string;
  updated_at?: string;
  profile?: {
    username: string;
    avatar_url?: string;
  };
  challenge?: {
    id: string;
    title: string;
    challenge_type: string;
  };
  course?: {
    id: string;
    title: string;
  };
}

export interface Certification {
  id: string;
  course_id: string;
  title: string;
  code: string;
  description: string;
  min_passing_score: number;
  time_limit_minutes: number;
  xp_reward: number;
  badge_theme: "gold" | "emerald" | "cyan" | "purple" | "crimson";
  skills_validated: string[];
  created_at: string;
  questions?: CertificationQuestion[];
  courses?: {
    id: string;
    title: string;
    description: string;
    tags?: string[];
  };
}

export interface CertificationQuestion {
  id: string;
  certification_id: string;
  question: string;
  options: string[];
  correct_index: number;
  explanation?: string;
  created_at: string;
}

export interface UserCertification {
  id: string;
  user_id: string;
  certification_id: string;
  verification_code: string;
  score: number;
  issued_at: string;
  certification?: Certification;
  profile?: {
    username: string;
    avatar_url?: string;
  };
}

export interface ExamAttempt {
  id: string;
  user_id: string;
  certification_id: string;
  score: number;
  passed: boolean;
  total_questions: number;
  correct_answers: number;
  created_at: string;
}
