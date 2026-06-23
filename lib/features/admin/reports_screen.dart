import 'package:flutter/material.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/analytics.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/widgets/period_toggle.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/simple_bar_chart.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/stat_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportPeriod _period = ReportPeriod.weekly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usage = auditoriumUsage(_period);
    final hosted = seriesTotal(usage);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditorium reports'),
        actions: profileActions(AppRole.admin),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          PeriodToggle(selected: _period, onChanged: (p) => setState(() => _period = p)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.event_available_outlined,
                  value: hosted.toStringAsFixed(0),
                  label: 'Events hosted',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.meeting_room_outlined,
                  value: '71%',
                  label: 'Utilization',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.groups_outlined,
                  value: '12.4k',
                  label: 'Attendees',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Auditorium usage', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          SketchCard(child: SimpleBarChart(points: usage)),
        ],
      ),
    );
  }
}
