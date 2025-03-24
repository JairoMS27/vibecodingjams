import { createClient } from '@supabase/supabase-js';

// Get environment variables
const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error('Missing Supabase credentials. Please connect to Supabase using the "Connect to Supabase" button.');
}

// Create Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export const db = {
  async getCategories() {
    try {
      const { data: categories, error } = await supabase
        .from('categories')
        .select('*')
        .order('name');

      if (error) {
        console.error('Error fetching categories:', error);
        throw error;
      }

      return categories || [];
    } catch (error) {
      console.error('Error in getCategories:', error);
      return [];
    }
  },

  async getProjects() {
    try {
      const { data: projects, error } = await supabase
        .from('projects')
        .select(`
          *,
          categories (
            name
          )
        `);

      if (error) {
        console.error('Error fetching projects:', error);
        throw error;
      }

      return projects?.map(project => ({
        ...project,
        category: project.categories.name
      })) || [];
    } catch (error) {
      console.error('Error in getProjects:', error);
      return [];
    }
  }
};