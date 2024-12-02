import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/data/repositories/monitoring_repository_impl.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:enpal_challenge/presentation/pages/chart_page.dart';
import 'package:enpal_challenge/presentation/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ForTesting());
}

class ForTesting extends StatelessWidget {
  const ForTesting({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: Center(child: DatePicker())));
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
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
          ),
          body: const TabBarView(
            children: [
              DataPoints(
                date: '2024-12-12',
              ),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

class DataPoints extends StatelessWidget {
  const DataPoints({super.key, required this.date});

  final String date;

  String _formatTime(DateTime timestamp) {
    return DateFormat.Hm().format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        MonitoringRepositoryImpl(baseUrl: 'http://localhost:3000');

    return FutureBuilder<List<MonitoringData>>(
      future: repository.fetchMonitoringData(date, MonitoringType.solar),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final data = snapshot.data!;
          final double chartWidth = data.length *
              50.0; // We leave 50px space between each data point on the x-axis for better readability
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth < MediaQuery.of(context).size.width
                  ? MediaQuery.of(context).size.width
                  : chartWidth,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (data.length - 1).toDouble(),
                  minY: 0,
                  maxY: 10000,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatTime(data[value.toInt()].timestamp),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                              e.key.toDouble(), e.value.value.toDouble()))
                          .toList(),
                      color: AppColors.darkBlue,
                      isCurved: true,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
