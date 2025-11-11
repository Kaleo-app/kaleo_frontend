import { useState } from 'react';
import { Opportunity } from '../types/opportunity';
import { OpportunityCard } from './OpportunityCard';
import { Input } from './ui/input';
import { Button } from './ui/button';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from './ui/select';
import { Search, Filter, X } from 'lucide-react';
import { Badge } from './ui/badge';

interface ResultsScreenProps {
  opportunities: Opportunity[];
  onOpportunityClick: (opportunity: Opportunity) => void;
  initialCategory?: string;
}

export function ResultsScreen({ opportunities, onOpportunityClick, initialCategory }: ResultsScreenProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [categoryFilter, setCategoryFilter] = useState<string>(initialCategory || 'all');
  const [countryFilter, setCountryFilter] = useState<string>('all');
  const [modalityFilter, setModalityFilter] = useState<string>('all');
  const [showFilters, setShowFilters] = useState(false);

  // Get unique values for filters
  const countries = Array.from(new Set(opportunities.map(opp => opp.country))).sort();
  const modalities = Array.from(new Set(opportunities.map(opp => opp.modality))).sort();

  // Apply filters
  const filteredOpportunities = opportunities.filter(opp => {
    const matchesSearch = searchQuery
      ? opp.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        opp.organization.toLowerCase().includes(searchQuery.toLowerCase()) ||
        opp.description.toLowerCase().includes(searchQuery.toLowerCase())
      : true;

    const matchesCategory = categoryFilter === 'all' || opp.category === categoryFilter;
    const matchesCountry = countryFilter === 'all' || opp.country === countryFilter;
    const matchesModality = modalityFilter === 'all' || opp.modality === modalityFilter;

    return matchesSearch && matchesCategory && matchesCountry && matchesModality;
  });

  const activeFiltersCount = [categoryFilter, countryFilter, modalityFilter].filter(f => f !== 'all').length;

  const clearFilters = () => {
    setCategoryFilter('all');
    setCountryFilter('all');
    setModalityFilter('all');
    setSearchQuery('');
  };

  return (
    <div className="flex flex-col gap-6 pb-6">
      {/* Header */}
      <div>
        <h1 className="mb-2">Explorar convocatorias</h1>
        <p className="text-muted-foreground">
          {filteredOpportunities.length} convocatorias disponibles
        </p>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
        <Input
          type="text"
          placeholder="Buscar por título, organización o descripción..."
          className="pl-10 bg-card border-border"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
        />
      </div>

      {/* Filter Toggle */}
      <div className="flex items-center gap-3">
        <Button
          variant="outline"
          onClick={() => setShowFilters(!showFilters)}
          className="flex-1"
        >
          <Filter className="w-4 h-4 mr-2" />
          Filtros
          {activeFiltersCount > 0 && (
            <Badge className="ml-2 bg-primary text-primary-foreground" variant="secondary">
              {activeFiltersCount}
            </Badge>
          )}
        </Button>
        {activeFiltersCount > 0 && (
          <Button variant="ghost" size="icon" onClick={clearFilters}>
            <X className="w-4 h-4" />
          </Button>
        )}
      </div>

      {/* Filters */}
      {showFilters && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-3 p-4 bg-muted/30 rounded-lg border border-border">
          <div>
            <label className="text-sm text-muted-foreground mb-2 block">Categoría</label>
            <Select value={categoryFilter} onValueChange={setCategoryFilter}>
              <SelectTrigger className="bg-card">
                <SelectValue placeholder="Todas las categorías" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Todas las categorías</SelectItem>
                <SelectItem value="Becas">Becas</SelectItem>
                <SelectItem value="Empleo">Empleo</SelectItem>
                <SelectItem value="Investigación">Investigación</SelectItem>
                <SelectItem value="Voluntariado">Voluntariado</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div>
            <label className="text-sm text-muted-foreground mb-2 block">País</label>
            <Select value={countryFilter} onValueChange={setCountryFilter}>
              <SelectTrigger className="bg-card">
                <SelectValue placeholder="Todos los países" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Todos los países</SelectItem>
                {countries.map(country => (
                  <SelectItem key={country} value={country}>
                    {country}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          <div>
            <label className="text-sm text-muted-foreground mb-2 block">Modalidad</label>
            <Select value={modalityFilter} onValueChange={setModalityFilter}>
              <SelectTrigger className="bg-card">
                <SelectValue placeholder="Todas las modalidades" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">Todas las modalidades</SelectItem>
                {modalities.map(modality => (
                  <SelectItem key={modality} value={modality}>
                    {modality}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>
        </div>
      )}

      {/* Results */}
      <div className="flex flex-col gap-3">
        {filteredOpportunities.length > 0 ? (
          filteredOpportunities.map((opportunity) => (
            <OpportunityCard
              key={opportunity.id}
              opportunity={opportunity}
              onClick={() => onOpportunityClick(opportunity)}
            />
          ))
        ) : (
          <div className="text-center py-12">
            <p className="text-muted-foreground mb-2">No se encontraron convocatorias</p>
            <Button variant="outline" onClick={clearFilters}>
              Limpiar filtros
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
