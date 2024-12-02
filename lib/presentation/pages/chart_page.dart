import 'package:enpal_challenge/bloc/monitoring_bloc.dart';
import 'package:enpal_challenge/bloc/monitoring_state.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:enpal_challenge/presentation/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DataPoints extends StatelessWidget {
  const DataPoints({
    super.key,
    required this.date,
    required this.type,
  });

  final String date;
  final MonitoringType type;

  String _formatTime(DateTime timestamp) {
    return DateFormat.Hm().format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitoringBloc, MonitoringState>(
      builder: (context, state) {
        if (state is MonitoringLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MonitoringError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is MonitoringLoaded) {
          final data = state.data[type];
          if (data == null || data.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          final double chartWidth = data.length * 50.0;

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
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((e) => FlSpot(
                                e.key.toDouble(),
                                e.value.value.toDouble(),
                              ))
                          .toList(),
                      color: AppColors.darkBlue,
                      isCurved: true,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // Default case when no data is present
        return const Center(child: Text('Select a date to view data'));
      },
    );
  }
}
