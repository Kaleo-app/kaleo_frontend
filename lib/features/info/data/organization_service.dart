import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaleo_frontend/core/env.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class Organization {
  final int id;
  final String name;
  final String? type;
  final String? url;
  final String? region;

  Organization({
    required this.id,
    required this.name,
    this.type,
    this.url,
    this.region,
  });

  factory Organization.fromMap(Map<String, dynamic> map) {
    return Organization(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as String?,
      url: map['url'] as String?,
      region: map['region'] as String?,
    );
  }
}

class OrganizationType {
  final String type;
  final List<Organization> organizations;

  OrganizationType({
    required this.type,
    required this.organizations,
  });

  factory OrganizationType.fromMap(Map<String, dynamic> map) {
    return OrganizationType(
      type: map['type'] as String,
      organizations: (map['organizations'] as List<dynamic>)
          .map((org) => Organization.fromMap(org as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OrganizationService {
  final String baseUrl;
  
  OrganizationService({String? baseUrl})
      : baseUrl = (baseUrl ?? resolveBaseUrl()).trim().replaceAll(RegExp(r'/+$'), '');

  Uri _build(String path) {
    final cleanPath = path.trim().replaceAll(RegExp(r'^/+'), '');
    return Uri.parse('$baseUrl/$cleanPath');
  }

  Future<List<OrganizationType>> listOrganizationsByType() async {
    final uri = _build('sources/organizations');
    
    try {
      final resp = await http.get(uri).timeout(const Duration(seconds: 15));
      
      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
      }
      
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final types = data['types'] as List<dynamic>? ?? [];
      
      return types
          .map((type) => OrganizationType.fromMap(type as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('Connection refused') ||
          e.toString().contains('SocketException')) {
        throw Exception('No se puede conectar al backend. Verifica que esté corriendo en $baseUrl');
      }
      rethrow;
    }
  }
}