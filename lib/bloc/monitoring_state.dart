import 'package:equatable/equatable.dart';
import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';

abstract class MonitoringState extends Equatable {
  const MonitoringState();

  @override
  List<Object?> get props => [];
}

class MonitoringInitial extends MonitoringState {}

class MonitoringLoading extends MonitoringState {}

class MonitoringLoaded extends MonitoringState {
  final Map<MonitoringType, List<MonitoringData>> data;
  final bool isKilowatts;

  const MonitoringLoaded({required this.data, required this.isKilowatts});

  @override
  List<Object?> get props => [data, isKilowatts];
}

class MonitoringError extends MonitoringState {
  final String message;

  const MonitoringError({required this.message});

  @override
  List<Object?> get props => [message];
}
