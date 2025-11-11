import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/opportunity_card.dart';
import 'package:kaleo_frontend/core/widgets/app_header.dart';
import 'package:kaleo_frontend/core/widgets/app_footer.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';

import 'package:kaleo_frontend/features/opportunity/presentation/screens/opportunity_detail_screen.dart';
import 'package:kaleo_frontend/features/opportunity/data/opportunity_service.dart';
import 'package:kaleo_frontend/features/opportunity/data/opportunity_model.dart';

class ResultsScreen extends StatefulWidget {
  final Function(int)? onTabChanged;

  const ResultsScreen({super.key, this.onTabChanged});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TextEditingController _search = TextEditingController();
  final List<String> _filters = const [
    'Becas',
    'Empleo',
    'Investigación',
    'Voluntariado',
  ];
  String? _selected;

  late final OpportunityService _service;

  // Datos traídos desde el backend (página actual)
  List<Opportunity> _items = [];
  bool _loading = true;
  String? _error;

  // Paginación desde backend
  int _page = 1;
  final int _pageSize = 10; // 10 ofertas por página
  int _total = 0; // total de convocatorias (viene del backend)

  @override
  void initState() {
    super.initState();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    _service = OpportunityService(
      baseUrl: isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000',
    );

    // Solo redibujamos iconos al escribir; la búsqueda se ejecuta con Enter / botón
    _search.addListener(() {
      setState(() {});
    });

    _fetchPage(page: 1);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================

  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  // Mapea categoría del backend a texto para UI
  String? _mapBackendCategoryToUI(String? backendCategory) {
    if (backendCategory == null) return null;
    final lower = backendCategory.toLowerCase().trim();
    if (lower == 'empleo') return 'Empleo';
    if (lower == 'voluntariado') return 'Voluntariado';
    if (lower == 'investigación' || lower == 'investigacion') return 'Investigación';
    if (lower == 'paec' || lower == 'beca' || lower == 'becas') return 'Becas';
    return _capitalize(backendCategory);
  }

  // Mapea categoría seleccionada en UI al valor esperado por el backend
  String? _mapUICategoryToBackend(String? uiCategory) {
    if (uiCategory == null) return null;
    final lower = uiCategory.toLowerCase().trim();
    if (lower == 'becas') return 'beca'; // ajusta si tu backend usa otro valor
    if (lower == 'empleo') return 'empleo';
    if (lower == 'voluntariado') return 'voluntariado';
    if (lower == 'investigación') return 'investigación';
    return uiCategory;
  }

  String _locationText(Opportunity o) {
    if (o.locations.isEmpty) return '—';
    final l = o.locations.first;
    final parts = [
      l.city,
      l.region,
      l.country,
    ]
        .where((e) => e != null && e!.trim().isNotEmpty)
        .cast<String>()
        .toList();
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  String? _hostFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty ? uri.host : null;
    } catch (_) {
      return null;
    }
  }

  // ==================== FETCH PAGINADO ====================

  Future<void> _fetchPage({required int page}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final query = _search.text.trim();
      final backendCategory = _mapUICategoryToBackend(_selected);

      final resp = await _service.listPaged(
        page: page,
        pageSize: _pageSize,
        query: query.isEmpty ? null : query,
        category: backendCategory,
      );

      setState(() {
        _page = resp.page;
        _total = resp.total;
        _items = resp.items;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _items = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Ejecuta búsqueda cuando el usuario presiona Enter o el ícono de búsqueda
  void _onSearchSubmit() {
    FocusScope.of(context).unfocus(); // cierra teclado
    _fetchPage(page: 1);
  }

  // Limpia búsqueda y recarga resultados generales
  void _onClearSearch() {
    _search.clear();
    FocusScope.of(context).unfocus();
    _fetchPage(page: 1);
  }

  // ==================== DETALLE ====================

  OpportunityDetail _mapDetail(Map<String, dynamic> j) {
    String country = '—';
    final locs = (j['locations'] as List<dynamic>? ?? []);
    if (locs.isNotEmpty) {
      final first = locs.first as Map<String, dynamic>;
      final c = first['country']?.toString().trim();
      if (c != null && c.isNotEmpty) country = c;
    }

    String organization = '—';
    final url = j['official_url']?.toString();
    if (url != null && url.isNotEmpty) {
      try {
        final host = Uri.parse(url).host;
        if (host.isNotEmpty) organization = host;
      } catch (_) {}
    }
    if (organization == '—' && (j['category']?.toString().isNotEmpty ?? false)) {
      organization = j['category'].toString();
    }

    DateTime deadline = DateTime.now();
    final rawDeadline = j['deadline']?.toString();
    final parsed = rawDeadline != null ? DateTime.tryParse(rawDeadline) : null;
    if (parsed != null) deadline = parsed;

    return OpportunityDetail(
      id: j['id']?.toString() ?? '',
      title: j['title']?.toString() ?? '—',
      organization: organization,
      category: j['category']?.toString() ?? '—',
      deadline: deadline,
      modality: j['modality']?.toString() ?? '—',
      country: country,
      description: j['description']?.toString() ?? 'Sin descripción',
      benefits: const <String>[],
      requirements: const <String>[],
      howToApply: const <String>[],
      sourceUrl: j['official_url']?.toString() ?? '',
    );
  }

  Future<void> _navigateToDetail(Opportunity o) async {
    try {
      final raw = await _service.getDetailRaw(o.id);
      final detail = _mapDetail(raw);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OpportunityDetailScreen(opportunity: detail),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cargar el detalle: $e')),
      );
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    final int totalPages =
        _total == 0 ? 1 : (_total / _pageSize).ceil().clamp(1, 999);

    Widget mainContent;

    if (_loading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      // ===== Estado de error con botón Reintentar (mismo estilo que en DemoListScreen) =====
      mainContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
              const SizedBox(height: 12),
              const Text(
                'No se pudieron cargar las convocatorias.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _fetchPage(page: 1),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else {
      mainContent = CustomScrollView(
        slivers: [
          // Encabezado + filtros + búsqueda
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(
                  title: 'Kaleo',
                  subtitle: 'Explora nuevas oportunidades',
                ),
                if (isWideWeb)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: WebMainNavbar(
                      currentIndex: 1,
                      onTabChanged: widget.onTabChanged ?? (index) {}),
                  ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explorar convocatorias',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_total convocatorias disponibles',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _search,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _onSearchSubmit(),
                        decoration: InputDecoration(
                          hintText:
                              'Buscar por título, organización o descripción...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          suffixIcon: _search.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: _onClearSearch,
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey,
                                  ),
                                  onPressed: _onSearchSubmit,
                                ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _filters.map<Widget>((f) {
                          final active = _selected == f;
                          return FilterChip(
                            label: Text(f),
                            selected: active,
                            onSelected: (_) {
                              setState(() {
                                _selected = active ? null : f;
                              });
                              _fetchPage(page: 1);
                            },
                            selectedColor:
                                AppColors.primary.withOpacity(0.15),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textLight.withOpacity(0.3),
                            ),
                            backgroundColor: Colors.white,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
              ],
            ),
          ),

          // Lista de resultados (página actual)
          SliverList.separated(
            itemBuilder: (_, i) {
              final it = _items[i];
              final mappedCat =
                  _mapBackendCategoryToUI(it.category) ?? '—';
              final organization =
                  _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
              //final locText = _locationText(it);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: OpportunityCard(
                  title: it.title,
                  organization: organization,
                  category: mappedCat,
                  deadline: it.deadline,
                  //location: locText,
                  modality: _capitalize(it.modality),
                  onTap: () => _navigateToDetail(it),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemCount: _items.length,
          ),

          // Controles de paginación (con Wrap para evitar overflow)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PageBtn(
                    label: 'Anterior',
                    enabled: _page > 1,
                    onTap: () {
                      if (_page > 1) {
                        _fetchPage(page: _page - 1);
                      }
                    },
                  ),
                  ..._buildPageNumbers(totalPages),
                  _PageBtn(
                    label: 'Siguiente',
                    enabled: _page < totalPages,
                    onTap: () {
                      if (_page < totalPages) {
                        _fetchPage(page: _page + 1);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: AppFooter(),
            ),
          ),
        ],
      );
    }

    // En web y pantalla ancha, centramos el contenido
    if (isWideWeb) {
      mainContent = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 950),
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 0,
          ),
          child: mainContent,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: mainContent,
      ),
    );
  }

  // Construcción de numeración con "…" cuando hay muchas páginas
  List<Widget> _buildPageNumbers(int totalPages) {
    final List<Widget> widgets = [];

    final pages = <int>{1, totalPages};
    for (int p = _page - 1; p <= _page + 1; p++) {
      if (p > 1 && p < totalPages) {
        pages.add(p);
      }
    }

    final sorted = pages.toList()..sort();

    for (int i = 0; i < sorted.length; i++) {
      final p = sorted[i];

      if (i > 0 && p != sorted[i - 1] + 1) {
        widgets.add(const _Ellipsis());
      }

      widgets.add(
        _PageNumber(
          page: p,
          current: _page,
          onTap: () {
            if (p != _page) {
              _fetchPage(page: p);
            }
          },
        ),
      );
    }

    return widgets;
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PageBtn({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? AppColors.textPrimary : AppColors.textLight;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: fg.withOpacity(0.3),
          ),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  final int page;
  final int current;
  final VoidCallback onTap;

  const _PageNumber({
    required this.page,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = page == current;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: active ? AppColors.primary : Colors.white,
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : AppColors.textLight.withOpacity(0.3),
            ),
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color: active ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '…',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/opportunity_card.dart';
import 'package:kaleo_frontend/core/widgets/app_header.dart';
import 'package:kaleo_frontend/core/widgets/app_footer.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';

import 'package:kaleo_frontend/features/opportunity/presentation/screens/opportunity_detail_screen.dart';
import 'package:kaleo_frontend/features/opportunity/data/opportunity_service.dart';
import 'package:kaleo_frontend/features/opportunity/data/opportunity_model.dart';

class ResultsScreen extends StatefulWidget {
  final Function(int)? onTabChanged;

  const ResultsScreen({super.key, this.onTabChanged});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final TextEditingController _search = TextEditingController();
  final List<String> _filters = const [
    'Becas',
    'Empleo',
    'Investigación',
    'Voluntariado',
  ];
  String? _selected;

  late final OpportunityService _service;

  // Datos traídos desde el backend (página actual)
  List<Opportunity> _items = [];
  bool _loading = true;
  String? _error;

  // Paginación desde backend
  int _page = 1;
  final int _pageSize = 10; // 10 ofertas por página
  int _total = 0; // total de convocatorias (viene del backend)

  @override
  void initState() {
    super.initState();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    _service = OpportunityService(
      baseUrl: isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000',
    );

    // Solo redibujamos iconos al escribir; la búsqueda se hace al dar Enter / botón.
    _search.addListener(() {
      setState(() {});
    });

    _fetchPage(page: 1);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ==================== HELPERS ====================

  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  // Mapea categoría del backend a texto para UI
  String? _mapBackendCategoryToUI(String? backendCategory) {
    if (backendCategory == null) return null;
    final lower = backendCategory.toLowerCase().trim();
    if (lower == 'empleo') return 'Empleo';
    if (lower == 'voluntariado') return 'Voluntariado';
    if (lower == 'investigación' || lower == 'investigacion') return 'Investigación';
    if (lower == 'paec' || lower == 'beca' || lower == 'becas') return 'Becas';
    return _capitalize(backendCategory);
  }

  // Mapea categoría seleccionada en UI al valor esperado por el backend
  String? _mapUICategoryToBackend(String? uiCategory) {
    if (uiCategory == null) return null;
    final lower = uiCategory.toLowerCase().trim();
    if (lower == 'becas') return 'beca'; // ajusta si tu backend usa otro valor
    if (lower == 'empleo') return 'empleo';
    if (lower == 'voluntariado') return 'voluntariado';
    if (lower == 'investigación') return 'investigación';
    return uiCategory;
  }

  String _locationText(Opportunity o) {
    if (o.locations.isEmpty) return '—';
    final l = o.locations.first;
    final parts = [
      l.city,
      l.region,
      l.country,
    ]
        .where((e) => e != null && e!.trim().isNotEmpty)
        .cast<String>()
        .toList();
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  String? _hostFromUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      return uri.host.isNotEmpty ? uri.host : null;
    } catch (_) {
      return null;
    }
  }

  // ==================== FETCH PAGINADO ====================

  Future<void> _fetchPage({required int page}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final query = _search.text.trim();
      final backendCategory = _mapUICategoryToBackend(_selected);

      final resp = await _service.listPaged(
        page: page,
        pageSize: _pageSize,
        query: query.isEmpty ? null : query,
        category: backendCategory,
      );

      setState(() {
        _page = resp.page;
        _total = resp.total;
        _items = resp.items;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // Ejecuta búsqueda cuando el usuario presiona Enter o el ícono de búsqueda
  void _onSearchSubmit() {
    FocusScope.of(context).unfocus(); // cierra teclado
    _fetchPage(page: 1);
  }

  // Limpia búsqueda y recarga resultados generales
  void _onClearSearch() {
    _search.clear();
    FocusScope.of(context).unfocus();
    _fetchPage(page: 1);
  }

  // ==================== DETALLE ====================

  OpportunityDetail _mapDetail(Map<String, dynamic> j) {
    String country = '—';
    final locs = (j['locations'] as List<dynamic>? ?? []);
    if (locs.isNotEmpty) {
      final first = locs.first as Map<String, dynamic>;
      final c = first['country']?.toString().trim();
      if (c != null && c.isNotEmpty) country = c;
    }

    String organization = '—';
    final url = j['official_url']?.toString();
    if (url != null && url.isNotEmpty) {
      try {
        final host = Uri.parse(url).host;
        if (host.isNotEmpty) organization = host;
      } catch (_) {}
    }
    if (organization == '—' && (j['category']?.toString().isNotEmpty ?? false)) {
      organization = j['category'].toString();
    }

    DateTime deadline = DateTime.now();
    final rawDeadline = j['deadline']?.toString();
    final parsed = rawDeadline != null ? DateTime.tryParse(rawDeadline) : null;
    if (parsed != null) deadline = parsed;

    return OpportunityDetail(
      id: j['id']?.toString() ?? '',
      title: j['title']?.toString() ?? '—',
      organization: organization,
      category: j['category']?.toString() ?? '—',
      deadline: deadline,
      modality: j['modality']?.toString() ?? '—',
      country: country,
      description: j['description']?.toString() ?? 'Sin descripción',
      benefits: const <String>[],
      requirements: const <String>[],
      howToApply: const <String>[],
      sourceUrl: j['official_url']?.toString() ?? '',
    );
  }

  Future<void> _navigateToDetail(Opportunity o) async {
    try {
      final raw = await _service.getDetailRaw(o.id);
      final detail = _mapDetail(raw);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OpportunityDetailScreen(opportunity: detail),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo cargar el detalle: $e')),
      );
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    final int totalPages = _total == 0
        ? 1
        : (_total / _pageSize).ceil().clamp(1, 999);

    Widget mainContent;

    if (_loading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      mainContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Error cargando datos:\n$_error'),
        ),
      );
    } else {
      mainContent = CustomScrollView(
        slivers: [
          // Encabezado + filtros + búsqueda
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(
                  title: 'Kaleo',
                  subtitle: 'Explora nuevas oportunidades',
                ),
                if (isWideWeb)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: WebMainNavbar(
                      currentIndex: 1,
                      onTabChanged: widget.onTabChanged ?? (index) {}),
                  ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explorar convocatorias',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$_total convocatorias disponibles',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _search,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _onSearchSubmit(),
                        decoration: InputDecoration(
                          hintText:
                              'Buscar por título, organización o descripción...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          suffixIcon: _search.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                  onPressed: _onClearSearch,
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey,
                                  ),
                                  onPressed: _onSearchSubmit,
                                ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: AppColors.primary),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _filters.map<Widget>((f) {
                          final active = _selected == f;
                          return FilterChip(
                            label: Text(f),
                            selected: active,
                            onSelected: (_) {
                              setState(() {
                                _selected = active ? null : f;
                              });
                              _fetchPage(page: 1);
                            },
                            selectedColor:
                                AppColors.primary.withOpacity(0.15),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            side: BorderSide(
                              color: active
                                  ? AppColors.primary
                                  : AppColors.textLight.withOpacity(0.3),
                            ),
                            backgroundColor: Colors.white,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
              ],
            ),
          ),

          // Lista de resultados (página actual)
          SliverList.separated(
            itemBuilder: (_, i) {
              final it = _items[i];
              final mappedCat =
                  _mapBackendCategoryToUI(it.category) ?? '—';
              final organization =
                  _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
              //final locText = _locationText(it);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: OpportunityCard(
                  title: it.title,
                  organization: organization,
                  category: mappedCat,
                  deadline: it.deadline,
                  //location: locText,
                  modality: _capitalize(it.modality),
                  onTap: () => _navigateToDetail(it),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemCount: _items.length,
          ),

          // Controles de paginación (con Wrap para evitar overflow)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PageBtn(
                    label: 'Anterior',
                    enabled: _page > 1,
                    onTap: () {
                      if (_page > 1) {
                        _fetchPage(page: _page - 1);
                      }
                    },
                  ),
                  ..._buildPageNumbers(totalPages),
                  _PageBtn(
                    label: 'Siguiente',
                    enabled: _page < totalPages,
                    onTap: () {
                      if (_page < totalPages) {
                        _fetchPage(page: _page + 1);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: AppFooter(),
            ),
          ),
        ],
      );
    }

    // En web y pantalla ancha, centramos el contenido
    if (isWideWeb) {
      mainContent = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 950),
          padding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 0,
          ),
          child: mainContent,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: mainContent,
      ),
    );
  }

  // Construcción de numeración con "…" cuando hay muchas páginas
  List<Widget> _buildPageNumbers(int totalPages) {
    final List<Widget> widgets = [];

    final pages = <int>{1, totalPages};
    for (int p = _page - 1; p <= _page + 1; p++) {
      if (p > 1 && p < totalPages) {
        pages.add(p);
      }
    }

    final sorted = pages.toList()..sort();

    for (int i = 0; i < sorted.length; i++) {
      final p = sorted[i];

      if (i > 0 && p != sorted[i - 1] + 1) {
        widgets.add(const _Ellipsis());
      }

      widgets.add(
        _PageNumber(
          page: p,
          current: _page,
          onTap: () {
            if (p != _page) {
              _fetchPage(page: p);
            }
          },
        ),
      );
    }

    return widgets;
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PageBtn({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = enabled ? AppColors.textPrimary : AppColors.textLight;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: fg.withOpacity(0.3),
          ),
          color: Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PageNumber extends StatelessWidget {
  final int page;
  final int current;
  final VoidCallback onTap;

  const _PageNumber({
    required this.page,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = page == current;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: active ? AppColors.primary : Colors.white,
            border: Border.all(
              color: active
                  ? AppColors.primary
                  : AppColors.textLight.withOpacity(0.3),
            ),
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color: active ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '…',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

*/