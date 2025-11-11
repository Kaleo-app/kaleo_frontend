import { Opportunity } from '../types/opportunity';

export const mockOpportunities: Opportunity[] = [
  {
    id: '1',
    title: 'Beca Fulbright para Estudios de Posgrado en EE.UU.',
    organization: 'Programa Fulbright',
    category: 'Becas',
    deadline: '2025-12-15',
    modality: 'Presencial',
    country: 'Estados Unidos',
    description: 'Programa de becas para estudios de maestría y doctorado en universidades estadounidenses.',
    benefits: [
      'Cobertura total de matrícula universitaria',
      'Estipendio mensual para gastos de subsistencia',
      'Seguro médico completo',
      'Pasajes aéreos ida y vuelta',
      'Apoyo para adaptación cultural'
    ],
    requirements: [
      'Título universitario con promedio mínimo de 8.5',
      'Nivel avanzado de inglés (TOEFL mínimo 90)',
      'Carta de motivación de 2 páginas',
      'Dos cartas de recomendación académicas',
      'Ciudadanía o residencia permanente en países elegibles'
    ],
    howToApply: [
      'Registrarse en el portal oficial de Fulbright',
      'Completar el formulario de aplicación en línea',
      'Subir documentos requeridos en formato PDF',
      'Presentar examen de inglés TOEFL o IELTS',
      'Esperar notificación de entrevista'
    ],
    sourceUrl: 'https://fulbright.org',
    featured: true
  },
  {
    id: '2',
    title: 'Investigador Junior - Banco Mundial',
    organization: 'Banco Mundial',
    category: 'Empleo',
    deadline: '2025-11-30',
    modality: 'Híbrida',
    country: 'Washington D.C.',
    description: 'Posición de investigador en el departamento de desarrollo sostenible y cambio climático.',
    benefits: [
      'Salario competitivo acorde al mercado internacional',
      'Seguro médico y dental',
      'Plan de pensiones',
      'Oportunidades de desarrollo profesional',
      'Flexibilidad de trabajo remoto'
    ],
    requirements: [
      'Maestría en Economía, Políticas Públicas o áreas afines',
      'Experiencia mínima de 2 años en investigación',
      'Dominio de inglés y español',
      'Conocimientos avanzados en análisis estadístico',
      'Experiencia con herramientas como Stata o R'
    ],
    howToApply: [
      'Visitar el portal de carreras del Banco Mundial',
      'Crear un perfil profesional',
      'Adjuntar CV y carta de presentación',
      'Completar formulario de competencias',
      'Realizar evaluaciones técnicas en línea'
    ],
    sourceUrl: 'https://worldbank.org/careers',
    featured: true
  },
  {
    id: '3',
    title: 'Voluntariado en Conservación de la Amazonía',
    organization: 'Amazon Conservation Association',
    category: 'Voluntariado',
    deadline: '2025-10-20',
    modality: 'Presencial',
    country: 'Perú',
    description: 'Programa de voluntariado para la conservación de ecosistemas amazónicos y educación ambiental.',
    benefits: [
      'Alojamiento en estaciones de campo',
      'Alimentación completa durante el programa',
      'Capacitación en conservación y biodiversidad',
      'Certificado de participación',
      'Experiencia en trabajo de campo'
    ],
    requirements: [
      'Mayor de 18 años',
      'Interés genuino en conservación ambiental',
      'Nivel básico de español',
      'Buena condición física',
      'Disponibilidad mínima de 3 meses'
    ],
    howToApply: [
      'Enviar correo de interés a volunteers@amazonconservation.org',
      'Completar formulario de aplicación',
      'Adjuntar CV y carta de motivación',
      'Realizar entrevista virtual',
      'Confirmar fechas de participación'
    ],
    sourceUrl: 'https://amazonconservation.org/volunteer',
    featured: true
  },
  {
    id: '4',
    title: 'Beca Erasmus Mundus - Máster en Desarrollo Sostenible',
    organization: 'Unión Europea',
    category: 'Becas',
    deadline: '2026-01-10',
    modality: 'Presencial',
    country: 'Varios países de la UE',
    description: 'Programa de maestría conjunto entre universidades europeas con enfoque en sostenibilidad.',
    benefits: [
      'Beca de 1,400 EUR mensuales',
      'Cobertura de matrícula completa',
      'Costos de viaje cubiertos',
      'Seguro médico',
      'Experiencia en múltiples países europeos'
    ],
    requirements: [
      'Título de licenciatura relacionado',
      'Promedio académico superior a 8.0',
      'Certificado de inglés B2 o superior',
      'Carta de motivación',
      'Dos referencias académicas'
    ],
    howToApply: [
      'Acceder al portal Erasmus+',
      'Seleccionar programa de maestría',
      'Completar aplicación en línea',
      'Subir documentos certificados',
      'Pagar tarifa de aplicación (si aplica)'
    ],
    sourceUrl: 'https://erasmus-plus.ec.europa.eu',
    featured: true
  },
  {
    id: '5',
    title: 'Proyecto de Investigación en IA para la Salud',
    organization: 'MIT Media Lab',
    category: 'Investigación',
    deadline: '2025-11-15',
    modality: 'Virtual',
    country: 'Estados Unidos',
    description: 'Posición de investigación en inteligencia artificial aplicada a diagnóstico médico.',
    benefits: [
      'Estipendio de investigación',
      'Acceso a infraestructura de computación avanzada',
      'Publicación de resultados',
      'Networking con investigadores internacionales',
      'Certificado del MIT'
    ],
    requirements: [
      'Doctorado o maestría en Ciencias de la Computación o afines',
      'Experiencia en machine learning',
      'Publicaciones previas (deseable)',
      'Conocimientos en Python y TensorFlow',
      'Inglés fluido'
    ],
    howToApply: [
      'Enviar propuesta de investigación (máx. 5 páginas)',
      'Adjuntar CV académico',
      'Incluir dos cartas de recomendación',
      'Completar formulario web',
      'Prepararse para entrevista técnica'
    ],
    sourceUrl: 'https://mit.edu/medialab',
    featured: true
  },
  {
    id: '6',
    title: 'Analista de Datos - ONU Mujeres',
    organization: 'ONU Mujeres',
    category: 'Empleo',
    deadline: '2025-10-25',
    modality: 'Híbrida',
    country: 'Ciudad de Panamá',
    description: 'Analista de datos para programas de igualdad de género en América Latina.',
    benefits: [
      'Contrato con agencia de la ONU',
      'Salario competitivo en escala internacional',
      'Seguro médico global',
      'Vacaciones pagadas',
      'Ambiente multicultural'
    ],
    requirements: [
      'Maestría en Estadística, Ciencias Sociales o afines',
      'Experiencia de 3 años en análisis de datos',
      'Dominio de español e inglés',
      'Conocimiento de herramientas de visualización',
      'Compromiso con la igualdad de género'
    ],
    howToApply: [
      'Registrarse en el portal de empleo de la ONU',
      'Crear perfil completo',
      'Aplicar a la posición específica',
      'Adjuntar carta de motivación (P11 form)',
      'Completar evaluaciones de competencias'
    ],
    sourceUrl: 'https://unwomen.org/careers',
    featured: true
  },
  {
    id: '7',
    title: 'Voluntariado en Educación Rural - Teach For All',
    organization: 'Teach For All',
    category: 'Voluntariado',
    deadline: '2025-12-01',
    modality: 'Presencial',
    country: 'Colombia',
    description: 'Programa de enseñanza en comunidades rurales para reducir la brecha educativa.',
    benefits: [
      'Estipendio mensual básico',
      'Alojamiento en comunidad',
      'Capacitación pedagógica',
      'Red de educadores internacionales',
      'Desarrollo de liderazgo'
    ],
    requirements: [
      'Título universitario en cualquier área',
      'Pasión por la educación',
      'Compromiso de 2 años',
      'Español fluido',
      'Disposición para vivir en zona rural'
    ],
    howToApply: [
      'Llenar formulario de aplicación en línea',
      'Enviar ensayo sobre motivación',
      'Adjuntar CV y certificados',
      'Participar en proceso de selección',
      'Asistir a entrenamiento inicial'
    ],
    sourceUrl: 'https://teachforall.org',
    featured: true
  },
  {
    id: '8',
    title: 'Beca Chevening para Líderes del Futuro',
    organization: 'Gobierno del Reino Unido',
    category: 'Becas',
    deadline: '2025-11-07',
    modality: 'Presencial',
    country: 'Reino Unido',
    description: 'Beca completa para realizar maestría de un año en universidades británicas.',
    benefits: [
      'Matrícula universitaria completa',
      'Estipendio mensual de manutención',
      'Pasajes aéreos',
      'Subsidio para llegada y retorno',
      'Acceso a eventos de networking'
    ],
    requirements: [
      'Mínimo 2 años de experiencia profesional',
      'Título universitario que permita acceso a posgrado en UK',
      'Nivel de inglés IELTS 6.5 o superior',
      'Liderazgo demostrado',
      'Compromiso de regresar al país de origen'
    ],
    howToApply: [
      'Crear cuenta en el portal Chevening',
      'Seleccionar 3 programas de maestría',
      'Completar formulario extenso',
      'Redactar ensayos de liderazgo',
      'Proporcionar referencias'
    ],
    sourceUrl: 'https://chevening.org',
    featured: true
  },
  {
    id: '9',
    title: 'Fellowship en Políticas Públicas - CIPPEC',
    organization: 'CIPPEC Argentina',
    category: 'Investigación',
    deadline: '2025-11-20',
    modality: 'Híbrida',
    country: 'Argentina',
    description: 'Programa de fellowship para investigadores en políticas públicas de América Latina.',
    benefits: [
      'Estipendio mensual de investigación',
      'Espacio de trabajo en oficinas de CIPPEC',
      'Mentoría de expertos en políticas públicas',
      'Publicación de investigación',
      'Red de contactos regional'
    ],
    requirements: [
      'Maestría o doctorado en ciencias sociales',
      'Propuesta de investigación innovadora',
      'Experiencia en análisis de políticas',
      'Español fluido',
      'Compromiso de 6 meses'
    ],
    howToApply: [
      'Enviar propuesta de investigación de 10 páginas',
      'Adjuntar CV académico',
      'Incluir carta de motivación',
      'Dos cartas de recomendación',
      'Entrevista con comité de selección'
    ],
    sourceUrl: 'https://cippec.org',
    featured: true
  },
  {
    id: '10',
    title: 'Pasantía en Derechos Humanos - CIDH',
    organization: 'Comisión Interamericana de Derechos Humanos',
    category: 'Empleo',
    deadline: '2025-10-30',
    modality: 'Presencial',
    country: 'Washington D.C.',
    description: 'Pasantía en la CIDH para estudiantes y recién graduados en derecho y ciencias sociales.',
    benefits: [
      'Experiencia en organización internacional',
      'Certificado oficial de la OEA',
      'Networking con profesionales del área',
      'Participación en casos reales',
      'Posible extensión de contrato'
    ],
    requirements: [
      'Estudiante de derecho o ciencias sociales (últimos semestres)',
      'Promedio académico superior a 8.0',
      'Español e inglés fluidos',
      'Interés en derechos humanos',
      'Disponibilidad de 3-6 meses'
    ],
    howToApply: [
      'Enviar CV a internships@oas.org',
      'Carta de motivación',
      'Certificado de estudios',
      'Carta de recomendación académica',
      'Entrevista virtual'
    ],
    sourceUrl: 'https://oas.org/internships',
    featured: true
  },
  {
    id: '11',
    title: 'Beca DAAD para Artistas y Arquitectos',
    organization: 'Servicio Alemán de Intercambio Académico',
    category: 'Becas',
    deadline: '2025-12-10',
    modality: 'Presencial',
    country: 'Alemania',
    description: 'Programa de becas para artistas, músicos, arquitectos y diseñadores.',
    benefits: [
      'Beca mensual de 1,200 EUR',
      'Seguro médico',
      'Subsidio de viaje',
      'Curso de alemán intensivo',
      'Acceso a talleres y estudios'
    ],
    requirements: [
      'Portafolio artístico destacado',
      'Título universitario en área artística',
      'Propuesta de proyecto creativo',
      'Carta de aceptación de institución alemana',
      'Conocimientos básicos de alemán o inglés'
    ],
    howToApply: [
      'Registrarse en portal DAAD',
      'Subir portafolio digital',
      'Presentar propuesta de proyecto',
      'Adjuntar certificados académicos',
      'Entrevista con jurado'
    ],
    sourceUrl: 'https://daad.de',
    featured: true
  },
  {
    id: '12',
    title: 'Consultor en Cambio Climático - PNUD',
    organization: 'Programa de las Naciones Unidas para el Desarrollo',
    category: 'Empleo',
    deadline: '2025-11-10',
    modality: 'Virtual',
    country: 'América Latina',
    description: 'Consultoría para desarrollo de proyectos de adaptación al cambio climático.',
    benefits: [
      'Contrato de consultoría internacional',
      'Honorarios competitivos',
      'Trabajo 100% remoto',
      'Flexibilidad horaria',
      'Impacto en políticas ambientales'
    ],
    requirements: [
      'Maestría en Medio Ambiente o áreas relacionadas',
      'Mínimo 5 años de experiencia',
      'Conocimiento de marcos internacionales (Acuerdo de París)',
      'Español e inglés avanzados',
      'Capacidad de trabajo independiente'
    ],
    howToApply: [
      'Aplicar en portal de empleos de PNUD',
      'Enviar propuesta técnica',
      'CV en formato P11',
      'Referencias profesionales',
      'Propuesta financiera'
    ],
    sourceUrl: 'https://jobs.undp.org',
    featured: true
  }
];
