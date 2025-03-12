import { useQuery } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Apartment } from "@shared/schema";
import { Loader2 } from "lucide-react";
import { useState } from "react";

export default function ApartmentDirectory() {
  const [selectedTower, setSelectedTower] = useState<string>("1");

  const { data: apartments, isLoading } = useQuery<Apartment[]>({
    queryKey: [`/api/towers/${selectedTower}/apartments`],
  });

  const towerNumbers = Array.from({ length: 16 }, (_, i) => (i + 1).toString());

  return (
    <div className="container p-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
        <h1 className="text-3xl font-bold">Apartment Directory</h1>
        <Select value={selectedTower} onValueChange={setSelectedTower}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Select Tower" />
          </SelectTrigger>
          <SelectContent>
            {towerNumbers.map((tower) => (
              <SelectItem key={tower} value={tower}>
                Tower {tower}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center h-64">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {apartments?.map((apartment) => (
            <Card key={apartment.id}>
              <CardHeader>
                <CardTitle>Apartment {apartment.number}</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Floor</span>
                    <span className="font-medium">{apartment.floor}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Type</span>
                    <span className="font-medium">{apartment.type}</span>
                  </div>
                  <div
                    className={`mt-4 p-2 text-center rounded-lg ${
                      apartment.type === "3BHK"
                        ? "bg-purple-100 text-purple-800"
                        : "bg-blue-100 text-blue-800"
                    }`}
                  >
                    {apartment.type}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}