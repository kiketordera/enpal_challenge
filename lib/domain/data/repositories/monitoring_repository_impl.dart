import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final String baseUrl;

  MonitoringRepositoryImpl({required this.baseUrl});

  @override
  Future<List<MonitoringData>> fetchMonitoringData(
      String date, MonitoringType type) async {
    final url = Uri.parse('$baseUrl/monitoring?date=$date&type=$type');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => MonitoringData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch monitoring data');
    }
  }
}
