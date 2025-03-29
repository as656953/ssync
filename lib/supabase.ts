import { createClient } from "@supabase/supabase-js";

const supabaseUrl = "https://bbkexkvajqtsbxysjjll.supabase.co";
const supabaseAnonKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJia2V4a3ZhanF0c2J4eXNqamxsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMxNjMxMTIsImV4cCI6MjA1ODczOTExMn0.2iAqppIesswMX61HYEG5JI0LdwzRa7hyhazB1Zn948s";

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Database connection string for direct PostgreSQL access
export const DATABASE_URL =
  "postgresql://postgres.bbkexkvajqtsbxysjjll:AdityaSingh123!@aws-0-ap-south-1.pooler.supabase.com:6543/postgres";
