import type { Express } from "express";
import { createServer, type Server } from "http";
import { setupAuth } from "./auth";
import { storage } from "./storage";
import { insertBookingSchema } from "@shared/schema";
import { ZodError } from "zod";

export async function registerRoutes(app: Express): Promise<Server> {
  setupAuth(app);

  // Get all apartments
  app.get("/api/apartments", async (_req, res) => {
    const apartments = await storage.getApartments();
    res.json(apartments);
  });

  // Get apartments by tower
  app.get("/api/towers/:towerId/apartments", async (req, res) => {
    const towerId = parseInt(req.params.towerId);
    const apartments = await storage.getApartmentsByTower(towerId);
    res.json(apartments);
  });

  // Get all amenities
  app.get("/api/amenities", async (_req, res) => {
    const amenities = await storage.getAmenities();
    res.json(amenities);
  });

  // Get specific amenity
  app.get("/api/amenities/:id", async (req, res) => {
    const amenity = await storage.getAmenity(parseInt(req.params.id));
    if (!amenity) return res.status(404).send("Amenity not found");
    res.json(amenity);
  });

  // Create booking
  app.post("/api/bookings", async (req, res) => {
    if (!req.isAuthenticated()) return res.sendStatus(401);
    
    try {
      const bookingData = insertBookingSchema.parse({
        ...req.body,
        userId: req.user!.id,
        status: "PENDING"
      });
      
      const booking = await storage.createBooking(bookingData);
      res.status(201).json(booking);
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json(error.errors);
      } else {
        res.status(500).send("Internal server error");
      }
    }
  });

  // Get user's bookings
  app.get("/api/bookings/user", async (req, res) => {
    if (!req.isAuthenticated()) return res.sendStatus(401);
    const bookings = await storage.getBookingsByUser(req.user!.id);
    res.json(bookings);
  });

  const httpServer = createServer(app);
  return httpServer;
}
