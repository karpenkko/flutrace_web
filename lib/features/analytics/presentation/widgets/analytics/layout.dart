import 'package:flutrace_web/core/styles/font.dart';
import 'package:flutrace_web/features/analytics/data/models/analytics_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
    final fullWidth = MediaQuery.of(context).size.width - 32;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _card(
            context: context,
            width: fullWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Кількість логів за часом',
                      style: AppTextStyles.headingMedium(context),
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: interval,
                      items: const [
                        DropdownMenuItem(
                          value: 'hour',
                          child: Text('Щогодини'),
                        ),
                        DropdownMenuItem(
                          value: 'day',
                          child: Text('По днях'),
                        ),
                        DropdownMenuItem(
                          value: 'month',
                          child: Text('По місяцю'),
                        ),
                      ],
                      onChanged: (val) =>
                          val != null ? onIntervalChanged(val) : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      majorGridLines: MajorGridLines(width: 0),
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Кількість логів'),
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<TimePoint, String>(
                        dataSource: data,
                        xValueMapper: (point, _) =>
                            _formatLabel(point.timestamp, interval),
                        yValueMapper: (point, _) => point.count,
                        name: 'Логи',
                        color: Theme.of(context).colorScheme.surface,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: AppTextStyles.caption(context)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _card(
                  context: context,
                  height: 300,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Пристрої',
                      textStyle: AppTextStyles.headingMedium(context),
                    ),
                    primaryXAxis: CategoryAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    series: <BarSeries<DeviceStat, String>>[
                      BarSeries<DeviceStat, String>(
                        color: Theme.of(context).colorScheme.surface,
                        dataSource: summary.topDevices.reversed.toList(),
                        xValueMapper: (e, _) => e.model,
                        yValueMapper: (e, _) => e.count,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: AppTextStyles.caption(context)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _card(
                  context: context,
                  height: 300,
                  child: SfCircularChart(
                    title: ChartTitle(
                      text: 'ОС',
                      textStyle: AppTextStyles.headingMedium(context),
                    ),
                    legend: Legend(
                        isVisible: true,
                        position: LegendPosition.right,
                        textStyle: AppTextStyles.caption(context)),
                    series: [
                      PieSeries<OSStat, String>(
                        dataSource: summary.osDistribution,
                        xValueMapper: (OSStat os, _) {
                          final total = summary.osDistribution
                              .fold<int>(0, (sum, item) => sum + item.count);
                          final percent =
                              (os.count / total * 100).toStringAsFixed(1);
                          return '${os.os} ($percent%)';
                        },
                        yValueMapper: (e, _) => e.count,
                        pointColorMapper: (e, _) {
                          final os = e.os.trim().toLowerCase();
                          return switch (os) {
                            '"android"' => const Color(0xFF59CD90),
                            '"ios"' => const Color(0xFFAEB8FE),
                            _ => Theme.of(context).cardColor,
                          };
                        },
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _card(
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Найчастіші повідомлення',
                          style: AppTextStyles.headingMedium(context)),
                      const SizedBox(height: 8),
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text(
                                  'Повідомлення',
                                  style: AppTextStyles.searchField(context)
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Кількість',
                                  style: AppTextStyles.searchField(context)
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                            rows: summary.topMessages
                                .map((e) => DataRow(cells: [
                                      DataCell(
                                        Text(
                                          e.message,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.searchField(
                                              context),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          '${e.count}',
                                          style: AppTextStyles.searchField(
                                              context),
                                        ),
                                      ),
                                    ]))
                                .toList(),
                            headingRowHeight: 56,
                            dataRowMinHeight: 48,
                            dataRowMaxHeight: 64,
                            columnSpacing: 32,
                            horizontalMargin: 12,
                            dividerThickness: 1.0,
                            showBottomBorder: true,
                            border: TableBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _card(
                  context: context,
                  height: 300,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Помилки за країнами',
                      textStyle: AppTextStyles.headingMedium(context),
                    ),
                    primaryXAxis: CategoryAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    series: <BarSeries<CountryStat, String>>[
                      BarSeries<CountryStat, String>(
                        color: Theme.of(context).colorScheme.surface,
                        dataSource: summary.errorsByCountry.reversed.toList(),
                        xValueMapper: (e, _) => e.country,
                        yValueMapper: (e, _) => e.count,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            textStyle: AppTextStyles.caption(context)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(
      {required BuildContext context,
      required Widget child,
      double? width,
      double? height}) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).cardColor,
          width: 2,
        ),
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
