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
import { Loader2, Building2, Home, Phone, IndianRupee } from "lucide-react";
import { useState } from "react";

function getTowerLetter(towerId: number): string {
  return String.fromCharCode(64 + towerId); // A = 65 in ASCII
}

function formatCurrency(amount: string | number | null): string {
  if (!amount) return "N/A";
  const numericAmount = typeof amount === 'string' ? parseFloat(amount) : amount;
  return new Intl.NumberFormat('en-IN', {
    style: 'currency',
    currency: 'INR',
    maximumFractionDigits: 0
  }).format(numericAmount);
}

export default function ApartmentDirectory() {
  const [selectedTower, setSelectedTower] = useState<string>("1");
  const towerLetter = getTowerLetter(parseInt(selectedTower));

  const { data: apartments, isLoading } = useQuery<Apartment[]>({
    queryKey: [`/api/towers/${selectedTower}/apartments`],
  });

  return (
    <div className="container p-6">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
        <h1 className="text-3xl font-bold">Apartment Directory</h1>
        <Select value={selectedTower} onValueChange={setSelectedTower}>
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Select Tower">
              {selectedTower ? `Tower ${towerLetter}` : "Select Tower"}
            </SelectValue>
          </SelectTrigger>
          <SelectContent>
            {Array.from({ length: 16 }, (_, i) => i + 1).map((tower) => (
              <SelectItem key={tower} value={tower.toString()}>
                Tower {getTowerLetter(tower)}
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
            <Card key={apartment.id} className="hover:shadow-lg transition-shadow">
              <CardHeader>
                <CardTitle className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Building2 className="h-5 w-5 text-muted-foreground" />
                    <span>{`${towerLetter}-${apartment.floor}${apartment.number.slice(-2)}`}</span>
                  </div>
                  <div
                    className={`px-3 py-1 text-sm rounded-full ${
                      apartment.status === "AVAILABLE_RENT"
                        ? "bg-blue-100 text-blue-800"
                        : apartment.status === "AVAILABLE_SALE"
                        ? "bg-green-100 text-green-800"
                        : "bg-gray-100 text-gray-800"
                    }`}
                  >
                    {apartment.status === "AVAILABLE_RENT"
                      ? "For Rent"
                      : apartment.status === "AVAILABLE_SALE"
                      ? "For Sale"
                      : "Occupied"}
                  </div>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <span className="text-sm text-muted-foreground">Floor</span>
                      <p className="font-medium">{apartment.floor}</p>
                    </div>
                    <div>
                      <span className="text-sm text-muted-foreground">Type</span>
                      <p className="font-medium">{apartment.type}</p>
                    </div>
                  </div>

                  <div>
                    <span className="text-sm text-muted-foreground flex items-center gap-2">
                      <Home className="h-4 w-4" />
                      Owner
                    </span>
                    <p className="font-medium">{apartment.ownerName || "N/A"}</p>
                  </div>

                  {apartment.status !== "OCCUPIED" && (
                    <>
                      {apartment.status === "AVAILABLE_RENT" && apartment.monthlyRent && (
                        <div>
                          <span className="text-sm text-muted-foreground flex items-center gap-2">
                            <IndianRupee className="h-4 w-4" />
                            Monthly Rent
                          </span>
                          <p className="font-medium text-green-600">
                            {formatCurrency(apartment.monthlyRent)}
                          </p>
                        </div>
                      )}

                      {apartment.status === "AVAILABLE_SALE" && apartment.salePrice && (
                        <div>
                          <span className="text-sm text-muted-foreground flex items-center gap-2">
                            <IndianRupee className="h-4 w-4" />
                            Sale Price
                          </span>
                          <p className="font-medium text-green-600">
                            {formatCurrency(apartment.salePrice)}
                          </p>
                        </div>
                      )}

                      {apartment.contactNumber && (
                        <div>
                          <span className="text-sm text-muted-foreground flex items-center gap-2">
                            <Phone className="h-4 w-4" />
                            Contact
                          </span>
                          <p className="font-medium">{apartment.contactNumber}</p>
                        </div>
                      )}
                    </>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}