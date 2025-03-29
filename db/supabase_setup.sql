-- Create towers table
CREATE TABLE IF NOT EXISTS towers (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

-- Create amenities table
CREATE TABLE IF NOT EXISTS amenities (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  description TEXT,
  max_capacity INTEGER
);

-- Create apartments table
CREATE TABLE IF NOT EXISTS apartments (
  id SERIAL PRIMARY KEY,
  number TEXT NOT NULL,
  tower_id INTEGER NOT NULL REFERENCES towers(id),
  floor INTEGER NOT NULL,
  type TEXT NOT NULL,
  owner_name TEXT,
  status TEXT NOT NULL DEFAULT 'OCCUPIED',
  monthly_rent NUMERIC,
  sale_price NUMERIC,
  contact_number TEXT
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  is_admin BOOLEAN NOT NULL DEFAULT false,
  name TEXT NOT NULL,
  apartment_id INTEGER REFERENCES apartments(id)
);

-- Create notices table
CREATE TABLE IF NOT EXISTS notices (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT NOW(),
  created_by INTEGER NOT NULL REFERENCES users(id),
  expires_at TIMESTAMP NOT NULL DEFAULT (NOW() + INTERVAL '7 days'),
  importance TEXT NOT NULL DEFAULT 'NORMAL'
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  amenity_id INTEGER NOT NULL REFERENCES amenities(id),
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  status TEXT NOT NULL
);

-- Insert sample data
INSERT INTO towers (name) VALUES
  ('Tower A'),
  ('Tower B'),
  ('Tower C');

INSERT INTO amenities (name, type, description, max_capacity) VALUES
  ('Swimming Pool', 'Sports', 'Olympic size swimming pool', 50),
  ('Gym', 'Fitness', 'Fully equipped gymnasium', 30),
  ('Community Hall', 'Event Space', 'Multi-purpose community hall', 200);

-- Insert a sample apartment for admin
INSERT INTO apartments (number, tower_id, floor, type, owner_name, status)
VALUES ('A-101', 1, 1, '3BHK', 'Admin', 'OCCUPIED');

-- Insert admin user
-- Note: In production, you should NEVER store plain-text passwords. 
-- This is just for development setup.
INSERT INTO users (username, password, is_admin, name, apartment_id)
VALUES (
  'admin@society.com', 
  'AdityaSingh123!',  -- This should be properly hashed in production
  true, 
  'Admin User',
  1  -- References the apartment we just created
);

-- Enable Row Level Security (RLS)
ALTER TABLE towers ENABLE ROW LEVEL SECURITY;
ALTER TABLE amenities ENABLE ROW LEVEL SECURITY;
ALTER TABLE apartments ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE notices ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Public towers access" ON towers FOR SELECT USING (true);
CREATE POLICY "Public amenities access" ON amenities FOR SELECT USING (true);
CREATE POLICY "Public apartments access" ON apartments FOR SELECT USING (true);

-- Users can only see their own data
CREATE POLICY "Users can see own data" ON users
  FOR SELECT USING (auth.uid()::text = username);

-- Notices policies
CREATE POLICY "Anyone can read notices" ON notices FOR SELECT USING (true);
CREATE POLICY "Only admins can create notices" ON notices 
  FOR INSERT WITH CHECK (
    auth.uid()::text IN (
      SELECT username FROM users WHERE is_admin = true
    )
  );

-- Bookings policies
CREATE POLICY "Users can see their bookings" ON bookings
  FOR SELECT USING (
    auth.uid()::text IN (
      SELECT username FROM users WHERE id = bookings.user_id
    )
  ); 