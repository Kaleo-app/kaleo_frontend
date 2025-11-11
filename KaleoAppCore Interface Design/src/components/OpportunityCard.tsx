import { Opportunity } from '../types/opportunity';
import { Card } from './ui/card';
import { Badge } from './ui/badge';
import { Calendar, MapPin, Monitor } from 'lucide-react';

interface OpportunityCardProps {
  opportunity: Opportunity;
  onClick: () => void;
}

const categoryColors = {
  Becas: 'bg-blue-100 text-blue-700 border-blue-200',
  Empleo: 'bg-green-100 text-green-700 border-green-200',
  Investigación: 'bg-purple-100 text-purple-700 border-purple-200',
  Voluntariado: 'bg-rose-100 text-rose-700 border-rose-200',
};

export function OpportunityCard({ opportunity, onClick }: OpportunityCardProps) {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', { day: 'numeric', month: 'short', year: 'numeric' });
  };

  return (
    <Card
      className="p-5 hover:shadow-lg transition-all duration-300 cursor-pointer border border-border bg-card"
      onClick={onClick}
    >
      <div className="flex flex-col gap-3">
        <div className="flex items-start justify-between gap-3">
          <div className="flex-1">
            <h3 className="mb-2">{opportunity.title}</h3>
            <p className="text-muted-foreground text-sm mb-2">{opportunity.organization}</p>
          </div>
          <Badge className={categoryColors[opportunity.category]} variant="outline">
            {opportunity.category}
          </Badge>
        </div>

        <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
          <div className="flex items-center gap-1.5">
            <Calendar className="w-4 h-4" />
            <span>{formatDate(opportunity.deadline)}</span>
          </div>
          <div className="flex items-center gap-1.5">
            <MapPin className="w-4 h-4" />
            <span>{opportunity.country}</span>
          </div>
          <div className="flex items-center gap-1.5">
            <Monitor className="w-4 h-4" />
            <span>{opportunity.modality}</span>
          </div>
        </div>
      </div>
    </Card>
  );
}
