import 'package:flutrace_web/core/styles/font.dart';
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _card(
                      context: context,
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('todays logs',
                                style: AppTextStyles.headingMedium(context)),
                            Text('$todaysLogs',
                                style: AppTextStyles.digits(context)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _card(
                      context: context,
                      height: 150,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  time,
                                  style: AppTextStyles.digits(context)
                                      .copyWith(fontSize: 40),
                                ),
                                Text(
                                  date,
                                  style: AppTextStyles.digits(context)
                                      .copyWith(fontSize: 20),
                                ),
                              ],
                            ),
                            Text('last log appeared',
                                style: AppTextStyles.headingMedium(context)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _card(
                  context: context,
                  height: 320,
                  child: SfCircularChart(
                    title: ChartTitle(
                        text: 'Рівні логів (сьогодні)',
                        textStyle: AppTextStyles.headingMedium(context)),
                    legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                      textStyle: AppTextStyles.caption(context)
                    ),
                    series: [
                      PieSeries<LevelCount, String>(
                        dataSource: levelDistribution,
                        xValueMapper: (data, _) =>
                            '${data.level} (${data.count})',
                        yValueMapper: (e, _) => e.count,
                        pointColorMapper: (e, _) => switch (e.level) {
                          'error' => const Color(0xFFFFA630),
                          'critical' => Theme.of(context).colorScheme.error,
                          'info' => Theme.of(context).colorScheme.surface,
                          'warning' => const Color(0xFFF0DC93),
                          _ => Theme.of(context).cardColor,
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _card(
                  context: context,
                  height: 320,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Логи за останні 7 днів',
                      textStyle: AppTextStyles.headingMedium(context),
                    ),
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      tooltipSettings: InteractiveTooltip(
                        enable: true,
                        format: 'point.y',
                        color: Theme.of(context).cardColor,
                        textStyle: AppTextStyles.caption(context),
                      ),
                      lineColor: Theme.of(context).colorScheme.surface,
                      lineDashArray: const [4, 3],
                    ),
                    primaryXAxis: CategoryAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    series: <LineSeries<LogCountPoint, String>>[
                      LineSeries<LogCountPoint, String>(
                        dataSource: logsPerDay,
                        xValueMapper: (e, _) =>
                            DateFormat('dd.MM').format(DateTime.parse(e.date)),
                        yValueMapper: (e, _) => e.count,
                        markerSettings: const MarkerSettings(isVisible: true),
                        color: Theme.of(context).colorScheme.surface,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _card(
                  context: context,
                  height: 320,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      text: 'Кількість логів за версіями',
                      textStyle: AppTextStyles.headingMedium(context),
                    ),
                    primaryXAxis: CategoryAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    primaryYAxis: NumericAxis(
                      labelStyle: AppTextStyles.caption(context),
                    ),
                    series: <ColumnSeries<VersionErrorStat, String>>[
                      ColumnSeries<VersionErrorStat, String>(
                        dataSource: topVersions,
                        xValueMapper: (v, _) => v.version,
                        yValueMapper: (v, _) => v.errors,
                        pointColorMapper: (v, _) =>
                            Theme.of(context).colorScheme.surface,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: AppTextStyles.caption(context),
                        ),
                      )
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
}
