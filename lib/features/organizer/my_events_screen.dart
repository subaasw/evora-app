import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/stat_card.dart';

int soldFor(EventModel e) => (e.title.hashCode % 120).abs() + 40;

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  String _query = '';

  Future<void> _confirmDelete(EventStore store, EventModel event) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.sketch.paper,
        title: const Text('Delete event?'),
        content: Text('"${event.title}" will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: ctx.sketch.danger)),
          ),
        ],
      ),
    );
    if (ok ?? false) store.remove(event.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.watch<EventStore>();
    final all = store.events;
    final filtered = store.search(query: _query);
    final totalSold = all.fold(0, (a, e) => a + soldFor(e));
    final revenue = all.fold(0.0, (a, e) => a + soldFor(e) * e.priceFrom);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        actions: profileActions(AppRole.organizer),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                    icon: Icons.event_outlined, value: '${all.length}', label: 'Events'),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                    icon: Icons.confirmation_number_outlined,
                    value: '$totalSold',
                    label: 'Tickets sold'),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: StatCard(
                    icon: Icons.payments_outlined,
                    value: '\$${(revenue / 1000).toStringAsFixed(1)}k',
                    label: 'Revenue'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search your events',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: Center(
                child: Text('No events found', style: theme.textTheme.bodyMedium),
              ),
            )
          else
            for (final event in filtered) ...[
              _OrganizerEventCard(
                event: event,
                onEdit: () => context.push('/organizer/event/${event.id}/edit'),
                onDelete: () => _confirmDelete(store, event),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _OrganizerEventCard extends StatelessWidget {
  const _OrganizerEventCard({
    required this.event,
    required this.onEdit,
    required this.onDelete,
  });

  final EventModel event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    final sold = soldFor(event);
    final capacity = sold + event.seatsLeft;
    final occupancy = capacity == 0 ? 1.0 : sold / capacity;

    return GestureDetector(
      onTap: onEdit,
      child: SketchCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: event.category.accent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(event.category.icon, color: event.category.accent),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: theme.textTheme.titleMedium),
                      Text('${formatDay(event.date)} · ${formatTime(event.date)}',
                          style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined, color: s.brandStrong),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, color: s.danger),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: occupancy,
                minHeight: 10,
                backgroundColor: s.paperSoft,
                valueColor: AlwaysStoppedAnimation(s.brand),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$sold / $capacity seats · ${(occupancy * 100).toStringAsFixed(0)}% full',
              style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle),
            ),
          ],
        ),
      ),
    );
  }
}
