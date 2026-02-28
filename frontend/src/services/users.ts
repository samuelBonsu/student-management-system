import api from '@/lib/api';

interface User {
  id: number;
  username: string;
  email: string;
  user_type: string;
}

interface UserProfile {
  id: number;
  user: number;
  first_name: string;
  last_name: string;
  preferred_name: string;
  current_level: number;
  discord_name?: string;
  github_username?: string;
  codepen_username?: string;
  fcc_profile_url?: string;
  phone?: string;
  timezone?: string;
}

export const userService = {
  getAllUsers: async (): Promise<User[]> => {
    try {
      const response = await api.get<User[]>('/users/');
      return response.data;
    } catch (error: any) {
      throw error.response?.data || { error: 'Failed to fetch users' };
    }
  },

  getUser: async (userId: number): Promise<User> => {
    try {
      const response = await api.get<User>(`/users/${userId}/`);
      return response.data;
    } catch (error: any) {
      throw error.response?.data || { error: 'Failed to fetch user' };
    }
  },

  getUserProfile: async (userId: number): Promise<UserProfile> => {
    try {
      const response = await api.get<UserProfile>(`/users/${userId}/profile/`);
      return response.data;
    } catch (error: any) {
      throw error.response?.data || { error: 'Failed to fetch profile' };
    }
  },

  updateUserProfile: async (userId: number, profileData: Partial<UserProfile>): Promise<any> => {
    try {
      const response = await api.post(`/users/${userId}/profile/`, profileData);
      return response.data;
    } catch (error: any) {
      throw error.response?.data || { error: 'Failed to update profile' };
    }
  },

  createUser: async (userData: { username: string; email: string; password: string; user_type?: string }): Promise<User> => {
    try {
      const response = await api.post<User>('/users/', {
        ...userData,
        user_type: userData.user_type || 'student'
      });
      return response.data;
    } catch (error: any) {
      throw error.response?.data || { error: 'Failed to create user' };
    }
  }
};