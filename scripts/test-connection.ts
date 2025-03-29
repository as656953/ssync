import { testSupabaseConnection } from "../lib/test-connection";

async function main() {
  console.log("Testing Supabase connection...");
  const isConnected = await testSupabaseConnection();
  if (isConnected) {
    console.log("✅ Supabase connection is working!");
  } else {
    console.log("❌ Failed to connect to Supabase");
  }
  process.exit(isConnected ? 0 : 1);
}

main().catch(console.error);
