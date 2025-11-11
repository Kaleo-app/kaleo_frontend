import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/app_header.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';
import 'package:kaleo_frontend/features/info/data/organization_service.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class AboutScreen extends StatefulWidget {
  final Function(int)? onTabChanged;

  const AboutScreen({super.key, this.onTabChanged});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final OrganizationService _orgService;
  List<OrganizationType> _organizationTypes = [];
  bool _loadingSources = true;
  String? _errorSources;
  /*
  @override
  void initState() {
    super.initState();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    _orgService = OrganizationService(
      baseUrl: isAndroid
          ? 'http://10.0.2.2:8000' // ANDROID EMULADOR
          : 'http://127.0.0.1:8000', // WEB / iOS SIMULATOR / DESKTOP
    );
    _loadOrganizations();
  }
  */
  @override
  void initState() {
    super.initState();

    _orgService = OrganizationService(); // sin 10.0.2.2 / 127.0.0.1

    _loadOrganizations();
  }


  Future<void> _loadOrganizations() async {
    setState(() {
      _loadingSources = true;
      _errorSources = null;
    });

    try {
      final types = await _orgService.listOrganizationsByType();
      setState(() {
        _organizationTypes = types;
        _loadingSources = false;
      });
    } catch (e) {
      setState(() {
        _errorSources = e.toString();
        _loadingSources = false;
      });
    }
  }

  IconData _getIconForType(String? type) {
    if (type == null) return Icons.public;
    final lower = type.toLowerCase();
    if (lower.contains('universidad') || lower.contains('university')) {
      return Icons.school;
    } else if (lower.contains('gobierno') ||
        lower.contains('embajada') ||
        lower.contains('ministerio')) {
      return Icons.account_balance;
    } else if (lower.contains('fundación') ||
        lower.contains('fundacion') ||
        lower.contains('ong') ||
        lower.contains('fundation')) {
      return Icons.favorite;
    } else if (lower.contains('organización') ||
        lower.contains('organizacion') ||
        lower.contains('organización internacional')) {
      return Icons.public;
    }
    return Icons.public;
  }

  String _formatTypeName(String? type) {
    if (type == null || type.isEmpty) return 'Otros';
    return type;
  }

  String _formatOrganizationsList(List<Organization> orgs) {
    if (orgs.isEmpty) return '';
    return orgs.map((org) => org.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si es web y pantalla ancha
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    Widget mainContent = CustomScrollView(
      slivers: [
        // Header con gradiente
        const SliverToBoxAdapter(
          child: AppHeader(
            title: 'Kaleo',
            subtitle: 'Conectando talento con oportunidades',
          ),
        ),

        // Navbar principal para web
        if (isWideWeb)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WebMainNavbar(
                currentIndex: 2, // Acerca de
                onTabChanged: widget.onTabChanged ?? (index) {},
              ),
            ),
          ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ¿Qué es Kaleo?
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Qué es Kaleo?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Kaleo es una plataforma que centraliza y analiza convocatorias públicas internacionales para facilitar el acceso a oportunidades académicas y profesionales.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Feature cards
                Row(
                  children: [
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.gps_fixed,
                        title: 'Nuestro propósito',
                        description:
                            'Democratizar el acceso a oportunidades internacionales mediante tecnología.',
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.public,
                        title: 'Alcance global',
                        description:
                            'Convocatorias de más de 50 organizaciones en todo el mundo.',
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        icon: Icons.people,
                        title: 'Para todos',
                        description:
                            'Becas, empleos, investigación y voluntariado en un solo lugar.',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ¿Cómo funciona?
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¿Cómo funciona?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16),
                      _ProcessStep(
                        number: 1,
                        title: 'Recolección automatizada',
                        description:
                            'Nuestros sistemas recopilan convocatorias de fuentes oficiales diariamente.',
                      ),
                      SizedBox(height: 12),
                      _ProcessStep(
                        number: 2,
                        title: 'Normalización de datos',
                        description:
                            'Organizamos la información en un formato consistente y fácil de entender.',
                      ),
                      SizedBox(height: 12),
                      _ProcessStep(
                        number: 3,
                        title: 'Análisis inteligente',
                        description:
                            'Categorizamos y filtramos las oportunidades para que encuentres lo que buscas.',
                      ),
                      SizedBox(height: 12),
                      _ProcessStep(
                        number: 4,
                        title: 'Acceso directo',
                        description:
                            'Te conectamos directamente con la fuente oficial para que puedas aplicar.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    Expanded(
                      child:
                          _StatCard(number: '500+', label: 'Convocatorias'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                          _StatCard(number: '50+', label: 'Organizaciones'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(number: '30+', label: 'Países'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fuentes de información
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fuentes de información',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nuestras convocatorias provienen de fuentes oficiales y confiables:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Loading
                      if (_loadingSources)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child:
                              Center(child: CircularProgressIndicator()),
                       )

                      // Error con botón Reintentar (mismo patrón que otras vistas)
                      else if (_errorSources != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 32, color: Colors.redAccent),
                              const SizedBox(height: 8),
                              const Text(
                                'No se pudieron cargar las fuentes de información.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _errorSources!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed: _loadOrganizations,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        )

                      // Sin fuentes
                      else if (_organizationTypes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No hay fuentes disponibles',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        )

                      // Lista de fuentes agrupadas
                      else
                        ...List.generate(_organizationTypes.length,
                            (index) {
                          final type = _organizationTypes[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index <
                                      _organizationTypes.length - 1
                                  ? 8
                                  : 0,
                            ),
                            child: _SourceItem(
                              name: _formatTypeName(type.type),
                              examples: _formatOrganizationsList(
                                  type.organizations),
                              icon: _getIconForType(type.type),
                            ),
                          );
                        }),
                      const SizedBox(height: 12),
                      const Text(
                        'Todas las convocatorias son verificadas y actualizadas diariamente para garantizar su vigencia y precisión.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Versión 1.0.0 - Prototipo para feedback del equipo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // En web y pantalla ancha, centramos y damos margen
    if (isWideWeb) {
      mainContent = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 950),
          padding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: mainContent,
        ),
      );
    }

    return Scaffold(
      body: mainContent,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _ProcessStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  final String name;
  final String examples;
  final IconData icon;

  const _SourceItem({
    required this.name,
    required this.examples,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.blue, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                examples,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/app_header.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';
import 'package:kaleo_frontend/features/info/data/organization_service.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class AboutScreen extends StatefulWidget {
  final Function(int)? onTabChanged;
  
  const AboutScreen({super.key, this.onTabChanged});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final OrganizationService _orgService;
  List<OrganizationType> _organizationTypes = [];
  bool _loadingSources = true;
  String? _errorSources;

  @override
  void initState() {
    super.initState();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    _orgService = OrganizationService(
      baseUrl: isAndroid
          ? 'http://10.0.2.2:8000'   // ANDROID EMULADOR
          : 'http://127.0.0.1:8000', // WEB / iOS SIMULATOR / DESKTOP
    );
    _loadOrganizations();
  }

  Future<void> _loadOrganizations() async {
    setState(() {
      _loadingSources = true;
      _errorSources = null;
    });
    
    try {
      final types = await _orgService.listOrganizationsByType();
      setState(() {
        _organizationTypes = types;
        _loadingSources = false;
      });
    } catch (e) {
      setState(() {
        _errorSources = e.toString();
        _loadingSources = false;
      });
    }
  }

  IconData _getIconForType(String? type) {
    if (type == null) return Icons.public;
    final lower = type.toLowerCase();
    if (lower.contains('universidad') || lower.contains('universidad') || lower.contains('university')) {
      return Icons.school;
    } else if (lower.contains('gobierno') || lower.contains('embajada') || lower.contains('ministerio')) {
      return Icons.account_balance;
    } else if (lower.contains('fundación') || lower.contains('ong') || lower.contains('fundation')) {
      return Icons.favorite;
    } else if (lower.contains('organización') || lower.contains('organización internacional')) {
      return Icons.public;
    }
    return Icons.public;
  }

  String _formatTypeName(String? type) {
    if (type == null || type.isEmpty) return 'Otros';
    return type;
  }

  String _formatOrganizationsList(List<Organization> orgs) {
    if (orgs.isEmpty) return '';
    return orgs.map((org) => org.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si es web y pantalla ancha
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    Widget mainContent = CustomScrollView(
      slivers: [
        // Header con gradiente (sin flecha de atrás)
        SliverToBoxAdapter(
          child: const AppHeader(
            title: 'Kaleo',
            subtitle: 'Conectando talento con oportunidades',
          ),
        ),
        // Navbar principal para web (debajo del header)
        if (isWideWeb)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: WebMainNavbar(
                currentIndex: 2, // Acerca de
                onTabChanged: widget.onTabChanged ?? (index) {},
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Sección principal exacta del prototipo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Qué es Kaleo?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kaleo es una plataforma que centraliza y analiza convocatorias públicas internacionales para facilitar el acceso a oportunidades académicas y profesionales.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Tarjetas de características exactas del prototipo
                  Row(
                    children: [
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.gps_fixed,
                          title: 'Nuestro propósito',
                          description: 'Democratizar el acceso a oportunidades internacionales mediante tecnología.',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.public,
                          title: 'Alcance global',
                          description: 'Convocatorias de más de 50 organizaciones en todo el mundo.',
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.people,
                          title: 'Para todos',
                          description: 'Becas, empleos, investigación y voluntariado en un solo lugar.',
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Sección "¿Cómo funciona?" exacta del prototipo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¿Cómo funciona?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        _ProcessStep(
                          number: 1,
                          title: 'Recolección automatizada',
                          description: 'Nuestros sistemas recopilan convocatorias de fuentes oficiales diariamente.',
                        ),
                        SizedBox(height: 12),
                        _ProcessStep(
                          number: 2,
                          title: 'Normalización de datos',
                          description: 'Organizamos la información en un formato consistente y fácil de entender.',
                        ),
                        SizedBox(height: 12),
                        _ProcessStep(
                          number: 3,
                          title: 'Análisis inteligente',
                          description: 'Categorizamos y filtramos las oportunidades para que encuentres lo que buscas.',
                        ),
                        SizedBox(height: 12),
                        _ProcessStep(
                          number: 4,
                          title: 'Acceso directo',
                          description: 'Te conectamos directamente con la fuente oficial para que puedas aplicar.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Tarjetas de estadísticas exactas del prototipo
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(number: '500+', label: 'Convocatorias'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(number: '50+', label: 'Organizaciones'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(number: '30+', label: 'Países'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Nueva sección: Fuentes de información
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fuentes de información',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nuestras convocatorias provienen de fuentes oficiales y confiables:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Mostrar fuentes reales de la base de datos
                        if (_loadingSources)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_errorSources != null)
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Error cargando fuentes: $_errorSources',
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          )
                        else if (_organizationTypes.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No hay fuentes disponibles',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          )
                        else
                          ...List.generate(_organizationTypes.length, (index) {
                            final type = _organizationTypes[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: index < _organizationTypes.length - 1 ? 8 : 0),
                              child: _SourceItem(
                                name: _formatTypeName(type.type),
                                examples: _formatOrganizationsList(type.organizations),
                                icon: _getIconForType(type.type),
                              ),
                            );
                          }),
                        const SizedBox(height: 12),
                        const Text(
                          'Todas las convocatorias son verificadas y actualizadas diariamente para garantizar su vigencia y precisión.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Footer exacto del prototipo
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Versión 1.0.0 - Prototipo para feedback del equipo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

    // En web y pantalla ancha, centramos y damos margen lateral amplio
    if (isWideWeb) {
      mainContent = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 950),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
          child: mainContent,
        ),
      );
    }

    return Scaffold(
      body: mainContent,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  
  const _ProcessStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '$number',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  
  const _StatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceItem extends StatelessWidget {
  final String name;
  final String examples;
  final IconData icon;
  
  const _SourceItem({
    required this.name,
    required this.examples,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.blue, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                examples,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

*/