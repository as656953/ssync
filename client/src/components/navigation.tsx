import { useAuth } from "@/hooks/use-auth";
import { Link } from "wouter";
import { Button } from "@/components/ui/button";
import {
  Building2,
  Home,
  CalendarDays,
  LogOut,
  Menu,
} from "lucide-react";
import {
  Sheet,
  SheetContent,
  SheetTrigger,
} from "@/components/ui/sheet";
import { useToast } from "@/hooks/use-toast";
import { useState } from "react";

export default function Navigation() {
  const { user, logoutMutation } = useAuth();
  const { toast } = useToast();
  const [open, setOpen] = useState(false);

  if (!user) return null;

  const handleLogout = () => {
    logoutMutation.mutate(undefined, {
      onSuccess: () => {
        toast({
          title: "Logged out successfully",
        });
      },
    });
  };

  const NavLinks = () => (
    <>
      <Link href="/">
        <Button variant="ghost" className="w-full justify-start">
          <Home className="mr-2 h-4 w-4" />
          Dashboard
        </Button>
      </Link>
      <Link href="/apartments">
        <Button variant="ghost" className="w-full justify-start">
          <Building2 className="mr-2 h-4 w-4" />
          Apartments
        </Button>
      </Link>
      <Link href="/amenities">
        <Button variant="ghost" className="w-full justify-start">
          <CalendarDays className="mr-2 h-4 w-4" />
          Amenities
        </Button>
      </Link>
      <Button
        variant="ghost"
        className="w-full justify-start text-red-500 hover:text-red-600 hover:bg-red-50"
        onClick={handleLogout}
      >
        <LogOut className="mr-2 h-4 w-4" />
        Logout
      </Button>
    </>
  );

  return (
    <>
      {/* Desktop Navigation */}
      <div className="hidden md:flex flex-col fixed left-0 top-0 h-screen w-64 bg-sidebar p-4 border-r">
        <div className="flex items-center gap-2 mb-8">
          <Building2 className="h-6 w-6" />
          <h1 className="font-bold text-lg">Society Management</h1>
        </div>
        <div className="flex flex-col gap-2">
          <NavLinks />
        </div>
      </div>

      {/* Mobile Navigation */}
      <div className="md:hidden fixed top-0 left-0 right-0 h-16 bg-background border-b px-4 flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Building2 className="h-6 w-6" />
          <h1 className="font-bold">Society Management</h1>
        </div>
        <Sheet open={open} onOpenChange={setOpen}>
          <SheetTrigger asChild>
            <Button variant="ghost" size="icon">
              <Menu className="h-5 w-5" />
            </Button>
          </SheetTrigger>
          <SheetContent>
            <div className="flex flex-col gap-2 mt-8">
              <NavLinks />
            </div>
          </SheetContent>
        </Sheet>
      </div>

      {/* Content Padding */}
      <div className="md:pl-64 pt-16 md:pt-0" />
    </>
  );
}
