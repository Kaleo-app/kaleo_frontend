import 'dart:convert';
import 'package:http/http.dart' as http;
import 'opportunity_model.dart';
import 'package:kaleo_frontend/core/env.dart';

const Duration _defaultTimeout = Duration(seconds: 20);

class PaginatedOpportunities {
  final int total;
  final int page;
  final int pageSize;
  final List<Opportunity> items;

  PaginatedOpportunities({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.items,
  });

  factory PaginatedOpportunities.fromMap(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    int _toInt(dynamic v, int fallback) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    final total = _toInt(json['total'], 0);
    final page = _toInt(json['page'], 1);

    int pageSize = 10;
    if (json.containsKey('page_size')) {
      pageSize = _toInt(json['page_size'], 10);
    } else if (json.containsKey('pageSize')) {
      pageSize = _toInt(json['pageSize'], 10);
    }

    return PaginatedOpportunities(
      total: total,
      page: page,
      pageSize: pageSize,
      items: rawItems
          .map((e) => Opportunity.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OpportunityService {
  final String baseUrl;

  OpportunityService({String? baseUrl})
      : baseUrl = (baseUrl ?? resolveBaseUrl())
            .trim()
            .replaceAll(RegExp(r'/+$'), '');

  Uri _build(String path) {
    final cleanPath = path.trim().replaceAll(RegExp(r'^/+'), '');
    return Uri.parse('$baseUrl/$cleanPath');
  }

  /// Convocatorias generales / destacadas
  Future<List<Opportunity>> listGeneral() async {
    final uri = _build('opportunities/general');
    final resp = await http.get(uri).timeout(_defaultTimeout);

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    final data = json.decode(resp.body);
    if (data is! List) return [];
    return data.map<Opportunity>((e) => Opportunity.fromMap(e)).toList();
  }

  /// Listado paginado de oportunidades (usa /opportunities/paged)
  Future<PaginatedOpportunities> listPaged({
    required int page,
    required int pageSize,
    String? query,
    String? category,
    String? region,
    String? city,
    String? modality,
  }) async {
    final baseUri = _build('opportunities/paged');

    final params = <String, String>{
      'page': '$page',
      'page_size': '$pageSize',
      if (query != null && query.trim().isNotEmpty) 'query': query.trim(),
      if (category != null && category.trim().isNotEmpty) 'category': category.trim(),
      if (region != null && region.trim().isNotEmpty) 'region': region.trim(),
      if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
      if (modality != null && modality.trim().isNotEmpty) 'modality': modality.trim(),
    };

    final uri = baseUri.replace(queryParameters: params);

    final resp = await http.get(uri).timeout(_defaultTimeout);

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode} en paged: ${resp.body}');
    }

    final data = json.decode(resp.body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Formato inesperado en /opportunities/paged');
    }

    return PaginatedOpportunities.fromMap(data);
  }

  /// Convocatorias a expirar pronto
  Future<List<Opportunity>> listExpiringSoon({
    int limit = 10,
    int daysAhead = 30,
  }) async {
    final uri = _build(
      'opportunities/expiring-soon?limit=$limit&days_ahead=$daysAhead',
    );

    final resp = await http.get(uri).timeout(_defaultTimeout);

    if (resp.statusCode != 200) {
      throw Exception(
        'HTTP ${resp.statusCode} en expiring-soon: ${resp.body}',
      );
    }

    final data = json.decode(resp.body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Formato inesperado en expiring-soon');
    }

    if (data['status'] != 'success') {
      throw Exception(
        'Backend expiring-soon: ${data['details'] ?? 'Error desconocido'}',
      );
    }

    final List<dynamic> items = data['opportunities'] ?? [];
    return items.map<Opportunity>((e) => Opportunity.fromMap(e)).toList();
  }

  /// Detalle por id (normaliza a int y llama /opportunities/{id})
  Future<Map<String, dynamic>> getDetailRaw(dynamic id) async {
    final parsedId = int.tryParse(id.toString());
    if (parsedId == null) {
      throw Exception('ID de oportunidad inválido: $id');
    }

    final uri = _build('opportunities/$parsedId');
    final resp = await http.get(uri).timeout(_defaultTimeout);

    if (resp.statusCode == 404) {
      throw Exception('No se encontró la oportunidad (#$parsedId)');
    }
    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    return json.decode(resp.body) as Map<String, dynamic>;
  }
}

/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'opportunity_model.dart';
import 'package:kaleo_frontend/core/env.dart';

class PaginatedOpportunities {
  final int total;
  final int page;
  final int pageSize;
  final List<Opportunity> items;

  PaginatedOpportunities({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.items,
  });

  factory PaginatedOpportunities.fromMap(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    int _toInt(dynamic v, int fallback) {
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    final total = _toInt(json['total'], 0);
    final page = _toInt(json['page'], 1);

    int pageSize = 10;
    if (json.containsKey('page_size')) {
      pageSize = _toInt(json['page_size'], 10);
    } else if (json.containsKey('pageSize')) {
      pageSize = _toInt(json['pageSize'], 10);
    }

    return PaginatedOpportunities(
      total: total,
      page: page,
      pageSize: pageSize,
      items: rawItems
          .map((e) => Opportunity.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OpportunityService {
  final String baseUrl;

  OpportunityService({String? baseUrl})
      : baseUrl = (baseUrl ?? resolveBaseUrl())
            .trim()
            .replaceAll(RegExp(r'/+$'), '');

  Uri _build(String path) {
    final cleanPath = path.trim().replaceAll(RegExp(r'^/+'), '');
    return Uri.parse('$baseUrl/$cleanPath');
  }

  /// Convocatorias generales / destacadas (lo puedes seguir usando donde haga falta)
  Future<List<Opportunity>> listGeneral() async {
    final uri = _build('opportunities/general');
    final resp = await http.get(uri).timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    final data = json.decode(resp.body);
    if (data is! List) return [];
    return data.map<Opportunity>((e) => Opportunity.fromMap(e)).toList();
  }

  /// Listado paginado de oportunidades (usa /opportunities/paged)
  Future<PaginatedOpportunities> listPaged({
    required int page,
    required int pageSize,
    String? query,
    String? category,
    String? region,
    String? city,
    String? modality,
  }) async {
    final baseUri = _build('opportunities/paged');

    final params = <String, String>{
      'page': '$page',
      'page_size': '$pageSize',
      if (query != null && query.trim().isNotEmpty) 'query': query.trim(),
      if (category != null && category.trim().isNotEmpty) 'category': category.trim(),
      if (region != null && region.trim().isNotEmpty) 'region': region.trim(),
      if (city != null && city.trim().isNotEmpty) 'city': city.trim(),
      if (modality != null && modality.trim().isNotEmpty) 'modality': modality.trim(),
    };

    final uri = baseUri.replace(queryParameters: params);

    final resp = await http.get(uri).timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw Exception(
        'HTTP ${resp.statusCode} en paged: ${resp.body}',
      );
    }

    final data = json.decode(resp.body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Formato inesperado en /opportunities/paged');
    }

    return PaginatedOpportunities.fromMap(data);
  }

  /// Convocatorias a expirar pronto
  Future<List<Opportunity>> listExpiringSoon({
    int limit = 10,
    int daysAhead = 30,
  }) async {
    final uri = _build(
      'opportunities/expiring-soon?limit=$limit&days_ahead=$daysAhead',
    );

    final resp = await http.get(uri).timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw Exception(
        'HTTP ${resp.statusCode} en expiring-soon: ${resp.body}',
      );
    }

    final data = json.decode(resp.body);
    if (data is! Map<String, dynamic>) {
      throw Exception('Formato inesperado en expiring-soon');
    }

    if (data['status'] != 'success') {
      throw Exception(
        'Backend expiring-soon: ${data['details'] ?? 'Error desconocido'}',
      );
    }

    final List<dynamic> items = data['opportunities'] ?? [];
    return items.map<Opportunity>((e) => Opportunity.fromMap(e)).toList();
  }

  /// Detalle por id (normaliza a int y llama /opportunities/{id})
  Future<Map<String, dynamic>> getDetailRaw(dynamic id) async {
    final parsedId = int.tryParse(id.toString());
    if (parsedId == null) {
      throw Exception('ID de oportunidad inválido: $id');
    }

    final uri = _build('opportunities/$parsedId');
    final resp = await http.get(uri).timeout(const Duration(seconds: 15));

    if (resp.statusCode == 404) {
      throw Exception('No se encontró la oportunidad (#$parsedId)');
    }
    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    return json.decode(resp.body) as Map<String, dynamic>;
  }
}

*/