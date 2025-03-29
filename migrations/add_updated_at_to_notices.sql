-- Add updated_at column to notices table
ALTER TABLE notices 
ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT NOW();

-- Update existing notices to have updated_at same as created_at
UPDATE notices 
SET updated_at = created_at; 