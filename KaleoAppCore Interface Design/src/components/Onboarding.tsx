import { useState } from 'react';
import type React from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Sparkles, Filter, Bookmark } from 'lucide-react';

interface OnboardingProps {
  onComplete: () => void;
}

type Slide = {
  title: string;
  description: string;
  Icon: React.ComponentType<{ className?: string }>;
  accent: string; // tailwind color for accent ring/bg
  bg: string; // tailwind gradient classes for background (kept for compatibility)
  from: string; // hex/rgb for gradient start (fallback)
  to: string; // hex/rgb for gradient end (fallback)
};

const SLIDES: Slide[] = [
  {
    title: 'Bienvenida a Kaleo',
    description:
      'Explora oportunidades y encuentra convocatorias relevantes para ti en un solo lugar.',
    Icon: Sparkles,
    accent: 'from-purple-600 to-blue-600',
    bg: 'from-purple-600 to-blue-600',
    from: '#7c3aed',
    to: '#2563eb',
  },
  {
    title: 'Filtra y descubre',
    description:
      'Usa categorías y filtros para ver resultados ajustados a tus intereses.',
    Icon: Filter,
    accent: 'from-blue-600 to-green-600',
    bg: 'from-blue-600 to-green-600',
    from: '#2563eb',
    to: '#16a34a',
  },
  {
    title: 'Guarda y comparte',
    description:
      'Mantén a mano tus oportunidades favoritas y compártelas fácilmente.',
    Icon: Bookmark,
    accent: 'from-rose-700 to-purple-600',
    bg: 'from-rose-700 to-purple-600',
    from: '#be123c',
    to: '#7c3aed',
  },
];

export function Onboarding({ onComplete }: OnboardingProps) {
  const [index, setIndex] = useState(0);

  const isLast = index === SLIDES.length - 1;

  const handleNext = () => {
    if (isLast) {
      onComplete();
      return;
    }
    setIndex((i) => Math.min(i + 1, SLIDES.length - 1));
  };

  const handleSkip = () => {
    onComplete();
  };

  const slide = SLIDES[index];

  return (
    <div
      className={`relative min-h-screen overflow-hidden bg-gradient-to-b ${slide.bg}`}
      style={{ backgroundImage: `linear-gradient(180deg, ${slide.from}, ${slide.to})` }}
    >
      <div className="relative z-10 flex min-h-screen flex-col items-center text-white">
        <div className="flex-1 w-full max-w-5xl px-6 flex items-center justify-center">
          <AnimatePresence mode="wait">
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -16 }}
              transition={{ duration: 0.35 }}
              className="w-full"
            >
              <div className="mx-auto max-w-3xl rounded-3xl bg-white/10 backdrop-blur p-14 shadow-2xl ring-1 ring-white/15">
                <div className={`mx-auto mb-10 flex h-32 w-32 items-center justify-center rounded-full bg-white/15 shadow-2xl`}
                >
                  <slide.Icon className="h-16 w-16 text-white" />
                </div>
                <h1 className="text-5xl md:text-6xl font-bold text-center tracking-tight mb-6">
                  {slide.title}
                </h1>
                <p className="mx-auto max-w-2xl text-center text-white/95 text-2xl leading-relaxed">
                  {slide.description}
                </p>
              </div>
            </motion.div>
          </AnimatePresence>
        </div>

        <div className="w-full max-w-5xl px-6 pb-24 md:pb-28">
          {/* Indicadores centrados */}
          <div className="flex items-center justify-center mb-6">
            <div className="flex items-center gap-2">
              {SLIDES.map((_, i) => (
                <span
                  key={i}
                  className={`h-2 rounded-full transition-all ${
                    i === index ? 'w-10 bg-white' : 'w-2 bg-white/60'
                  }`}
                />
              ))}
            </div>
          </div>

          {/* Botones a los extremos (izq/der) con tamaños grandes */}
          <div className="flex items-center justify-between">
            <button
              className="inline-flex min-w-[12rem] items-center justify-center rounded-full border border-white/80 bg-white/10 px-10 md:px-14 py-3.5 md:py-5 text-xl md:text-2xl font-semibold text-white backdrop-blur-sm transition-transform hover:translate-y-[-2px] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/60"
              onClick={handleSkip}
              aria-label="Saltar"
            >
              Saltar
            </button>

            <button
              className="inline-flex min-w-[14rem] items-center justify-center rounded-full px-12 md:px-16 py-4 md:py-6 text-2xl md:text-3xl font-semibold text-white shadow-xl shadow-black/20 transition-transform hover:translate-y-[-2px] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-white/60"
              style={{ backgroundImage: `linear-gradient(90deg, ${slide.from}, ${slide.to})` }}
              onClick={handleNext}
            >
              {isLast ? 'Empezar' : 'Siguiente'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}


