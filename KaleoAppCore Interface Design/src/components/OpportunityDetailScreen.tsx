import { Opportunity } from '../types/opportunity';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { Card } from './ui/card';
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger,
} from './ui/collapsible';
import {
  ArrowLeft,
  ExternalLink,
  Calendar,
  MapPin,
  Monitor,
  Building2,
  ChevronDown,
  Gift,
  ClipboardCheck,
  FileText,
} from 'lucide-react';
import { useState } from 'react';

interface OpportunityDetailScreenProps {
  opportunity: Opportunity;
  onBack: () => void;
}

const categoryColors = {
  Becas: 'bg-blue-100 text-blue-700 border-blue-200',
  Empleo: 'bg-green-100 text-green-700 border-green-200',
  Investigación: 'bg-purple-100 text-purple-700 border-purple-200',
  Voluntariado: 'bg-rose-100 text-rose-700 border-rose-200',
};

export function OpportunityDetailScreen({ opportunity, onBack }: OpportunityDetailScreenProps) {
  const [benefitsOpen, setBenefitsOpen] = useState(true);
  const [requirementsOpen, setRequirementsOpen] = useState(true);
  const [applyOpen, setApplyOpen] = useState(true);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', { day: 'numeric', month: 'long', year: 'numeric' });
  };

  return (
    <div className="flex flex-col gap-6 pb-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={onBack} className="shrink-0">
          <ArrowLeft className="w-5 h-5" />
        </Button>
        <h2>Detalles de la convocatoria</h2>
      </div>

      {/* Organization Header */}
      <Card className="p-6 bg-gradient-to-br from-primary/5 to-accent/5 border-border">
        <div className="flex items-start gap-4 mb-4">
          <div className="w-16 h-16 bg-white rounded-lg flex items-center justify-center border border-border shrink-0">
            <Building2 className="w-8 h-8 text-primary" />
          </div>
          <div className="flex-1">
            <p className="text-sm text-muted-foreground mb-1">{opportunity.organization}</p>
            <h1 className="mb-2">{opportunity.title}</h1>
            <Badge className={categoryColors[opportunity.category]} variant="outline">
              {opportunity.category}
            </Badge>
          </div>
        </div>
      </Card>

      {/* Basic Info */}
      <Card className="p-5 border-border">
        <h3 className="mb-4">Información básica</h3>
        <div className="grid grid-cols-2 gap-4">
          <div className="flex items-start gap-3">
            <Calendar className="w-5 h-5 text-primary shrink-0 mt-0.5" />
            <div>
              <p className="text-sm text-muted-foreground">Fecha límite</p>
              <p className="text-sm">{formatDate(opportunity.deadline)}</p>
            </div>
          </div>
          <div className="flex items-start gap-3">
            <MapPin className="w-5 h-5 text-primary shrink-0 mt-0.5" />
            <div>
              <p className="text-sm text-muted-foreground">País</p>
              <p className="text-sm">{opportunity.country}</p>
            </div>
          </div>
          <div className="flex items-start gap-3">
            <Monitor className="w-5 h-5 text-primary shrink-0 mt-0.5" />
            <div>
              <p className="text-sm text-muted-foreground">Modalidad</p>
              <p className="text-sm">{opportunity.modality}</p>
            </div>
          </div>
          <div className="flex items-start gap-3">
            <Building2 className="w-5 h-5 text-primary shrink-0 mt-0.5" />
            <div>
              <p className="text-sm text-muted-foreground">Categoría</p>
              <p className="text-sm">{opportunity.category}</p>
            </div>
          </div>
        </div>
      </Card>

      {/* Description */}
      <Card className="p-5 border-border">
        <h3 className="mb-3">Descripción</h3>
        <p className="text-muted-foreground">{opportunity.description}</p>
      </Card>

      {/* Benefits */}
      <Collapsible open={benefitsOpen} onOpenChange={setBenefitsOpen}>
        <Card className="border-border overflow-hidden">
          <CollapsibleTrigger className="w-full p-5 flex items-center justify-between hover:bg-muted/50 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                <Gift className="w-5 h-5 text-green-600" />
              </div>
              <h3>Beneficios</h3>
            </div>
            <ChevronDown
              className={`w-5 h-5 text-muted-foreground transition-transform ${
                benefitsOpen ? 'rotate-180' : ''
              }`}
            />
          </CollapsibleTrigger>
          <CollapsibleContent>
            <div className="px-5 pb-5">
              <ul className="space-y-2">
                {opportunity.benefits.map((benefit, index) => (
                  <li key={index} className="flex items-start gap-2">
                    <span className="w-1.5 h-1.5 bg-accent rounded-full mt-2 shrink-0" />
                    <span className="text-sm text-muted-foreground">{benefit}</span>
                  </li>
                ))}
              </ul>
            </div>
          </CollapsibleContent>
        </Card>
      </Collapsible>

      {/* Requirements */}
      <Collapsible open={requirementsOpen} onOpenChange={setRequirementsOpen}>
        <Card className="border-border overflow-hidden">
          <CollapsibleTrigger className="w-full p-5 flex items-center justify-between hover:bg-muted/50 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <ClipboardCheck className="w-5 h-5 text-blue-600" />
              </div>
              <h3>Requisitos</h3>
            </div>
            <ChevronDown
              className={`w-5 h-5 text-muted-foreground transition-transform ${
                requirementsOpen ? 'rotate-180' : ''
              }`}
            />
          </CollapsibleTrigger>
          <CollapsibleContent>
            <div className="px-5 pb-5">
              <ul className="space-y-2">
                {opportunity.requirements.map((requirement, index) => (
                  <li key={index} className="flex items-start gap-2">
                    <span className="w-1.5 h-1.5 bg-primary rounded-full mt-2 shrink-0" />
                    <span className="text-sm text-muted-foreground">{requirement}</span>
                  </li>
                ))}
              </ul>
            </div>
          </CollapsibleContent>
        </Card>
      </Collapsible>

      {/* How to Apply */}
      <Collapsible open={applyOpen} onOpenChange={setApplyOpen}>
        <Card className="border-border overflow-hidden">
          <CollapsibleTrigger className="w-full p-5 flex items-center justify-between hover:bg-muted/50 transition-colors">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                <FileText className="w-5 h-5 text-purple-600" />
              </div>
              <h3>Cómo aplicar</h3>
            </div>
            <ChevronDown
              className={`w-5 h-5 text-muted-foreground transition-transform ${
                applyOpen ? 'rotate-180' : ''
              }`}
            />
          </CollapsibleTrigger>
          <CollapsibleContent>
            <div className="px-5 pb-5">
              <ol className="space-y-3">
                {opportunity.howToApply.map((step, index) => (
                  <li key={index} className="flex items-start gap-3">
                    <div className="w-6 h-6 bg-primary text-primary-foreground rounded-full flex items-center justify-center shrink-0 text-sm">
                      {index + 1}
                    </div>
                    <span className="text-sm text-muted-foreground pt-0.5">{step}</span>
                  </li>
                ))}
              </ol>
            </div>
          </CollapsibleContent>
        </Card>
      </Collapsible>

      {/* CTA Button */}
      <Button
        className="w-full bg-accent hover:bg-accent/90 text-accent-foreground"
        size="lg"
        onClick={() => window.open(opportunity.sourceUrl, '_blank')}
      >
        <ExternalLink className="w-5 h-5 mr-2" />
        Ir a fuente oficial
      </Button>
    </div>
  );
}
