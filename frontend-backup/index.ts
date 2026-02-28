export interface User {
  id: number;
  username: string;
  email: string;
  user_type: 'student' | 'admin' | 'volunteer';
}

export interface UserProfile {
  id: number;
  user: number;
  first_name: string;
  last_name: string;
  preferred_name: string;
  discord_name?: string;
  github_username?: string;
  codepen_username?: string;
  fcc_profile_url?: string;
  current_level: number;
  phone?: string;
  timezone?: string;
  created_at: string;
  updated_at: string;
}

export interface LoginCredentials {
  username: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  user_id: number;
  email: string;
}

export interface Project {
  id: number;
  title: string;
  description: string;
  url: string;
  level: number;
  required: boolean;
}

export interface StudentSubmission {
  id: number;
  student: number;
  project: number;
  url: string;
  feedback?: string;
  approved: boolean;
  created_at: string;
}