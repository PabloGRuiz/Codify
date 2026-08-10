import { Bell, Flame, User } from "lucide-react";

export function Topbar() {
  return (
    <header className="h-20 w-full glass border-b border-border flex items-center justify-between px-8 z-40 sticky top-0">
      <div className="flex-1">
        {/* Breadcrumbs or Page Title could go here */}
      </div>

      <div className="flex items-center gap-6">
        <div className="flex items-center gap-2 px-3 py-1.5 rounded-full bg-orange-500/10 border border-orange-500/20 text-orange-400">
          <Flame size={16} className="fill-orange-400" />
          <span className="text-sm font-bold">12 Días</span>
        </div>

        <button className="relative p-2 text-zinc-400 hover:text-white transition-colors">
          <Bell size={20} />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-primary animate-pulse"></span>
        </button>

        <div className="w-10 h-10 rounded-full bg-gradient-to-tr from-accent to-primary p-[2px] cursor-pointer">
          <div className="w-full h-full rounded-full bg-secondary flex items-center justify-center">
            <User size={18} className="text-zinc-300" />
          </div>
        </div>
      </div>
    </header>
  );
}
