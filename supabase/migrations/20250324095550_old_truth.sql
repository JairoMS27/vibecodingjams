/*
  # Fix likes table and policies

  1. Changes
    - Remove user_id from likes table since we don't need authentication
    - Update RLS policies to allow public access to likes
    - Add unique constraint to prevent duplicate likes

  2. Security
    - Enable RLS on both tables
    - Allow public read access to projects
    - Allow public to manage likes
*/

-- Drop existing likes table and recreate it without user_id
DROP TABLE IF EXISTS likes;

CREATE TABLE likes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(project_id)
);

-- Enable RLS
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public read access on projects" ON projects;
DROP POLICY IF EXISTS "Allow public to manage likes" ON likes;

-- Create policies
CREATE POLICY "Allow public read access on projects"
  ON projects
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow public to manage likes"
  ON likes
  FOR ALL
  TO public
  USING (true)
  WITH CHECK (true);