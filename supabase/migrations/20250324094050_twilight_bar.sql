/*
  # Initial Schema Setup

  1. New Tables
    - `projects`
      - `id` (uuid, primary key)
      - `title` (text)
      - `description` (text)
      - `thumbnail` (text)
      - `play_url` (text)
      - `created_at` (timestamptz)
      - `creator_x` (text)
      - `category` (text)
    - `likes`
      - `id` (uuid, primary key)
      - `project_id` (uuid, foreign key)
      - `created_at` (timestamptz)
      - `user_id` (uuid, foreign key)

  2. Security
    - Enable RLS on both tables
    - Add policies for public read access
    - Add policies for authenticated users to like/unlike
*/

-- Create projects table
CREATE TABLE IF NOT EXISTS projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  thumbnail text NOT NULL,
  play_url text NOT NULL,
  created_at timestamptz DEFAULT now(),
  creator_x text,
  category text DEFAULT 'Action'
);

-- Create likes table
CREATE TABLE IF NOT EXISTS likes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES projects(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Enable RLS
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE likes ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow public read access on projects"
  ON projects
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow authenticated users to like projects"
  ON likes
  FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Insert initial data
INSERT INTO projects (id, title, description, thumbnail, play_url, created_at, creator_x, category)
VALUES 
  (
    gen_random_uuid(),
    'VibeSail',
    'Experience the future of sailing in this AI-powered virtual reality simulation',
    'https://vibesail.com/preview.jpg',
    'https://vibesail.com/',
    now() - interval '3 days',
    '@vibesail_dev',
    'Simulation'
  ),
  (
    gen_random_uuid(),
    'Fly',
    'An immersive flying experience powered by neural networks',
    'https://fly.pieter.com/preview.jpg',
    'https://fly.pieter.com',
    now() - interval '2 days',
    '@flygame_ai',
    'Action'
  ),
  (
    gen_random_uuid(),
    'Delta Metaverse',
    'Enter a new dimension of gaming with this AI-generated metaverse',
    'https://metaverse-delta.vercel.app/preview.jpg',
    'https://metaverse-delta.vercel.app/',
    now() - interval '1 day',
    '@deltameta_dev',
    'Adventure'
  ),
  (
    gen_random_uuid(),
    'First Person Flappy',
    'Classic game reimagined in first person with AI-generated environments',
    'https://firstpersonflappy.com/preview.jpg',
    'https://firstpersonflappy.com/',
    now(),
    '@fpflappy',
    'Action'
  );