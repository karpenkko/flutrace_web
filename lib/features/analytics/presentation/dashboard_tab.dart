import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutrace_web/features/analytics/data/models/dashboard_data.dart';
import 'package:flutrace_web/features/analytics/presentation/widgets/dashboard/layout.dart';
import 'package:flutrace_web/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/dashboard_cubit.dart';


class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  late DashboardCubit _dashboardCubit;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = sl<DashboardCubit>();
    _dashboardCubit.loadDashboard('1234-abc');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        bloc: _dashboardCubit,
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          } else if (state is DashboardLoaded) {
            final data = state.data;

            return DashboardLayout(
              todaysLogs: data.totalLogsToday,
              lastLogTime: data.lastLogTimestamp ?? DateTime.now(),
              levelDistribution: data.levelDistributionToday,
              logsPerDay: data.logCounts,
              topVersions: data.topVersions,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboardContent(DashboardData data) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Дашборд',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              _buildComparison(data.comparison),
            ],
          ),
          Text('Сьогоднішні логи: ${data.totalLogsToday}'),
          const SizedBox(height: 16),
          _buildLevelDistributionChart(data.levelDistributionToday),
          const SizedBox(height: 32),
          Text('Динаміка логів за останні 7 днів'),
          _buildLogCountChart(data.logCounts),
          const SizedBox(height: 32),
          _buildTopVersions(data.topVersions),
          const SizedBox(height: 32),
          Text('Останній лог: ${DateFormat.Hm().add_yMd().format(data.lastLogTimestamp!)}'),
        ],
      ),
    );
  }

  Widget _buildPieChart(double error, double critical) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(sections: [
          PieChartSectionData(
              color: Colors.orange,
              value: error,
              title: 'Error',
              radius: 50),
          PieChartSectionData(
              color: Colors.red,
              value: critical,
              title: 'Critical',
              radius: 50),
        ]),
      ),
    );
  }

  Widget _buildLogCountChart(List<LogCountPoint> data) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  return Text(data[index].date.substring(5)); // mm-dd
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map(
                    (entry) {
                  final index = entry.key.toDouble();
                  final count = entry.value.count.toDouble();
                  return FlSpot(index, count);
                },
              ).toList(),
              isCurved: true,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildComparison(ComparisonStats comparison) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Порівняння:',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('З вчора: ${_formatComparison(comparison.yesterday)}'),
        Text('З минулого тижня: ${_formatComparison(comparison.lastWeek)}'),
      ],
    );
  }

  Widget _buildLevelDistributionChart(List<LevelCount> levels) {
    final total = levels.fold<int>(0, (sum, l) => sum + l.count);

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: levels.map(
                (l) {
              final percent = (l.count / total) * 100;
              return PieChartSectionData(
                title: '${l.level} (${percent.toStringAsFixed(1)}%)',
                value: l.count.toDouble(),
                radius: 50,
              );
            },
          ).toList(),
        ),
      ),
    );
  }


  String _formatComparison(double? value) {
    if (value == null) return 'немає даних';
    return "${value > 0 ? '+' : ''}${value.toStringAsFixed(1)}%";
  }

  Widget _buildTopVersions(List<VersionErrorStat> versions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Версії з найбільшими помилками:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...versions.map(
              (v) => ListTile(
            title: Text('Версія ${v.version}'),
            trailing: Text('${v.errors} помилок'),
          ),
        ),
      ],
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

