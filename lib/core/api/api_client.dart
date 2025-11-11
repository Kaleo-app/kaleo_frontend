import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> getPagedOpportunities({int page = 1, int pageSize = 10}) async {
    final uri = Uri.parse('$baseUrl/opportunities/paged?page=$page&page_size=$pageSize');
    final res = await _client.get(uri);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('HTTP ${res.statusCode}: ${res.body}');
  }
}


