-- Rename importance column to priority
ALTER TABLE notices 
RENAME COLUMN importance TO priority; 