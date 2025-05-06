import 'package:flutrace_web/features/analytics/data/models/analytics_data.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class AnalyticsLayout extends StatelessWidget {
  final List<TimePoint> data;
  final String interval;
  final AnalyticsSummary summary;
  final ValueChanged<String> onIntervalChanged;

  const AnalyticsLayout({
    super.key,
    required this.data,
    required this.interval,
    required this.summary,
    required this.onIntervalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        runSpacing: 16,
        children: [
          _card(
            // 👉 на всю ширину, адаптивно
            width: MediaQuery.of(context).size.width - 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Кількість логів за часом',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: interval,
                      items: const [
                        DropdownMenuItem(value: 'hour', child: Text('Щогодини')),
                        DropdownMenuItem(value: 'day', child: Text('По днях')),
                        DropdownMenuItem(value: 'month', child: Text('По місяцю')),
                      ],
                      onChanged: (val) => val != null ? onIntervalChanged(val) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(
                      labelRotation: 45,
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Кількість логів'),
                    ),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      format: 'point.x : point.y логів',
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<TimePoint, String>(
                        dataSource: data,
                        xValueMapper: (point, _) =>
                            _formatLabel(point.timestamp, interval),
                        yValueMapper: (point, _) => point.count,
                        name: 'Логи',
                        color: Colors.blue,
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 👉 PieChart: Розподіл за ОС
          _card(
            width: 300,
            height: 250,
            child: SfCircularChart(
              title: ChartTitle(text: 'ОС'),
              legend: Legend(isVisible: true),
              series: [
                PieSeries<OSStat, String>(
                  dataSource: summary.osDistribution,
                  xValueMapper: (e, _) => '${e.os} (${e.count})',
                  yValueMapper: (e, _) => e.count,
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                )
              ],
            ),
          ),
          // 👉 Гор. Bar: моделі пристроїв
          _card(
            width: 400,
            height: 250,
            child: SfCartesianChart(
              title: ChartTitle(text: 'Пристрої'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              series: <BarSeries<DeviceStat, String>>[
                BarSeries<DeviceStat, String>(
                  dataSource: summary.topDevices,
                  xValueMapper: (e, _) => e.model,
                  yValueMapper: (e, _) => e.count,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          // 👉 Таблиця повідомлень
          _card(
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Найчастіші повідомлення', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Повідомлення')),
                    DataColumn(label: Text('К-сть')),
                  ],
                  rows: summary.topMessages
                      .map((e) => DataRow(cells: [
                    DataCell(Text(e.message, overflow: TextOverflow.ellipsis)),
                    DataCell(Text('${e.count}')),
                  ]))
                      .toList(),
                  columnSpacing: 16,
                  dataRowMaxHeight: 50,
                ),
              ],
            ),
          ),
          // 👉 Гор. Bar: помилки за країнами
          _card(
            width: 400,
            height: 250,
            child: SfCartesianChart(
              title: ChartTitle(text: 'Помилки за країнами'),
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(),
              series: <BarSeries<CountryStat, String>>[
                BarSeries<CountryStat, String>(
                  dataSource: summary.errorsByCountry,
                  xValueMapper: (e, _) => e.country,
                  yValueMapper: (e, _) => e.count,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
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

  String _formatLabel(DateTime time, String interval) {
    switch (interval) {
      case 'hour':
        return '${time.hour.toString().padLeft(2, '0')}:00';
      case 'day':
      case 'month':
        return '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}';
      default:
        return time.toIso8601String();
    }
  }
}

