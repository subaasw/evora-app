import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_badge.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final event = context.watch<EventStore>().byId(eventId);
    final theme = Theme.of(context);
    final accent = event.category.accent;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(
              child: Hero(
                tag: 'poster-${event.id}',
                child: Icon(event.category.icon, size: 72, color: accent),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SketchBadge(
            label: event.category.label,
            icon: event.category.icon,
            foreground: accent,
            border: accent,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(event.title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(icon: Icons.calendar_today_outlined, text: '${formatDay(event.date)} · ${formatTime(event.date)}'),
          _InfoRow(icon: Icons.place_outlined, text: event.venue),
          _InfoRow(
            icon: Icons.event_seat_outlined,
            text: event.soldOut ? 'Sold out' : '${event.seatsLeft} seats available',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('About', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(event.description, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          Text('Tickets', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final t in event.ticketTypes) ...[
            _TicketRow(ticket: t),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
      bottomNavigationBar: _BookingBar(event: event),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: s.brandStrong),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: TextStyle(color: s.body))),
        ],
      ),
    );
  }
}

class _TicketRow extends StatelessWidget {
  const _TicketRow({required this.ticket});

  final TicketType ticket;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return SketchBox(
      fill: s.paperSoft,
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Text(ticket.name, style: theme.textTheme.titleMedium)),
          Text(
            '\$${ticket.price.toStringAsFixed(0)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: s.brandStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.event});

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
      decoration: BoxDecoration(
        color: s.canvas,
        border: Border(top: BorderSide(color: s.ink, width: 2)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('from', style: theme.textTheme.bodySmall),
              Text(
                '\$${event.priceFrom.toStringAsFixed(0)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: s.brandStrong,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SketchButton(
              label: event.soldOut ? 'Join waitlist' : 'Book tickets',
              icon: event.soldOut ? Icons.notifications_active_outlined : Icons.confirmation_number_outlined,
              secondary: event.soldOut,
              onPressed: () => context.push(
                event.soldOut
                    ? '/event/${event.id}/waitlist'
                    : '/event/${event.id}/tickets',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
