import { useQuery, useMutation } from "@tanstack/react-query";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { useToast } from "@/hooks/use-toast";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import {
  PlusCircle,
  Building2,
  Trash2,
  Home,
  IndianRupee,
  Phone,
  Settings,
} from "lucide-react";
import { useState } from "react";
import { apiRequest, queryClient } from "@/lib/queryClient";
import { motion, AnimatePresence } from "framer-motion";

interface Tower {
  id: number;
  name: string;
}

interface Apartment {
  id: number;
  number: string;
  towerId: number;
  type: string;
  floor: number;
  monthlyRent: number | null;
  salePrice: number | null;
  status: "OCCUPIED" | "FOR_RENT" | "FOR_SALE";
  ownerId: number | null;
  contactNumber: string | null;
}

const headingVariants = {
  initial: { opacity: 0, y: 20 },
  animate: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.5,
      ease: "easeOut",
    },
  },
};

const underlineVariants = {
  initial: { width: 0 },
  animate: {
    width: "100%",
    transition: {
      duration: 0.8,
      ease: "easeOut",
    },
  },
};

const iconVariants = {
  initial: { rotate: 0, scale: 0.8 },
  animate: {
    rotate: 360,
    scale: 1,
    transition: {
      duration: 0.8,
      ease: "easeOut",
    },
  },
};

const containerVariants = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
    },
  },
};

const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  show: { opacity: 1, y: 0 },
};

export default function ManageProperties() {
  const { toast } = useToast();
  const [selectedTower, setSelectedTower] = useState<Tower | null>(null);
  const [isAddTowerOpen, setIsAddTowerOpen] = useState(false);
  const [isAddApartmentOpen, setIsAddApartmentOpen] = useState(false);
  const [newTowerName, setNewTowerName] = useState("");
  const [newApartment, setNewApartment] = useState({
    number: "",
    type: "2BHK",
    floor: 1,
    monthlyRent: "",
    salePrice: "",
    status: "FOR_RENT",
    contactNumber: "",
  });

  const { data: towers, isLoading: isLoadingTowers } = useQuery<Tower[]>({
    queryKey: ["/api/towers"],
  });

  const { data: apartments, isLoading: isLoadingApartments } = useQuery<
    Apartment[]
  >({
    queryKey: ["/api/apartments", selectedTower?.id],
    enabled: !!selectedTower,
    queryFn: async () => {
      const res = await apiRequest(
        "GET",
        `/api/apartments?towerId=${selectedTower!.id}`
      );
      if (!res.ok) throw new Error("Failed to fetch apartments");
      return res.json();
    },
  });

  const addTowerMutation = useMutation({
    mutationFn: async (name: string) => {
      const res = await apiRequest("POST", "/api/towers", { name });
      if (!res.ok) throw new Error("Failed to add tower");
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/towers"] });
      setIsAddTowerOpen(false);
      setNewTowerName("");
      toast({
        title: "Tower added",
        description: "The tower has been added successfully.",
      });
    },
  });

  const addApartmentMutation = useMutation({
    mutationFn: async (data: any) => {
      if (!selectedTower) throw new Error("No tower selected");

      const apartmentData = {
        ...data,
        towerId: selectedTower.id,
        monthlyRent: data.monthlyRent ? parseFloat(data.monthlyRent) : null,
        salePrice: data.salePrice ? parseFloat(data.salePrice) : null,
      };

      const res = await apiRequest("POST", "/api/apartments", apartmentData);
      if (!res.ok) throw new Error("Failed to add apartment");
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["/api/apartments", selectedTower?.id],
      });
      setIsAddApartmentOpen(false);
      setNewApartment({
        number: "",
        type: "2BHK",
        floor: 1,
        monthlyRent: "",
        salePrice: "",
        status: "FOR_RENT",
        contactNumber: "",
      });
      toast({
        title: "Apartment added",
        description: "The apartment has been added successfully.",
      });
    },
  });

  const deleteTowerMutation = useMutation({
    mutationFn: async (towerId: number) => {
      // First delete all apartments in this tower
      await fetch(`/api/towers/${towerId}/apartments`, {
        method: "DELETE",
      });

      // Then delete the tower
      const response = await fetch(`/api/towers/${towerId}`, {
        method: "DELETE",
      });

      if (!response.ok) {
        throw new Error("Failed to delete tower");
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/towers"] });
      toast({
        title: "Tower deleted",
        description: "The tower and all its apartments have been deleted.",
      });
    },
    onError: (error: Error) => {
      toast({
        title: "Error",
        description: error.message,
        variant: "destructive",
      });
    },
  });

  const deleteApartmentMutation = useMutation({
    mutationFn: async (apartmentId: number) => {
      const res = await apiRequest("DELETE", `/api/apartments/${apartmentId}`);
      if (!res.ok) throw new Error("Failed to delete apartment");
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ["/api/apartments", selectedTower?.id],
      });
      toast({
        title: "Apartment deleted",
        description: "The apartment has been deleted successfully.",
      });
    },
  });

  return (
    <div className="container p-6 space-y-8">
      {/* Header Section */}
      <div className="flex flex-col space-y-4">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
          <motion.div
            className="relative"
            variants={headingVariants}
            initial="initial"
            animate="animate"
          >
            <div className="flex items-center gap-3">
              <motion.div variants={iconVariants} className="relative">
                <div className="absolute inset-0 bg-gradient-to-r from-primary/20 to-primary/10 rounded-full blur-xl" />
                <Settings className="h-8 w-8 text-primary relative z-10" />
              </motion.div>
              <div className="relative">
                <h1 className="text-4xl font-display font-bold tracking-tight bg-clip-text text-transparent bg-gradient-to-r from-primary via-primary/80 to-primary animate-gradient-x">
                  Manage Properties
                </h1>
                <motion.div
                  variants={underlineVariants}
                  className="absolute -bottom-2 left-0 h-1 bg-gradient-to-r from-primary/50 via-primary to-primary/50 rounded-full"
                />
              </div>
            </div>
            <div className="absolute -top-4 -right-4 w-24 h-24 bg-primary/5 rounded-full blur-2xl" />
            <div className="absolute -bottom-4 -left-4 w-24 h-24 bg-primary/5 rounded-full blur-2xl" />
          </motion.div>
          <Dialog open={isAddTowerOpen} onOpenChange={setIsAddTowerOpen}>
            <DialogTrigger asChild>
              <Button className="relative group">
                <span className="absolute inset-0 w-0 bg-primary/10 group-hover:w-full transition-all duration-300 rounded-md" />
                <PlusCircle className="w-4 h-4 mr-2 relative" />
                <span className="relative">Add Tower</span>
              </Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Add New Tower</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 pt-4">
                <div className="space-y-2">
                  <Label htmlFor="towerName">Tower Name</Label>
                  <Input
                    id="towerName"
                    value={newTowerName}
                    onChange={(e) => setNewTowerName(e.target.value)}
                    placeholder="e.g. Tower A"
                  />
                </div>
                <Button
                  onClick={() => addTowerMutation.mutate(newTowerName)}
                  disabled={!newTowerName || addTowerMutation.isPending}
                  className="w-full relative group"
                >
                  <span className="absolute inset-0 w-0 bg-primary/10 group-hover:w-full transition-all duration-300 rounded-md" />
                  <span className="relative">
                    {addTowerMutation.isPending ? "Adding..." : "Add Tower"}
                  </span>
                </Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      <motion.div
        variants={containerVariants}
        initial="hidden"
        animate="show"
        className="grid grid-cols-1 md:grid-cols-12 gap-6"
      >
        <Card className="md:col-span-4 shadow-lg border-border/40 bg-gradient-to-br from-card to-card/50">
          <CardHeader className="border-b bg-muted/50 px-6">
            <CardTitle className="text-xl flex items-center gap-2">
              <Building2 className="h-5 w-5 text-primary" />
              Towers
            </CardTitle>
          </CardHeader>
          <CardContent className="p-4 sm:p-6">
            {isLoadingTowers ? (
              <div className="space-y-2">
                {[1, 2, 3].map((i) => (
                  <div
                    key={i}
                    className="h-14 bg-muted animate-pulse rounded-lg"
                  />
                ))}
              </div>
            ) : towers?.length ? (
              <div className="space-y-2">
                {towers.map((tower) => (
                  <motion.div
                    key={tower.id}
                    variants={itemVariants}
                    className={`group flex items-center justify-between p-4 rounded-lg border transition-all duration-200 ${
                      selectedTower?.id === tower.id
                        ? "bg-primary/10 border-primary"
                        : "hover:bg-muted/50"
                    }`}
                  >
                    <button
                      className="flex-1 text-left font-medium group-hover:text-primary transition-colors duration-200"
                      onClick={() => setSelectedTower(tower)}
                    >
                      {tower.name}
                    </button>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="text-destructive hover:text-destructive hover:bg-destructive/10 opacity-0 group-hover:opacity-100 transition-all duration-200"
                      onClick={(e) => {
                        e.stopPropagation();
                        if (
                          confirm(
                            `Are you sure you want to delete ${tower.name}? This will also delete all apartments in this tower.`
                          )
                        ) {
                          deleteTowerMutation.mutate(tower.id);
                        }
                      }}
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </motion.div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8 text-muted-foreground">
                <Building2 className="h-12 w-12 mx-auto mb-4 opacity-50" />
                <p className="font-medium mb-1">No towers found</p>
                <p className="text-sm">Add a tower to get started.</p>
              </div>
            )}
          </CardContent>
        </Card>

        <Card className="md:col-span-8 shadow-lg border-border/40 bg-gradient-to-br from-card to-card/50">
          <CardHeader className="border-b bg-muted/50 px-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
              <CardTitle className="text-xl flex items-center gap-2">
                <Home className="h-5 w-5 text-primary" />
                {selectedTower
                  ? `${selectedTower.name} Apartments`
                  : "Select a tower to view apartments"}
              </CardTitle>
              {selectedTower && (
                <Dialog
                  open={isAddApartmentOpen}
                  onOpenChange={setIsAddApartmentOpen}
                >
                  <DialogTrigger asChild>
                    <Button className="relative group">
                      <span className="absolute inset-0 w-0 bg-primary/10 group-hover:w-full transition-all duration-300 rounded-md" />
                      <PlusCircle className="w-4 h-4 mr-2 relative" />
                      <span className="relative">Add Apartment</span>
                    </Button>
                  </DialogTrigger>
                  <DialogContent className="sm:max-w-[500px]">
                    <DialogHeader>
                      <DialogTitle>Add New Apartment</DialogTitle>
                    </DialogHeader>
                    <div className="grid gap-6 pt-4">
                      <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                          <Label htmlFor="number">Apartment Number</Label>
                          <Input
                            id="number"
                            value={newApartment.number}
                            onChange={(e) =>
                              setNewApartment({
                                ...newApartment,
                                number: e.target.value,
                              })
                            }
                            placeholder="e.g. A-101"
                          />
                        </div>
                        <div className="space-y-2">
                          <Label htmlFor="type">Type</Label>
                          <Select
                            value={newApartment.type}
                            onValueChange={(value) =>
                              setNewApartment({ ...newApartment, type: value })
                            }
                          >
                            <SelectTrigger id="type">
                              <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="1BHK">1 BHK</SelectItem>
                              <SelectItem value="2BHK">2 BHK</SelectItem>
                              <SelectItem value="3BHK">3 BHK</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                      </div>
                      <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                          <Label htmlFor="floor">Floor</Label>
                          <Input
                            id="floor"
                            type="number"
                            value={newApartment.floor}
                            onChange={(e) =>
                              setNewApartment({
                                ...newApartment,
                                floor: parseInt(e.target.value),
                              })
                            }
                          />
                        </div>
                        <div className="space-y-2">
                          <Label htmlFor="status">Status</Label>
                          <Select
                            value={newApartment.status}
                            onValueChange={(value) =>
                              setNewApartment({
                                ...newApartment,
                                status: value,
                              })
                            }
                          >
                            <SelectTrigger>
                              <SelectValue placeholder="Select status" />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="OCCUPIED">Occupied</SelectItem>
                              <SelectItem value="AVAILABLE_RENT">
                                Available for Rent
                              </SelectItem>
                              <SelectItem value="AVAILABLE_SALE">
                                Available for Sale
                              </SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                      </div>
                      <Separator />
                      <div className="space-y-4">
                        <div className="space-y-2">
                          <Label htmlFor="monthlyRent">Monthly Rent (₹)</Label>
                          <Input
                            id="monthlyRent"
                            type="number"
                            value={newApartment.monthlyRent}
                            onChange={(e) =>
                              setNewApartment({
                                ...newApartment,
                                monthlyRent: e.target.value,
                              })
                            }
                            placeholder="Enter amount"
                          />
                        </div>
                        <div className="space-y-2">
                          <Label htmlFor="salePrice">Sale Price (₹)</Label>
                          <Input
                            id="salePrice"
                            type="number"
                            value={newApartment.salePrice}
                            onChange={(e) =>
                              setNewApartment({
                                ...newApartment,
                                salePrice: e.target.value,
                              })
                            }
                            placeholder="Enter amount"
                          />
                        </div>
                        <div className="space-y-2">
                          <Label htmlFor="contactNumber">Contact Number</Label>
                          <Input
                            id="contactNumber"
                            value={newApartment.contactNumber}
                            onChange={(e) =>
                              setNewApartment({
                                ...newApartment,
                                contactNumber: e.target.value,
                              })
                            }
                            placeholder="Enter contact number"
                          />
                        </div>
                      </div>
                      <Button
                        onClick={() =>
                          addApartmentMutation.mutate({
                            ...newApartment,
                            towerId: selectedTower.id,
                          })
                        }
                        disabled={
                          !newApartment.number || addApartmentMutation.isPending
                        }
                        className="w-full relative group"
                      >
                        <span className="absolute inset-0 w-0 bg-primary/10 group-hover:w-full transition-all duration-300 rounded-md" />
                        <span className="relative">
                          {addApartmentMutation.isPending
                            ? "Adding..."
                            : "Add Apartment"}
                        </span>
                      </Button>
                    </div>
                  </DialogContent>
                </Dialog>
              )}
            </div>
          </CardHeader>
          <CardContent className="p-4 sm:p-6">
            {!selectedTower ? (
              <div className="text-center py-12 text-muted-foreground">
                <Home className="h-12 w-12 mx-auto mb-4 opacity-50" />
                <p className="font-medium mb-1">Select a tower</p>
                <p className="text-sm">
                  Choose a tower to view and manage its apartments.
                </p>
              </div>
            ) : isLoadingApartments ? (
              <div className="space-y-4">
                {[1, 2, 3].map((i) => (
                  <div
                    key={i}
                    className="h-28 w-full animate-pulse bg-muted rounded-lg"
                  />
                ))}
              </div>
            ) : apartments && apartments.length > 0 ? (
              <ScrollArea className="h-[calc(100vh-300px)]">
                <div className="space-y-4">
                  {apartments.map((apartment) => (
                    <motion.div
                      key={apartment.id}
                      variants={itemVariants}
                      className="group flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 sm:p-6 border rounded-xl bg-card hover:shadow-md transition-all duration-200 gap-4 relative overflow-hidden"
                    >
                      <div className="absolute inset-0 bg-gradient-to-r from-primary/5 via-primary/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                      <div className="space-y-4 w-full sm:flex-1 relative">
                        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 sm:gap-4">
                          <div className="flex items-center gap-3">
                            <h3 className="font-semibold text-lg group-hover:text-primary transition-colors duration-200">
                              {selectedTower.name} - {apartment.number}
                            </h3>
                            <Badge
                              variant={
                                apartment.status === "OCCUPIED"
                                  ? "default"
                                  : apartment.status === "FOR_RENT"
                                  ? "secondary"
                                  : "outline"
                              }
                              className="w-fit"
                            >
                              {apartment.status.replace("_", " ")}
                            </Badge>
                          </div>
                          <Button
                            variant="ghost"
                            size="sm"
                            className="text-destructive hover:text-destructive hover:bg-destructive/10"
                            onClick={(e) => {
                              e.stopPropagation();
                              if (
                                confirm(
                                  "Are you sure you want to delete this apartment?"
                                )
                              ) {
                                deleteApartmentMutation.mutate(apartment.id);
                              }
                            }}
                          >
                            <Trash2 className="w-4 h-4 mr-2" />
                            Delete
                          </Button>
                        </div>
                        <div className="flex flex-col sm:flex-row gap-4 sm:gap-6 text-sm text-muted-foreground">
                          <div className="flex items-center gap-2">
                            <Home className="h-4 w-4 shrink-0" />
                            <span>
                              {apartment.type} • Floor {apartment.floor}
                            </span>
                          </div>
                          {apartment.monthlyRent && (
                            <div className="flex items-center gap-2">
                              <IndianRupee className="h-4 w-4 shrink-0" />
                              <span>₹{apartment.monthlyRent}/month</span>
                            </div>
                          )}
                          {apartment.salePrice && (
                            <div className="flex items-center gap-2">
                              <IndianRupee className="h-4 w-4 shrink-0" />
                              <span>₹{apartment.salePrice}</span>
                            </div>
                          )}
                          {apartment.contactNumber && (
                            <div className="flex items-center gap-2">
                              <Phone className="h-4 w-4 shrink-0" />
                              <span>{apartment.contactNumber}</span>
                            </div>
                          )}
                        </div>
                      </div>
                    </motion.div>
                  ))}
                </div>
              </ScrollArea>
            ) : (
              <div className="text-center py-12 text-muted-foreground">
                <Home className="h-12 w-12 mx-auto mb-4 opacity-50" />
                <p className="font-medium mb-1">No apartments found</p>
                <p className="text-sm">
                  Add apartments to {selectedTower.name}.
                </p>
              </div>
            )}
          </CardContent>
        </Card>
      </motion.div>
    </div>
  );
}
