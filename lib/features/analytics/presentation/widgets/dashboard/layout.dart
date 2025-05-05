import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class DashboardLayout extends StatelessWidget {
  final int todaysLogs;
  final DateTime lastLogTime;
  final List<LevelCount> levelDistribution;
  final List<LogCountPoint> logsPerDay;
  final List<VersionErrorStat> topVersions;

  const DashboardLayout({
    required this.todaysLogs,
    required this.lastLogTime,
    required this.levelDistribution,
    required this.logsPerDay,
    required this.topVersions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.Hm().format(lastLogTime);
    final date = DateFormat('dd.MM.yyyy').format(lastLogTime);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _card(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('todays logs', style: TextStyle(fontSize: 16)),
                Text(
                  '$todaysLogs',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          _card(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 36, color: Colors.blue),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                ),
                const Text('last log appeared'),
              ],
            ),
          ),
          _card(
            width: 300,
            height: 250,
            child: SfCircularChart(
              title: ChartTitle(text: 'Рівні логів (сьогодні)'),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.right,
                overflowMode: LegendItemOverflowMode.wrap,
                textStyle: const TextStyle(fontSize: 12),
              ),
              series: [
                PieSeries<LevelCount, String>(
                  dataSource: levelDistribution,
                  xValueMapper: (LevelCount data, _) {
                    final total = levelDistribution.fold<int>(0, (sum, e) => sum + e.count);
                    final percent = (data.count / total * 100).toStringAsFixed(1);
                    return '${data.level} ($percent%)';
                  },
                  yValueMapper: (e, _) => e.count,
                  pointColorMapper: (e, _) => switch (e.level) {
                    'error' => Colors.orange,
                    'critical' => Colors.red,
                    'info' => Colors.blue,
                    'warning' => Colors.yellow,
                    _ => Colors.grey,
                  },
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: false, // 👈 ВИМИКАЄМО підписи на самій діаграмі
                  ),
                ),
              ],
            ),
          ),
          _card(
            width: 500,
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <LineSeries<LogCountPoint, String>>[
                LineSeries<LogCountPoint, String>(
                  dataSource: logsPerDay,
                  xValueMapper: (e, _) =>
                      DateFormat('dd.MM').format(DateTime.parse(e.date)),
                  yValueMapper: (e, _) => e.count,
                  markerSettings: const MarkerSettings(isVisible: true),
                  color: Colors.blue,
                )
              ],
            ),
          ),
          _card(
            width: 300,
            height: 250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ColumnSeries<VersionErrorStat, String>>[
                ColumnSeries<VersionErrorStat, String>(
                  dataSource: topVersions,
                  xValueMapper: (v, _) => v.version,
                  yValueMapper: (v, _) => v.errors,
                  pointColorMapper: (v, _) => Colors.blue,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child, double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}
