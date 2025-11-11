import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import 'package:kaleo_frontend/core/widgets/category_square_card.dart';
import 'package:kaleo_frontend/core/widgets/app_header.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';
import 'package:kaleo_frontend/core/widgets/app_footer.dart';
import 'package:kaleo_frontend/core/widgets/opportunity_card.dart';

import 'package:kaleo_frontend/features/opportunity/data/opportunity_service.dart';
import 'package:kaleo_frontend/features/opportunity/data/opportunity_model.dart';
import 'package:kaleo_frontend/features/opportunity/presentation/screens/opportunity_detail_screen.dart';

class DemoListScreen extends StatefulWidget {
  final Function(int)? onTabChanged;
  const DemoListScreen({super.key, this.onTabChanged});

  @override
  State<DemoListScreen> createState() => _DemoListScreenState();
}

class _DemoListScreenState extends State<DemoListScreen> {
  final TextEditingController _search = TextEditingController();
  late final OpportunityService _service;

  final List<_Category> _categories = const [
    _Category(icon: Icons.school_rounded, name: 'Becas', color: Color(0xFF3B82F6)),
    _Category(icon: Icons.work_rounded, name: 'Empleo', color: Color(0xFF10B981)),
    _Category(icon: Icons.biotech_rounded, name: 'Investigación', color: Color(0xFF8B5CF6)),
    _Category(icon: Icons.volunteer_activism_rounded, name: 'Voluntariado', color: Color(0xFFEF4444)),
  ];

  String? _selectedCategory;

  // Destacadas / generales
  List<Opportunity> _all = [];
  List<Opportunity> _filtered = [];
  bool _loading = true;
  String? _error;

  // Expiring soon
  List<Opportunity> _expiringSoon = [];
  List<Opportunity> _expiringFiltered = [];
  bool _loadingExpiring = true;
  String? _expiringError;
  /*
  @override
  void initState() {
    super.initState();
    
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    _service = OpportunityService(
      baseUrl: isAndroid
          ? 'http://10.0.2.2:8000'   // ANDROID EMULADOR
          : 'http://127.0.0.1:8000', // WEB / iOS / DESKTOP
    );

    _search.addListener(_applyFilters);

    _fetchGeneral();
    _fetchExpiringSoon();
  }
  */
  @override
  void initState() {
    super.initState();

    _service = OpportunityService(); // usa resolveBaseUrl()

    _search.addListener(_applyFilters);

    _fetchGeneral();
    _fetchExpiringSoon();
  }


  @override
  void dispose() {
    _search.removeListener(_applyFilters);
    _search.dispose();
    super.dispose();
  }

  // ---------------- FETCH GENERAL (DESTACADAS) ----------------

  Future<void> _fetchGeneral() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _service.listGeneral();
      _all = list;
      _applyFilters();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _filtered = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // ---------------- FETCH EXPIRING SOON ----------------

  Future<void> _fetchExpiringSoon() async {
    setState(() {
      _loadingExpiring = true;
      _expiringError = null;
    });

    try {
      final list = await _service.listExpiringSoon(limit: 10, daysAhead: 30);
      _expiringSoon = list;
      _applyFilters();
    } catch (e) {
      setState(() {
        _expiringError = e.toString();
        _expiringSoon = [];
        _expiringFiltered = [];
      });
    } finally {
      setState(() {
        _loadingExpiring = false;
      });
    }
  }

  // ---------------- HELPERS ----------------

  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String? _mapBackendCategoryToUI(String? backendCategory) {
    if (backendCategory == null) return null;
    final lower = backendCategory.toLowerCase().trim();
    if (lower == 'empleo') return 'Empleo';
    if (lower == 'voluntariado') return 'Voluntariado';
    if (lower == 'investigación' || lower == 'investigacion') return 'Investigación';
    if (lower == 'paec' || lower == 'beca' || lower == 'becas') return 'Becas';
    return _capitalize(backendCategory);
  }

  String _locationText(Opportunity o) {
    if (o.locations.isEmpty) return '—';
    final l = o.locations.first;
    final parts = <String>[
      if (l.city != null && l.city!.trim().isNotEmpty) l.city!.trim(),
      if (l.region != null && l.region!.trim().isNotEmpty) l.region!.trim(),
      if (l.country != null && l.country!.trim().isNotEmpty) l.country!.trim(),
    ];
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

  // ---------------- FILTROS (APLICA A AMBAS SECCIONES) ----------------

  void _applyFilters() {
    final q = _search.text.trim().toLowerCase();

    setState(() {
      // ---- Destacadas ----
      final byCat = _selectedCategory == null
          ? _all
          : _all.where((o) => _mapBackendCategoryToUI(o.category) == _selectedCategory).toList();

      _filtered = q.isEmpty
          ? byCat
          : byCat
              .where((o) =>
                  o.title.toLowerCase().contains(q) ||
                  (o.description ?? '').toLowerCase().contains(q) ||
                  (_mapBackendCategoryToUI(o.category) ?? '').toLowerCase().contains(q) ||
                  _locationText(o).toLowerCase().contains(q))
              .toList();

      // ---- Expiring soon ----
      final byCatExp = _selectedCategory == null
          ? _expiringSoon
          : _expiringSoon
              .where((o) => _mapBackendCategoryToUI(o.category) == _selectedCategory)
              .toList();

      _expiringFiltered = q.isEmpty
          ? byCatExp
          : byCatExp
              .where((o) =>
                  o.title.toLowerCase().contains(q) ||
                  (o.description ?? '').toLowerCase().contains(q) ||
                  (_mapBackendCategoryToUI(o.category) ?? '').toLowerCase().contains(q) ||
                  _locationText(o).toLowerCase().contains(q))
              .toList();
    });
  }

  void _toggleCategory(String name) {
    if (_selectedCategory == name) {
      _selectedCategory = null;
    } else {
      _selectedCategory = name;
    }
    _applyFilters();
  }

  // ---------------- DETALLE ----------------

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
      benefits: const [],
      requirements: const [],
      howToApply: const [],
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

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    Widget content;

    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      // *** Estado de error con botón Reintentar ***
      content = Center(
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
                onPressed: () {
                  _fetchGeneral();
                  _fetchExpiringSoon();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else {
      content = CustomScrollView(
        slivers: [
          // HEADER + NAV + CATEGORÍAS + TÍTULO DESTACADAS
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WebMainNavbar(
                      currentIndex: 0,
                      onTabChanged: widget.onTabChanged ?? (index) {},
                    ),
                  ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categorías populares',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isWideWeb
                      ? Row(
                          children: _categories
                              .map(
                                (c) => Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: SizedBox(
                                    width: 160,
                                    height: 56,
                                    child: CategorySquareCard(
                                      icon: c.icon,
                                      label: c.name,
                                      color: c.color,
                                      onTap: () => _toggleCategory(c.name),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final c = _categories[i];
                              return SizedBox(
                                width: 140,
                                child: CategorySquareCard(
                                  icon: c.icon,
                                  label: c.name,
                                  color: c.color,
                                  onTap: () => _toggleCategory(c.name),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Convocatorias destacadas',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // DESTACADAS
          if (isWideWeb)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final it = _filtered[i];
                    final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                    final organization = _capitalize(mappedCat);
                    return OpportunityCard(
                      title: it.title,
                      organization: organization,
                      category: mappedCat,
                      deadline: it.deadline,
                      modality: _capitalize(it.modality),
                      onTap: () => _navigateToDetail(it),
                    );
                  },
                  childCount: _filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8,
                ),
              ),
            )
          else
            SliverList.separated(
              itemBuilder: (_, i) {
                final it = _filtered[i];
                final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                final organization =
                    _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OpportunityCard(
                    title: it.title,
                    organization: organization,
                    category: mappedCat,
                    deadline: it.deadline,
                    modality: _capitalize(it.modality),
                    onTap: () => _navigateToDetail(it),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _filtered.length,
            ),

          if (_filtered.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text('No se encontraron convocatorias'),
                ),
              ),
            ),

          // ---------- SECCIÓN: CONVOCATORIAS A EXPIRAR ----------
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Convocatorias a expirar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          if (_loadingExpiring)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_expiringError != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No se pudieron cargar las convocatorias a punto de expirar.',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton.icon(
                      onPressed: _fetchExpiringSoon,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text(
                        'Reintentar cargar esta sección',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_expiringFiltered.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text('No hay convocatorias próximas a expirar'),
                ),
              ),
            )
          else if (isWideWeb)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final it = _expiringFiltered[i];
                    final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                    final organization =
                        _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
                    return OpportunityCard(
                      title: it.title,
                      organization: organization,
                      category: mappedCat,
                      deadline: it.deadline,
                      modality: _capitalize(it.modality),
                      onTap: () => _navigateToDetail(it),
                    );
                  },
                  childCount: _expiringFiltered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8,
                ),
              ),
            )
          else
            SliverList.separated(
              itemBuilder: (_, i) {
                final it = _expiringFiltered[i];
                final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                final organization =
                    _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OpportunityCard(
                    title: it.title,
                    organization: organization,
                    category: mappedCat,
                    deadline: it.deadline,
                    modality: _capitalize(it.modality),
                    onTap: () => _navigateToDetail(it),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _expiringFiltered.length,
            ),

          // FOOTER
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: AppFooter(),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final bool isWeb = identical(0, 0.0);
            final bool isWideWeb = isWeb && constraints.maxWidth > 800;
            if (!isWideWeb) return content;
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 950),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Category {
  final IconData icon;
  final String name;
  final Color color;
  const _Category({required this.icon, required this.name, required this.color});
}


/*
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

import 'package:kaleo_frontend/core/widgets/category_square_card.dart';
import 'package:kaleo_frontend/core/widgets/app_header.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';
import 'package:kaleo_frontend/core/widgets/app_footer.dart';
import 'package:kaleo_frontend/core/widgets/opportunity_card.dart';

import 'package:kaleo_frontend/features/opportunity/data/opportunity_service.dart';
import 'package:kaleo_frontend/features/opportunity/data/opportunity_model.dart';
import 'package:kaleo_frontend/features/opportunity/presentation/screens/opportunity_detail_screen.dart';

class DemoListScreen extends StatefulWidget {
  final Function(int)? onTabChanged;
  const DemoListScreen({super.key, this.onTabChanged});

  @override
  State<DemoListScreen> createState() => _DemoListScreenState();
}

class _DemoListScreenState extends State<DemoListScreen> {
  final TextEditingController _search = TextEditingController();
  late final OpportunityService _service;

  final List<_Category> _categories = const [
    _Category(icon: Icons.school_rounded, name: 'Becas', color: Color(0xFF3B82F6)),
    _Category(icon: Icons.work_rounded, name: 'Empleo', color: Color(0xFF10B981)),
    _Category(icon: Icons.biotech_rounded, name: 'Investigación', color: Color(0xFF8B5CF6)),
    _Category(icon: Icons.volunteer_activism_rounded, name: 'Voluntariado', color: Color(0xFFEF4444)),
  ];

  String? _selectedCategory;

  // Destacadas / generales
  List<Opportunity> _all = [];
  List<Opportunity> _filtered = [];
  bool _loading = true;
  String? _error;

  // Expiring soon
  List<Opportunity> _expiringSoon = [];
  List<Opportunity> _expiringFiltered = [];
  bool _loadingExpiring = true;
  String? _expiringError;

  @override
  void initState() {
    super.initState();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    _service = OpportunityService(
      baseUrl: isAndroid
          ? 'http://10.0.2.2:8000'   // ANDROID EMULATOR
          : 'http://127.0.0.1:8000', // WEB / iOS / DESKTOP
    );

    _search.addListener(_applyFilters);

    _fetchGeneral();
    _fetchExpiringSoon();
  }

  @override
  void dispose() {
    _search.removeListener(_applyFilters);
    _search.dispose();
    super.dispose();
  }

  // ---------------- FETCH GENERAL (DESTACADAS) ----------------

  Future<void> _fetchGeneral() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final list = await _service.listGeneral();
      _all = list;
      _applyFilters(); // recalcula _filtered y _expiringFiltered
    } catch (e) {
      setState(() {
        _error = e.toString();
        _filtered = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  // ---------------- FETCH EXPIRING SOON ----------------

  Future<void> _fetchExpiringSoon() async {
    setState(() {
      _loadingExpiring = true;
      _expiringError = null;
    });

    try {
      final list = await _service.listExpiringSoon(limit: 10, daysAhead: 30);
      _expiringSoon = list;
      _applyFilters(); // aplica filtros también a expiring
    } catch (e) {
      setState(() {
        _expiringError = e.toString();
        _expiringSoon = [];
        _expiringFiltered = [];
      });
    } finally {
      setState(() {
        _loadingExpiring = false;
      });
    }
  }

  // ---------------- HELPERS ----------------

  String _capitalize(String? s) {
    if (s == null || s.isEmpty) return '';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String? _mapBackendCategoryToUI(String? backendCategory) {
    if (backendCategory == null) return null;
    final lower = backendCategory.toLowerCase().trim();
    if (lower == 'empleo') return 'Empleo';
    if (lower == 'voluntariado') return 'Voluntariado';
    if (lower == 'investigación' || lower == 'investigacion') return 'Investigación';
    if (lower == 'paec' || lower == 'beca' || lower == 'becas') return 'Becas';
    return _capitalize(backendCategory);
  }

  String _locationText(Opportunity o) {
    if (o.locations.isEmpty) return '—';
    final l = o.locations.first;
    final parts = <String>[
      if (l.city != null && l.city!.trim().isNotEmpty) l.city!.trim(),
      if (l.region != null && l.region!.trim().isNotEmpty) l.region!.trim(),
      if (l.country != null && l.country!.trim().isNotEmpty) l.country!.trim(),
    ];
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

  // ---------------- FILTROS (APLICA A AMBAS SECCIONES) ----------------

  void _applyFilters() {
    final q = _search.text.trim().toLowerCase();

    setState(() {
      // ---- Destacadas ----
      final byCat = _selectedCategory == null
          ? _all
          : _all.where((o) => _mapBackendCategoryToUI(o.category) == _selectedCategory).toList();

      _filtered = q.isEmpty
          ? byCat
          : byCat
              .where((o) =>
                  o.title.toLowerCase().contains(q) ||
                  (o.description ?? '').toLowerCase().contains(q) ||
                  (_mapBackendCategoryToUI(o.category) ?? '').toLowerCase().contains(q) ||
                  _locationText(o).toLowerCase().contains(q))
              .toList();

      // ---- Expiring soon ----
      final byCatExp = _selectedCategory == null
          ? _expiringSoon
          : _expiringSoon
              .where((o) => _mapBackendCategoryToUI(o.category) == _selectedCategory)
              .toList();

      _expiringFiltered = q.isEmpty
          ? byCatExp
          : byCatExp
              .where((o) =>
                  o.title.toLowerCase().contains(q) ||
                  (o.description ?? '').toLowerCase().contains(q) ||
                  (_mapBackendCategoryToUI(o.category) ?? '').toLowerCase().contains(q) ||
                  _locationText(o).toLowerCase().contains(q))
              .toList();
    });
  }

  void _toggleCategory(String name) {
    // Cambia categoría seleccionada y reaplica filtros a ambas listas
    if (_selectedCategory == name) {
      _selectedCategory = null;
    } else {
      _selectedCategory = name;
    }
    _applyFilters();
  }

  // ---------------- DETALLE ----------------

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
      benefits: const [],
      requirements: const [],
      howToApply: const [],
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

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    Widget content;

    if (_loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Error cargando datos:\n$_error'),
        ),
      );
    } else {
      content = CustomScrollView(
        slivers: [
          // HEADER + NAV + CATEGORÍAS + TÍTULO DESTACADAS
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: WebMainNavbar(
                      currentIndex: 0,
                      onTabChanged: widget.onTabChanged ?? (index) {},
                    ),
                  ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Categorías populares',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isWideWeb
                      ? Row(
                          children: _categories
                              .map(
                                (c) => Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: SizedBox(
                                    width: 160,
                                    height: 56,
                                    child: CategorySquareCard(
                                      icon: c.icon,
                                      label: c.name,
                                      color: c.color,
                                      onTap: () => _toggleCategory(c.name),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : SizedBox(
                          height: 72,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, i) {
                              final c = _categories[i];
                              return SizedBox(
                                width: 140,
                                child: CategorySquareCard(
                                  icon: c.icon,
                                  label: c.name,
                                  color: c.color,
                                  onTap: () => _toggleCategory(c.name),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Convocatorias destacadas',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // DESTACADAS (GRID O LIST)
          if (isWideWeb)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final it = _filtered[i];
                    final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                    final organization = _capitalize(mappedCat);
                    //final locText = _locationText(it);
                    return OpportunityCard(
                      title: it.title,
                      organization: organization,
                      category: mappedCat,
                      deadline: it.deadline,
                      //location: locText,
                      modality: _capitalize(it.modality),
                      onTap: () => _navigateToDetail(it),
                    );
                  },
                  childCount: _filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8,
                ),
              ),
            )
          else
            SliverList.separated(
              itemBuilder: (_, i) {
                final it = _filtered[i];
                final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                final organization = _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
                //final locText = _locationText(it);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _filtered.length,
            ),

          if (_filtered.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No se encontraron convocatorias')),
              ),
            ),

          // ---------- SECCIÓN: CONVOCATORIAS A EXPIRAR ----------
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Convocatorias a expirar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          if (_loadingExpiring)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          else if (_expiringError != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'No se pudieron cargar las convocatorias a punto de expirar.',
                  style: TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            )
            /*
          else if (_expiringFiltered.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  'No hay convocatorias próximas a expirar que coincidan con los filtros.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
            )

            */
          else if (_expiringFiltered.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No se encontraron convocatorias')),
              ),
            )
          
    
          else if (isWideWeb)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final it = _expiringFiltered[i];
                    final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                    //final locText = _locationText(it);
                    final organization = _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
                    return OpportunityCard(
                      title: it.title,
                      organization: organization,
                      category: mappedCat,
                      deadline: it.deadline,
                      //location: locText,
                      modality: _capitalize(it.modality),
                      onTap: () => _navigateToDetail(it),
                    );
                  },
                  childCount: _expiringFiltered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8,
                ),
              ),
            )
          else
            SliverList.separated(
              itemBuilder: (_, i) {
                final it = _expiringFiltered[i];
                final mappedCat = _mapBackendCategoryToUI(it.category) ?? '—';
                //final locText = _locationText(it);
                final organization = _hostFromUrl(it.officialUrl) ?? _capitalize(mappedCat);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: _expiringFiltered.length,
            ),

          // FOOTER
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: AppFooter(),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final bool isWeb = identical(0, 0.0);
            final bool isWideWeb = isWeb && constraints.maxWidth > 800;
            if (!isWideWeb) return content;
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 950),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Category {
  final IconData icon;
  final String name;
  final Color color;
  const _Category({required this.icon, required this.name, required this.color});
}
*/