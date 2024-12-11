import 'package:enpal_challenge/bloc/monitoring_bloc.dart';
import 'package:enpal_challenge/bloc/monitoring_state.dart';
import 'package:enpal_challenge/presentation/pages/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'chart_page_test.dart';

void main() {
  testWidgets(
      'DatePicker shows selected date and navigate when Show Data pressed',
      (WidgetTester tester) async {
    final mockBloc = MockMonitoringBloc();

    // Provide initial state and stream for the mockBloc
    when(() => mockBloc.state).thenReturn(MonitoringInitial());
    when(() => mockBloc.stream)
        .thenAnswer((_) => Stream.value(MonitoringInitial()));

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<MonitoringBloc>.value(value: mockBloc),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: DatePicker(),
          ),
        ),
      ),
    );

    // Initially, no date selected
    expect(find.text('Selected Date: No date selected'), findsOneWidget);

    // Tap "Select Date" to open the date picker
    await tester.tap(find.text('Select Date'));
    await tester.pumpAndSettle(); 

    // Pick a date
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Now we should see the selected date
    expect(find.textContaining('Selected Date:'), findsOneWidget);

    // Show Data button should be visible
    expect(find.text('Show Data'), findsOneWidget);

    // Press Show Data
    await tester.tap(find.text('Show Data'));
    await tester.pumpAndSettle();

    expect(find.text('Monitoring Data'),
        findsOneWidget); 
  });
}
