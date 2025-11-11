import 'dart:convert';

class Opportunity {
  final int id;
  final int? sourceId;
  final String title;
  final String? description;
  final String? category;
  final String? modality;
  final DateTime? deadline;      // puede venir "2025-07-31" o null
  final DateTime? publishedAt;   // puede venir "2025-09-21" o null
  final String? currency;
  final num? amountMin;
  final num? amountMax;
  final String? officialUrl;
  final String? hashDedupe;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OppLocation> locations;

  Opportunity({
    required this.id,
    this.sourceId,
    required this.title,
    this.description,
    this.category,
    this.modality,
    this.deadline,
    this.publishedAt,
    this.currency,
    this.amountMin,
    this.amountMax,
    this.officialUrl,
    this.hashDedupe,
    this.createdAt,
    this.updatedAt,
    required this.locations,
  });

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    // soporta "YYYY-MM-DD" y "YYYY-MM-DDTHH:mm:ss"
    try {
      if (v is String) {
        return DateTime.tryParse(v);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  factory Opportunity.fromMap(Map<String, dynamic> map) {
    return Opportunity(
      id: map['id'] as int,
      sourceId: map['source_id'] as int?,
      title: (map['title'] ?? '').toString(),
      description: map['description'] as String?,
      category: map['category']?.toString(),
      modality: map['modality']?.toString(),
      deadline: _parseDate(map['deadline']),
      publishedAt: _parseDate(map['published_at']),
      currency: map['currency']?.toString(),
      amountMin: (map['amount_min'] as num?) ?? 0,
      amountMax: (map['amount_max'] as num?) ?? 0,
      officialUrl: map['official_url']?.toString(),
      hashDedupe: map['hash_dedupe']?.toString(),
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
      locations: (map['locations'] as List<dynamic>? ?? [])
          .map((e) => OppLocation.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory Opportunity.fromJson(String source) =>
      Opportunity.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OppLocation {
  final int id;
  final String? city;
  final String? region;
  final String? country;

  OppLocation({
    required this.id,
    this.city,
    this.region,
    this.country,
  });

  factory OppLocation.fromMap(Map<String, dynamic> map) {
    return OppLocation(
      id: map['id'] as int,
      city: map['city']?.toString(),
      region: map['region']?.toString(),
      country: map['country']?.toString(),
    );
  }
}
