import { User, InsertUser, Apartment, Amenity, Booking } from "@shared/schema";
import session from "express-session";
import createMemoryStore from "memorystore";

const MemoryStore = createMemoryStore(session);

export interface IStorage {
  getUser(id: number): Promise<User | undefined>;
  getUserByUsername(username: string): Promise<User | undefined>;
  createUser(user: InsertUser): Promise<User>;
  
  // Apartments
  getApartments(): Promise<Apartment[]>;
  getApartmentsByTower(towerId: number): Promise<Apartment[]>;
  
  // Amenities
  getAmenities(): Promise<Amenity[]>;
  getAmenity(id: number): Promise<Amenity | undefined>;
  
  // Bookings
  createBooking(booking: Omit<Booking, "id">): Promise<Booking>;
  getBookingsByUser(userId: number): Promise<Booking[]>;
  getBookingsByAmenity(amenityId: number): Promise<Booking[]>;
  
  sessionStore: session.Store;
}

export class MemStorage implements IStorage {
  private users: Map<number, User>;
  private apartments: Map<number, Apartment>;
  private amenities: Map<number, Amenity>;
  private bookings: Map<number, Booking>;
  sessionStore: session.Store;
  private currentId: number;

  constructor() {
    this.users = new Map();
    this.apartments = new Map();
    this.amenities = new Map();
    this.bookings = new Map();
    this.currentId = 1;
    this.sessionStore = new MemoryStore({ checkPeriod: 86400000 });
    
    // Initialize with sample data
    this.initializeData();
  }

  private initializeData() {
    // Initialize towers and apartments
    for (let tower = 1; tower <= 16; tower++) {
      for (let floor = 1; floor <= 6; floor++) {
        const apartmentsPerFloor = floor === 6 ? 2 : 4;
        for (let unit = 1; unit <= apartmentsPerFloor; unit++) {
          const apartment: Apartment = {
            id: this.currentId++,
            number: `${tower}-${floor}${unit}`,
            towerId: tower,
            floor,
            type: floor === 6 ? "3BHK" : "2BHK"
          };
          this.apartments.set(apartment.id, apartment);
        }
      }
    }

    // Initialize amenities
    const amenities: Omit<Amenity, "id">[] = [
      { name: "Gym", type: "GYM", description: "Fully equipped gymnasium", maxCapacity: 20 },
      { name: "Guest House 1", type: "GUEST_HOUSE", description: "Guest accommodation", maxCapacity: 4 },
      { name: "Guest House 2", type: "GUEST_HOUSE", description: "Guest accommodation", maxCapacity: 4 },
      { name: "Guest House 3", type: "GUEST_HOUSE", description: "Guest accommodation", maxCapacity: 4 },
      { name: "Guest House 4", type: "GUEST_HOUSE", description: "Guest accommodation", maxCapacity: 4 },
      { name: "Clubhouse", type: "CLUBHOUSE", description: "Community gathering space", maxCapacity: 100 }
    ];

    amenities.forEach(amenity => {
      this.amenities.set(this.currentId, { ...amenity, id: this.currentId++ });
    });
  }

  async getUser(id: number): Promise<User | undefined> {
    return this.users.get(id);
  }

  async getUserByUsername(username: string): Promise<User | undefined> {
    return Array.from(this.users.values()).find(
      (user) => user.username === username
    );
  }

  async createUser(insertUser: InsertUser): Promise<User> {
    const id = this.currentId++;
    const user: User = { ...insertUser, id };
    this.users.set(id, user);
    return user;
  }

  async getApartments(): Promise<Apartment[]> {
    return Array.from(this.apartments.values());
  }

  async getApartmentsByTower(towerId: number): Promise<Apartment[]> {
    return Array.from(this.apartments.values()).filter(
      (apt) => apt.towerId === towerId
    );
  }

  async getAmenities(): Promise<Amenity[]> {
    return Array.from(this.amenities.values());
  }

  async getAmenity(id: number): Promise<Amenity | undefined> {
    return this.amenities.get(id);
  }

  async createBooking(booking: Omit<Booking, "id">): Promise<Booking> {
    const id = this.currentId++;
    const newBooking: Booking = { ...booking, id };
    this.bookings.set(id, newBooking);
    return newBooking;
  }

  async getBookingsByUser(userId: number): Promise<Booking[]> {
    return Array.from(this.bookings.values()).filter(
      (booking) => booking.userId === userId
    );
  }

  async getBookingsByAmenity(amenityId: number): Promise<Booking[]> {
    return Array.from(this.bookings.values()).filter(
      (booking) => booking.amenityId === amenityId
    );
  }
}

export const storage = new MemStorage();
