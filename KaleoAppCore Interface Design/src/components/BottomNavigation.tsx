import { Home, Search, Info } from 'lucide-react';

interface BottomNavigationProps {
  activeTab: 'home' | 'results' | 'about';
  onTabChange: (tab: 'home' | 'results' | 'about') => void;
}

export function BottomNavigation({ activeTab, onTabChange }: BottomNavigationProps) {
  const tabs = [
    { id: 'home' as const, label: 'Inicio', icon: Home },
    { id: 'results' as const, label: 'Resultados', icon: Search },
    { id: 'about' as const, label: 'Acerca de', icon: Info },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-card border-t border-border z-50">
      <div className="max-w-3xl mx-auto px-4">
        <div className="grid grid-cols-3 gap-2 py-2">
          {tabs.map((tab) => {
            const Icon = tab.icon;
            const isActive = activeTab === tab.id;
            
            return (
              <button
                key={tab.id}
                onClick={() => onTabChange(tab.id)}
                className={`flex flex-col items-center gap-1 py-2 px-3 rounded-lg transition-all ${
                  isActive
                    ? 'bg-primary text-primary-foreground'
                    : 'text-muted-foreground hover:bg-muted'
                }`}
              >
                <Icon className={`w-5 h-5 ${isActive ? 'scale-110' : ''} transition-transform`} />
                <span className="text-xs">{tab.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
