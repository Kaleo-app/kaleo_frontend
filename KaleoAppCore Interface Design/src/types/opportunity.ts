export interface Opportunity {
  id: string;
  title: string;
  organization: string;
  organizationLogo?: string;
  category: 'Becas' | 'Empleo' | 'Investigación' | 'Voluntariado';
  deadline: string;
  modality: 'Virtual' | 'Presencial' | 'Híbrida';
  country: string;
  description: string;
  benefits: string[];
  requirements: string[];
  howToApply: string[];
  sourceUrl: string;
  featured?: boolean;
}

export const CATEGORIES = [
  { id: 'becas', name: 'Becas', icon: 'GraduationCap', color: 'bg-blue-500' },
  { id: 'empleo', name: 'Empleo', icon: 'Briefcase', color: 'bg-green-500' },
  { id: 'investigacion', name: 'Investigación', icon: 'FlaskConical', color: 'bg-purple-500' },
  { id: 'voluntariado', name: 'Voluntariado', icon: 'Heart', color: 'bg-rose-500' },
] as const;
