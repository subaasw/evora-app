import 'package:flutter/material.dart';

import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_badge.dart';
import 'package:evora/widgets/sketch_box.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.onTap});

  final EventModel event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SketchCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Poster(event: event),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: theme.textTheme.titleLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _MetaRow(icon: Icons.calendar_today_outlined, text: '${formatDay(event.date)}  ·  ${formatTime(event.date)}'),
                  const SizedBox(height: 4),
                  _MetaRow(icon: Icons.place_outlined, text: event.venue),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('from ', style: theme.textTheme.bodySmall),
                      Text(
                        '\$${event.priceFrom.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: s.brandStrong,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (event.soldOut)
                        SketchBadge(
                          label: 'Sold out',
                          background: s.dangerSoft,
                          foreground: s.danger,
                          border: s.danger,
                        )
                      else if (event.seatsLeft <= 15)
                        SketchBadge(
                          label: '${event.seatsLeft} left',
                          icon: Icons.local_fire_department_outlined,
                          background: s.warningSoft,
                          foreground: s.warning,
                          border: s.warning,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    final accent = event.category.accent;
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: 'poster-${event.id}',
              child: Icon(event.category.icon, size: 48, color: accent),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: SketchBadge(
              label: event.category.label,
              icon: event.category.icon,
              foreground: accent,
              border: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Row(
      children: [
        Icon(icon, size: 15, color: s.bodySubtle),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: s.bodySubtle, fontSize: 13),
          ),
        ),
      ],
    );
  }
}
