import { useState } from 'react';
import { Input } from './ui/input';
import { Search, Sparkles } from 'lucide-react';
import { OpportunityCard } from './OpportunityCard';
import { CategoryCard } from './CategoryCard';
import { CircularLogo } from './CircularLogo';
import { Opportunity, CATEGORIES } from '../types/opportunity';
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from './ui/pagination';

interface HomeScreenProps {
  opportunities: Opportunity[];
  onOpportunityClick: (opportunity: Opportunity) => void;
  onCategoryClick: (category: string) => void;
}

export function HomeScreen({ opportunities, onOpportunityClick, onCategoryClick }: HomeScreenProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 4;

  const featuredOpportunities = opportunities.filter(opp => opp.featured);

  const filteredOpportunities = searchQuery
    ? featuredOpportunities.filter(
        opp =>
          opp.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
          opp.organization.toLowerCase().includes(searchQuery.toLowerCase()) ||
          opp.category.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : featuredOpportunities;

  // Calcular paginación
  const totalPages = Math.ceil(filteredOpportunities.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const paginatedOpportunities = filteredOpportunities.slice(startIndex, endIndex);

  // Reiniciar a la página 1 cuando cambia la búsqueda
  const handleSearchChange = (value: string) => {
    setSearchQuery(value);
    setCurrentPage(1);
  };

  return (
    <div className="flex flex-col gap-6 pb-6">
      {/* Header */}
      <div className="bg-gradient-to-r from-primary to-accent p-6 rounded-xl">
        <div className="flex items-center gap-3 mb-2">
          <CircularLogo 
            size={50} 
            backgroundColor="white" 
            borderColor="white" 
            borderWidth={2} 
          />
          <h1 className="text-white">KaleoAppCore</h1>
        </div>
        <p className="text-white/90">Explora nuevas oportunidades</p>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
        <Input
          type="text"
          placeholder="Buscar convocatorias..."
          className="pl-10 bg-card border-border"
          value={searchQuery}
          onChange={(e) => handleSearchChange(e.target.value)}
        />
      </div>

      {/* Categories */}
      <div>
        <h2 className="mb-4">Categorías populares</h2>
        <div className="grid grid-cols-2 gap-3">
          {CATEGORIES.map((category) => (
            <CategoryCard
              key={category.id}
              name={category.name}
              icon={category.icon}
              color={category.color}
              onClick={() => onCategoryClick(category.name)}
            />
          ))}
        </div>
      </div>

      {/* Featured Opportunities */}
      <div>
        <h2 className="mb-4">Convocatorias destacadas</h2>
        <div className="flex flex-col gap-3">
          {paginatedOpportunities.length > 0 ? (
            paginatedOpportunities.map((opportunity) => (
              <OpportunityCard
                key={opportunity.id}
                opportunity={opportunity}
                onClick={() => onOpportunityClick(opportunity)}
              />
            ))
          ) : (
            <div className="text-center py-8 text-muted-foreground">
              <p>No se encontraron convocatorias</p>
            </div>
          )}
        </div>

        {/* Paginación */}
        {totalPages > 1 && (
          <div className="mt-6">
            <Pagination>
              <PaginationContent>
                <PaginationItem>
                  <PaginationPrevious
                    onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                    className={currentPage === 1 ? 'pointer-events-none opacity-50' : 'cursor-pointer'}
                  />
                </PaginationItem>
                
                {Array.from({ length: totalPages }, (_, i) => i + 1).map((page) => {
                  // Mostrar solo algunas páginas para evitar que sea muy largo
                  const showPage = 
                    page === 1 || 
                    page === totalPages || 
                    (page >= currentPage - 1 && page <= currentPage + 1);
                  
                  const showEllipsisBefore = page === currentPage - 2 && currentPage > 3;
                  const showEllipsisAfter = page === currentPage + 2 && currentPage < totalPages - 2;

                  if (showEllipsisBefore) {
                    return (
                      <PaginationItem key={`ellipsis-before-${page}`}>
                        <PaginationEllipsis />
                      </PaginationItem>
                    );
                  }

                  if (showEllipsisAfter) {
                    return (
                      <PaginationItem key={`ellipsis-after-${page}`}>
                        <PaginationEllipsis />
                      </PaginationItem>
                    );
                  }

                  if (!showPage) return null;

                  return (
                    <PaginationItem key={page}>
                      <PaginationLink
                        onClick={() => setCurrentPage(page)}
                        isActive={currentPage === page}
                        className="cursor-pointer"
                      >
                        {page}
                      </PaginationLink>
                    </PaginationItem>
                  );
                })}

                <PaginationItem>
                  <PaginationNext
                    onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
                    className={currentPage === totalPages ? 'pointer-events-none opacity-50' : 'cursor-pointer'}
                  />
                </PaginationItem>
              </PaginationContent>
            </Pagination>
          </div>
        )}
      </div>
    </div>
  );
}
