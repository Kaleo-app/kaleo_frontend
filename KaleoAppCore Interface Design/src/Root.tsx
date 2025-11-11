import { useEffect, useState } from 'react';
import App from './App';
import { Onboarding } from './components/Onboarding';

export default function Root() {
  const [showOnboarding, setShowOnboarding] = useState<boolean>(true);
  const [loaded, setLoaded] = useState<boolean>(false);

  // Siempre mostrar onboarding en el arranque
  useEffect(() => {
    setShowOnboarding(true);
    setLoaded(true);
  }, []);

  const handleComplete = () => {
    setShowOnboarding(false);
  };

  if (!loaded) return null;

  return showOnboarding ? <Onboarding onComplete={handleComplete} /> : <App />;
}


