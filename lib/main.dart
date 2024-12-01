import 'package:enpal_challenge/domain/data/model/monitoring_data.dart';
import 'package:enpal_challenge/domain/data/repositories/monitoring_repository_impl.dart';
import 'package:enpal_challenge/domain/repositories/monitoring_repository.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository =
        MonitoringRepositoryImpl(baseUrl: 'http://localhost:3000');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Monitoring Data'),
        ),
        body: FutureBuilder<List<MonitoringData>>(
          future: repository.fetchMonitoringData(
              '2024-12-01', MonitoringType.solar),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return ListTile(
                    title: Text('Value: ${item.value.toString()}'),
                    subtitle: Text('Timestamp: ${item.timestamp}'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
