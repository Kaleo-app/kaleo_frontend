import { Card } from './ui/card';
import { GraduationCap, Briefcase, FlaskConical, Heart } from 'lucide-react';

interface CategoryCardProps {
  name: string;
  icon: string;
  color: string;
  onClick: () => void;
}

const iconMap = {
  GraduationCap,
  Briefcase,
  FlaskConical,
  Heart,
};

export function CategoryCard({ name, icon, color, onClick }: CategoryCardProps) {
  const IconComponent = iconMap[icon as keyof typeof iconMap];

  return (
    <Card
      className="p-4 hover:shadow-md transition-all duration-300 cursor-pointer border border-border bg-card"
      onClick={onClick}
    >
      <div className="flex items-center gap-3">
        <div className={`${color} w-10 h-10 rounded-lg flex items-center justify-center`}>
          <IconComponent className="w-5 h-5 text-white" />
        </div>
        <h4>{name}</h4>
      </div>
    </Card>
  );
}
