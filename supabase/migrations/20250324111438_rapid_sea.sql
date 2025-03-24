/*
  # Add categories table and relationships

  1. New Tables
    - `categories`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `created_at` (timestamp)

  2. Changes
    - Add categories table
    - Add category_id to projects table
    - Migrate existing category data
    - Set up foreign key relationship

  3. Security
    - Enable RLS on categories table
    - Add policy for public read access
*/

-- Create categories table
CREATE TABLE categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Create policy for public read access
CREATE POLICY "Allow public read access on categories"
  ON categories
  FOR SELECT
  TO public
  USING (true);

-- Insert initial categories
INSERT INTO categories (name) VALUES
  ('Action'),
  ('Adventure'),
  ('Puzzle'),
  ('Strategy'),
  ('RPG'),
  ('Simulation'),
  ('Sports'),
  ('Racing');

-- Add category_id to projects (nullable initially)
ALTER TABLE projects 
  ADD COLUMN category_id uuid REFERENCES categories(id);

-- Update existing projects with category IDs
DO $$
BEGIN
  -- Update Action projects
  UPDATE projects
  SET category_id = (SELECT id FROM categories WHERE name = 'Action')
  WHERE category = 'Action';

  -- Update Adventure projects
  UPDATE projects
  SET category_id = (SELECT id FROM categories WHERE name = 'Adventure')
  WHERE category = 'Adventure';

  -- Update Simulation projects
  UPDATE projects
  SET category_id = (SELECT id FROM categories WHERE name = 'Simulation')
  WHERE category = 'Simulation';

  -- Set default category (Action) for any remaining projects
  UPDATE projects
  SET category_id = (SELECT id FROM categories WHERE name = 'Action')
  WHERE category_id IS NULL;
END $$;

-- Now make category_id NOT NULL
ALTER TABLE projects 
  ALTER COLUMN category_id SET NOT NULL;

-- Finally drop the old category column
ALTER TABLE projects 
  DROP COLUMN category;