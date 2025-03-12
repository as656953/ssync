import { useQuery, useMutation } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { Amenity, insertBookingSchema } from "@shared/schema";
import { Calendar } from "@/components/ui/calendar";
import { useState } from "react";
import { format } from "date-fns";
import { apiRequest, queryClient } from "@/lib/queryClient";
import { Loader2, Users, Home, Dumbbell } from "lucide-react";

export default function Amenities() {
  const { toast } = useToast();
  const [selectedDate, setSelectedDate] = useState<Date | undefined>(new Date());
  const [selectedAmenity, setSelectedAmenity] = useState<Amenity | null>(null);

  const { data: amenities, isLoading } = useQuery<Amenity[]>({
    queryKey: ["/api/amenities"],
  });

  const bookingMutation = useMutation({
    mutationFn: async () => {
      if (!selectedDate || !selectedAmenity) return;

      const startTime = new Date(selectedDate);
      startTime.setHours(9, 0, 0); // 9 AM
      const endTime = new Date(selectedDate);
      endTime.setHours(21, 0, 0); // 9 PM

      const bookingData = insertBookingSchema.parse({
        amenityId: selectedAmenity.id,
        startTime: startTime.toISOString(),
        endTime: endTime.toISOString(),
        status: "PENDING",
      });

      const res = await apiRequest("POST", "/api/bookings", bookingData);
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/bookings"] });
      toast({
        title: "Booking request submitted",
        description: "Your booking request is pending approval.",
      });
      setSelectedAmenity(null);
    },
    onError: (error: Error) => {
      toast({
        title: "Booking failed",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  const getAmenityIcon = (type: string) => {
    switch (type) {
      case "GYM":
        return <Dumbbell className="h-6 w-6" />;
      case "GUEST_HOUSE":
        return <Home className="h-6 w-6" />;
      case "CLUBHOUSE":
        return <Users className="h-6 w-6" />;
      default:
        return null;
    }
  };

  return (
    <div className="container p-6">
      <h1 className="text-3xl font-bold mb-6">Amenities</h1>

      {isLoading ? (
        <div className="flex items-center justify-center h-64">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {amenities?.map((amenity) => (
            <Card key={amenity.id}>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  {getAmenityIcon(amenity.type)}
                  {amenity.name}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-muted-foreground mb-4">
                  {amenity.description}
                </p>
                <div className="flex justify-between items-center mb-4">
                  <span className="text-sm text-muted-foreground">
                    Max Capacity
                  </span>
                  <span className="font-medium">{amenity.maxCapacity} people</span>
                </div>
                <Dialog>
                  <DialogTrigger asChild>
                    <Button
                      className="w-full"
                      onClick={() => setSelectedAmenity(amenity)}
                    >
                      Book Now
                    </Button>
                  </DialogTrigger>
                  <DialogContent>
                    <DialogHeader>
                      <DialogTitle>Book {amenity.name}</DialogTitle>
                    </DialogHeader>
                    <div className="py-4">
                      <Calendar
                        mode="single"
                        selected={selectedDate}
                        onSelect={setSelectedDate}
                        className="rounded-md border"
                        disabled={(date) => date < new Date()}
                      />
                      <div className="mt-4 text-sm text-muted-foreground">
                        Selected date:{" "}
                        {selectedDate && format(selectedDate, "PPP")}
                      </div>
                      <Button
                        className="w-full mt-4"
                        onClick={() => bookingMutation.mutate()}
                        disabled={!selectedDate || bookingMutation.isPending}
                      >
                        {bookingMutation.isPending ? (
                          <>
                            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                            Booking...
                          </>
                        ) : (
                          "Confirm Booking"
                        )}
                      </Button>
                    </div>
                  </DialogContent>
                </Dialog>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
