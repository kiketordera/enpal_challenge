import 'package:equatable/equatable.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';

abstract class MonitoringEvent extends Equatable {
  const MonitoringEvent();

  @override
  List<Object?> get props => [];
}

class FetchMonitoringData extends MonitoringEvent {
  final String date;
  final MonitoringType type;

  const FetchMonitoringData({required this.date, required this.type});

  @override
  List<Object?> get props => [date, type];
}

class ClearMonitoringCache extends MonitoringEvent {}