import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';

enum MonitoringType { solar, house, battery }

abstract class MonitoringRepository {
  Future<List<MonitoringData>> fetchMonitoringData(
      String date, MonitoringType type);
}
