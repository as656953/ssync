import { supabase } from "./supabase";

export async function testSupabaseConnection() {
  try {
    // Test towers table
    const { data: towers, error: towersError } = await supabase
      .from("towers")
      .select("*");

    if (towersError) {
      console.error("Error accessing towers table:", towersError.message);
      return false;
    }

    console.log("✅ Connected to Supabase successfully!");
    console.log("Found", towers?.length || 0, "towers in the database");

    // Try to insert a test tower if none exist
    if (!towers?.length) {
      const { error: insertError } = await supabase
        .from("towers")
        .insert([{ name: "Test Tower" }]);

      if (insertError) {
        console.error("Error inserting test data:", insertError.message);
        return false;
      }
      console.log("✅ Successfully inserted test data");
    }

    return true;
  } catch (err) {
    console.error("Failed to connect to Supabase:", err);
    return false;
  }
}
