import 'package:enpal_challenge/bloc/monitoring_bloc.dart';
import 'package:enpal_challenge/bloc/monitoring_event.dart';
import 'package:enpal_challenge/bloc/monitoring_state.dart';
import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:enpal_challenge/presentation/pages/chart_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockMonitoringBloc extends Mock implements MonitoringBloc {}

class FakeMonitoringEvent extends Fake implements MonitoringEvent {}

class FakeMonitoringState extends Fake implements MonitoringState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMonitoringEvent());
    registerFallbackValue(FakeMonitoringState());
  });

  testWidgets('shows loading indicator when state is MonitoringLoading',
      (tester) async {
    final mockBloc = MockMonitoringBloc();

    when(() => mockBloc.state).thenReturn(MonitoringLoading());
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(MonitoringLoading()));

    await tester.pumpWidget(
      BlocProvider<MonitoringBloc>.value(
        value: mockBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: DataPoints(date: '2024-12-10', type: MonitoringType.solar),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows chart when data is loaded', (tester) async {
    final mockBloc = MockMonitoringBloc();
    final data = [
      MonitoringData(
          timestamp: DateTime.parse('2024-12-10T00:00:00Z'), value: 1000),
      MonitoringData(
          timestamp: DateTime.parse('2024-12-10T01:00:00Z'), value: 2000),
    ];
    final loadedState = MonitoringLoaded(
      data: {
        MonitoringType.solar: data,
        MonitoringType.house: [],
        MonitoringType.battery: []
      },
      isKilowatts: false,
    );

    when(() => mockBloc.state).thenReturn(loadedState);
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(loadedState));

    await tester.pumpWidget(
      BlocProvider<MonitoringBloc>.value(
        value: mockBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: DataPoints(date: '2024-12-10', type: MonitoringType.solar),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No data available'), findsNothing);
    expect(find.byType(LineChart), findsOneWidget);
  });

  testWidgets('shows error message on MonitoringError', (tester) async {
    final mockBloc = MockMonitoringBloc();
    const errorState = MonitoringError(message: 'Error fetching data');

    when(() => mockBloc.state).thenReturn(errorState);
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(errorState));

    await tester.pumpWidget(
      BlocProvider<MonitoringBloc>.value(
        value: mockBloc,
        child: const MaterialApp(
          home: Scaffold(
            body: DataPoints(date: '2024-12-10', type: MonitoringType.solar),
          ),
        ),
      ),
    );

    expect(find.text('Error: Error fetching data'), findsOneWidget);
  });
}
