
import 'package:enpal_challenge/bloc/monitoring_event.dart';
import 'package:enpal_challenge/bloc/monitoring_state.dart';
import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitoringBloc extends Bloc<MonitoringEvent, MonitoringState> {
  final MonitoringRepository repository;
  final Map<MonitoringType, List<MonitoringData>> _dataMap = {};

  MonitoringBloc({required this.repository}) : super(MonitoringInitial()) {
    on<FetchMonitoringData>(_onFetchMonitoringData);
    on<ClearMonitoringCache>(_onClearMonitoringCache);
  }

  Future<void> _onFetchMonitoringData(
      FetchMonitoringData event, Emitter<MonitoringState> emit) async {
    emit(MonitoringLoading());
    try {
      final data = await repository.fetchMonitoringData(event.date, event.type);
      _dataMap[event.type] = data;
      emit(MonitoringLoaded(data: Map.from(_dataMap)));
    } catch (e) {
      emit(MonitoringError(message: e.toString()));
    }
  }

  void _onClearMonitoringCache(
      ClearMonitoringCache event, Emitter<MonitoringState> emit) {
    repository.clearCache();
    _dataMap.clear();
    emit(MonitoringInitial());
  }
}