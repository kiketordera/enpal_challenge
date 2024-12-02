import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final String baseUrl;
  final Map<String, List<MonitoringData>> _cache = {};

  MonitoringRepositoryImpl({required this.baseUrl});

  @override
  Future<List<MonitoringData>> fetchMonitoringData(
      String date, MonitoringType type) async {
    final cacheKey = '$type-$date';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final url = Uri.parse('$baseUrl/monitoring?date=$date&type=$type');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final data =
          jsonData.map((json) => MonitoringData.fromJson(json)).toList();
      _cache[cacheKey] = data;
      return data;
    } else {
      throw Exception('Failed to fetch monitoring data');
    }
  }

  @override
  void clearCache() {
    _cache.clear();
  }
}
