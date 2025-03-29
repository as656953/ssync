// Get user's assigned apartments
router.get("/apartments", async (req, res) => {
  try {
    if (!req.session.user) {
      return res.status(401).json({ error: "Not authenticated" });
    }

    const userApartments = await db
      .select({
        id: apartments.id,
        number: apartments.number,
        type: apartments.type,
        floor: apartments.floor,
        towerId: apartments.towerId,
      })
      .from(userApartments)
      .innerJoin(apartments, eq(userApartments.apartmentId, apartments.id))
      .where(eq(userApartments.userId, req.session.user.id));

    res.json(userApartments);
  } catch (error) {
    console.error("Error fetching user apartments:", error);
    res.status(500).json({ error: "Failed to fetch apartments" });
  }
});

// Assign apartment to user
router.post("/:userId/apartments", async (req, res) => {
  try {
    const { apartmentId } = req.body;
    const userId = parseInt(req.params.userId);

    const [assignment] = await db
      .insert(userApartments)
      .values({
        userId,
        apartmentId,
      })
      .returning();

    res.json(assignment);
  } catch (error) {
    console.error("Error assigning apartment:", error);
    res.status(500).json({ error: "Failed to assign apartment" });
  }
});
