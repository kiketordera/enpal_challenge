import 'dart:async';

import 'package:enpal_challenge/bloc/monitoring_bloc.dart';
import 'package:enpal_challenge/bloc/monitoring_event.dart';
import 'package:enpal_challenge/domain/data/repositories/monitoring_repository_impl.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:enpal_challenge/presentation/pages/chart_page.dart';
import 'package:enpal_challenge/presentation/pages/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ForTesting());
}

class ForTesting extends StatelessWidget {
  const ForTesting({super.key});

  @override
  Widget build(BuildContext context) {
    final repository =
        MonitoringRepositoryImpl(baseUrl: 'http://localhost:3000');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MonitoringBloc(repository: repository),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[900],
        ),
        themeMode: ThemeMode.system,
        home: const Scaffold(body: Center(child: DatePicker())),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  final String selectedDate;
  const Wrapper({super.key, required this.selectedDate});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late String selectedDate;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    final bloc = context.read<MonitoringBloc>();
    // Initial fetch
    bloc.add(
        FetchMonitoringData(date: selectedDate, type: MonitoringType.solar));
    bloc.add(
        FetchMonitoringData(date: selectedDate, type: MonitoringType.house));
    bloc.add(
        FetchMonitoringData(date: selectedDate, type: MonitoringType.battery));

    // Set up polling every 60 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      bloc.add(
          FetchMonitoringData(date: selectedDate, type: MonitoringType.solar));
      bloc.add(
          FetchMonitoringData(date: selectedDate, type: MonitoringType.house));
      bloc.add(FetchMonitoringData(
          date: selectedDate, type: MonitoringType.battery));
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Monitoring Data'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.sunny), text: 'Solar'),
              Tab(icon: Icon(Icons.home), text: 'House'),
              Tab(icon: Icon(Icons.battery_full), text: 'Battery'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.sync_alt),
              onPressed: () {
                context.read<MonitoringBloc>().add(const ToggleUnit());
              },
              tooltip: 'Toggle Units (W/kW)',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<MonitoringBloc>().add(ClearMonitoringCache());
                context.read<MonitoringBloc>().add(FetchMonitoringData(
                    date: selectedDate, type: MonitoringType.solar));
                context.read<MonitoringBloc>().add(FetchMonitoringData(
                    date: selectedDate, type: MonitoringType.house));
                context.read<MonitoringBloc>().add(FetchMonitoringData(
                    date: selectedDate, type: MonitoringType.battery));
              },
              tooltip: 'Refresh Data',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            DataPoints(
              date: selectedDate,
              type: MonitoringType.solar,
            ),
            DataPoints(
              date: selectedDate,
              type: MonitoringType.house,
            ),
            DataPoints(
              date: selectedDate,
              type: MonitoringType.battery,
            ),
          ],
        ),
      ),
    );
  }
}
