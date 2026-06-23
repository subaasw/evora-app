import 'package:flutter/material.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/analytics.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/widgets/period_toggle.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/simple_bar_chart.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/stat_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  ReportPeriod _period = ReportPeriod.daily;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sales = ticketSales(_period);
    final sold = seriesTotal(sales);
    final revenue = sold * 32; // mock avg ticket price

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: profileActions(AppRole.organizer),
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
                  icon: Icons.confirmation_number_outlined,
                  value: sold.toStringAsFixed(0),
                  label: 'Tickets sold',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.payments_outlined,
                  value: '\$${(revenue / 1000).toStringAsFixed(1)}k',
                  label: 'Revenue',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                  icon: Icons.event_seat_outlined,
                  value: '78%',
                  label: 'Occupancy',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Ticket sales', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          SketchCard(child: SimpleBarChart(points: sales)),
        ],
      ),
    );
  }
}
