import 'package:kaleo_frontend/features/opportunity/presentation/screens/opportunity_detail_screen.dart';

class MockOpportunities {
  static final List<OpportunityDetail> opportunities = [
    OpportunityDetail(
      id: '1',
      title: 'Beca Fulbright para Estudios de Posgrado en EE.UU.',
      organization: 'Programa Fulbright',
      category: 'Becas',
      deadline: DateTime(2025, 12, 15),
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
    ),
    OpportunityDetail(
      id: '2',
      title: 'Investigador Junior - Banco Mundial',
      organization: 'Banco Mundial',
      category: 'Empleo',
      deadline: DateTime(2025, 11, 30),
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
    ),
    OpportunityDetail(
      id: '3',
      title: 'Voluntariado en Conservación de la Amazonía',
      organization: 'Amazon Conservation Association',
      category: 'Voluntariado',
      deadline: DateTime(2025, 10, 20),
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
    ),
    OpportunityDetail(
      id: '4',
      title: 'Beca Erasmus Mundus - Máster en Desarrollo Sostenible',
      organization: 'Unión Europea',
      category: 'Becas',
      deadline: DateTime(2026, 1, 10),
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
    ),
    OpportunityDetail(
      id: '5',
      title: 'Proyecto de Investigación en IA para la Salud',
      organization: 'MIT Media Lab',
      category: 'Investigación',
      deadline: DateTime(2025, 11, 15),
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
    ),
    OpportunityDetail(
      id: '6',
      title: 'Analista de Datos - ONU Mujeres',
      organization: 'ONU Mujeres',
      category: 'Empleo',
      deadline: DateTime(2025, 10, 25),
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
    ),
  ];

  static OpportunityDetail? getById(String id) {
    try {
      return opportunities.firstWhere((opp) => opp.id == id);
    } catch (e) {
      return null;
    }
  }
}
