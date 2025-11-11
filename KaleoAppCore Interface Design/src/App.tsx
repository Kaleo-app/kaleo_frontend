import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { HomeScreen } from './components/HomeScreen';
import { OpportunityDetailScreen } from './components/OpportunityDetailScreen';
import { ResultsScreen } from './components/ResultsScreen';
import { AboutScreen } from './components/AboutScreen';
import { BottomNavigation } from './components/BottomNavigation';
import { mockOpportunities } from './data/mockOpportunities';
import { fetchOpportunitiesPaged, BackendOpportunityItem } from './api/client';
import { Opportunity } from './types/opportunity';

export default function App() {
  const [activeTab, setActiveTab] = useState<'home' | 'results' | 'about'>('home');
  const [selectedOpportunity, setSelectedOpportunity] = useState<Opportunity | null>(null);
  const [categoryFilter, setCategoryFilter] = useState<string | undefined>(undefined);
  const [opportunities, setOpportunities] = useState<Opportunity[]>(mockOpportunities);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      setError(null);
      try {
        const data = await fetchOpportunitiesPaged({ page: 1, page_size: 20 });
        const mapped: Opportunity[] = data.items.map(mapBackendToOpportunity);
        // Si la API está vacía, mantenemos los mocks para no romper el diseño
        setOpportunities(mapped.length ? mapped : mockOpportunities);
      } catch (e: any) {
        setError(e?.message ?? 'Error cargando datos');
        setOpportunities(mockOpportunities);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  function mapBackendToOpportunity(item: BackendOpportunityItem): Opportunity {
    const firstLoc = item.locations?.[0];
    return {
      id: String(item.id),
      title: item.title ?? 'Oportunidad',
      organization: 'Organización',
      category: (item.category as any) || 'Becas',
      deadline: item.deadline || new Date().toISOString().slice(0, 10),
      modality: 'Presencial',
      country: firstLoc?.city || firstLoc?.region || '—',
      description: '',
      benefits: [],
      requirements: [],
      howToApply: [],
      sourceUrl: '#',
      featured: true,
    };
  }

  const handleOpportunityClick = (opportunity: Opportunity) => {
    setSelectedOpportunity(opportunity);
  };

  const handleBackToList = () => {
    setSelectedOpportunity(null);
  };

  const handleCategoryClick = (category: string) => {
    setCategoryFilter(category);
    setActiveTab('results');
  };

  const handleTabChange = (tab: 'home' | 'results' | 'about') => {
    setActiveTab(tab);
    setSelectedOpportunity(null);
    if (tab !== 'results') {
      setCategoryFilter(undefined);
    }
  };

  const pageVariants = {
    initial: { opacity: 0, y: 20 },
    animate: { opacity: 1, y: 0 },
    exit: { opacity: 0, y: -20 },
  };

  const transition = {
    duration: 0.3,
    ease: 'easeInOut',
  };

  return (
    <div className="min-h-screen bg-background">
      <div className="max-w-3xl mx-auto px-4 pt-6 pb-24">
        <AnimatePresence mode="wait">
          {selectedOpportunity ? (
            <motion.div
              key="detail"
              variants={pageVariants}
              initial="initial"
              animate="animate"
              exit="exit"
              transition={transition}
            >
              <OpportunityDetailScreen
                opportunity={selectedOpportunity}
                onBack={handleBackToList}
              />
            </motion.div>
          ) : (
            <motion.div
              key={activeTab}
              variants={pageVariants}
              initial="initial"
              animate="animate"
              exit="exit"
              transition={transition}
            >
              {activeTab === 'home' && (
                <HomeScreen
                  opportunities={opportunities}
                  onOpportunityClick={handleOpportunityClick}
                  onCategoryClick={handleCategoryClick}
                />
              )}
              {activeTab === 'results' && (
                <ResultsScreen
                  opportunities={opportunities}
                  onOpportunityClick={handleOpportunityClick}
                  initialCategory={categoryFilter}
                />
              )}
              {activeTab === 'about' && <AboutScreen />}
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      <BottomNavigation activeTab={activeTab} onTabChange={handleTabChange} />
    </div>
  );
}
