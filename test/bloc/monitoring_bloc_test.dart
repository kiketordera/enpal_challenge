import 'package:bloc_test/bloc_test.dart';
import 'package:enpal_challenge/bloc/monitoring_bloc.dart';
import 'package:enpal_challenge/bloc/monitoring_event.dart';
import 'package:enpal_challenge/bloc/monitoring_state.dart';
import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late MonitoringBloc bloc;
  late MockMonitoringRepository mockRepo;

  setUp(() {
    mockRepo = MockMonitoringRepository();
    bloc = MonitoringBloc(repository: mockRepo);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is MonitoringInitial', () {
    expect(bloc.state, equals(MonitoringInitial()));
  });

  blocTest<MonitoringBloc, MonitoringState>(
    'emits MonitoringLoading then MonitoringLoaded on successful fetch',
    build: () {
      when(() => mockRepo.fetchMonitoringData('2024-12-10', MonitoringType.solar))
          .thenAnswer((_) async => [
                MonitoringData(timestamp: DateTime.parse('2024-12-10T00:00:00Z'), value: 100),
                MonitoringData(timestamp: DateTime.parse('2024-12-10T01:00:00Z'), value: 200),
              ]);
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMonitoringData(date: '2024-12-10', type: MonitoringType.solar)),
    expect: () => [
      MonitoringLoading(),
      // Note: isKilowatts defaults to false
      isA<MonitoringLoaded>().having((state) => state.data[MonitoringType.solar]!.length, 'data length', 2)
    ],
  );

  blocTest<MonitoringBloc, MonitoringState>(
    'emits MonitoringError on failed fetch',
    build: () {
      when(() => mockRepo.fetchMonitoringData('2024-12-10', MonitoringType.house))
          .thenThrow(Exception('Failed to fetch monitoring data'));
      return bloc;
    },
    act: (bloc) => bloc.add(const FetchMonitoringData(date: '2024-12-10', type: MonitoringType.house)),
    expect: () => [
      MonitoringLoading(),
      isA<MonitoringError>()
          .having((e) => e.message, 'message', contains('Failed to fetch')),
    ],
  );

  blocTest<MonitoringBloc, MonitoringState>(
    'ToggleUnit changes the isKilowatts flag in MonitoringLoaded',
    build: () {
      when(() => mockRepo.fetchMonitoringData('2024-12-10', MonitoringType.battery))
          .thenAnswer((_) async => [
                MonitoringData(timestamp: DateTime.parse('2024-12-10T00:00:00Z'), value: 5000)
              ]);
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const FetchMonitoringData(date: '2024-12-10', type: MonitoringType.battery));
      await Future.delayed(const Duration(milliseconds: 100));
      bloc.add(const ToggleUnit());
    },
    expect: () => [
      MonitoringLoading(),
      predicate<MonitoringState>((state) =>
          state is MonitoringLoaded && !state.isKilowatts),
      predicate<MonitoringState>((state) =>
          state is MonitoringLoaded && state.isKilowatts),
    ],
  );

  blocTest<MonitoringBloc, MonitoringState>(
    'ClearMonitoringCache returns to MonitoringInitial',
    build: () => bloc,
    act: (bloc) => bloc.add(ClearMonitoringCache()),
    expect: () => [
      MonitoringInitial(),
    ],
  );
}