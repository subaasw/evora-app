import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/event_card.dart';
import 'package:evora/widgets/fade_in_up.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/sketch_badge.dart';
import 'package:evora/widgets/sketch_box.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  EventCategory? _category;
  String _query = '';

  bool get _isBrowsingAll => _query.isEmpty && _category == null;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<EventStore>();
    final filtered = store.search(query: _query, category: _category);
    final featured =
        _isBrowsingAll ? store.events.take(3).toList() : const <EventModel>[];
    final featuredIds = featured.map((e) => e.id).toSet();
    final upcoming = filtered.where((e) => !featuredIds.contains(e.id)).toList();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
          children: [
            const _Header(),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search events or venues',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _CategoryFilter(
              selected: _category,
              onSelected: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (featured.isNotEmpty) ...[
              _SectionTitle(title: 'Featured', trailing: '${featured.length}'),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 330,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: featured.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                  itemBuilder: (_, i) => SizedBox(
                    width: 280,
                    child: EventCard(
                      event: featured[i],
                      onTap: () => context.push('/event/${featured[i].id}'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _SectionTitle(
              title: _isBrowsingAll ? 'Upcoming events' : 'Results',
              trailing: '${upcoming.length}',
            ),
            const SizedBox(height: AppSpacing.md),
            if (upcoming.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xl),
                child: Center(
                  child: Text('No events match your search',
                      style: theme.textTheme.bodyMedium),
                ),
              )
            else
              for (final (i, event) in upcoming.indexed) ...[
                FadeInUp(
                  delay: staggerDelay(i),
                  child: EventCard(
                    event: event,
                    onTap: () => context.push('/event/${event.id}'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello 👋',
                  style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle)),
              Text('Discover events', style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/notifications'),
          child: SketchBox(
            fill: s.paperSoft,
            radius: 999,
            padding: const EdgeInsets.all(12),
            child: Icon(Icons.notifications_none, color: s.brandStrong),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const ProfileMenuButton(role: AppRole.attendee),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
        SketchBadge(label: trailing),
      ],
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onSelected});

  final EventCategory? selected;
  final ValueChanged<EventCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            label: 'All',
            active: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final c in EventCategory.values) ...[
            const SizedBox(width: AppSpacing.sm),
            _Chip(
              label: c.label,
              icon: c.icon,
              active: selected == c,
              onTap: () => onSelected(c),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      selected: active,
      onSelected: (_) => onTap(),
      avatar: icon == null
          ? null
          : Icon(icon, size: 16, color: active ? scheme.onPrimary : scheme.onSurface),
      label: Text(label),
      showCheckmark: false,
      selectedColor: scheme.primary,
      labelStyle: TextStyle(color: active ? scheme.onPrimary : scheme.onSurface),
      side: BorderSide(color: scheme.outline, width: 2),
    );
  }
}
