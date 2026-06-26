import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';
import 'package:evora/widgets/ticket_perforation.dart';
import 'package:evora/widgets/ticket_qr.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingStore>().bookingById(bookingId);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Ticket not found')));
    }

    final s = context.sketch;
    final theme = Theme.of(context);
    final accent = booking.event.category.accent;

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          SketchBox(
            fill: s.paper,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header band — event identity, like a stadium ticket top.
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            Icon(booking.event.category.icon, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.event.title,
                                style: theme.textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            Text(
                              '${formatDay(booking.event.date)} · ${formatTime(booking.event.date)}',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: s.body),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const TicketPerforation(),
                // Scan stub — the QR the gate scans, as the ticket's main panel.
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md,
                      AppSpacing.lg, AppSpacing.lg),
                  child: Column(
                    children: [
                      Text('SCAN AT ENTRANCE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: s.bodySubtle,
                            letterSpacing: 2,
                          )),
                      const SizedBox(height: AppSpacing.md),
                      TicketQr(data: booking.id, size: 220),
                      const SizedBox(height: AppSpacing.sm),
                      Text(booking.id, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.md),
                      _Row(
                          label: 'Venue', value: booking.event.venue),
                      _Row(label: 'Seats', value: booking.seats.join(', ')),
                      _Row(
                          label: 'Paid',
                          value: '\$${booking.total.toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SketchButton(
            label: 'View invoice',
            icon: Icons.receipt_long_outlined,
            secondary: true,
            onPressed: () => context.push('/ticket/${booking.id}/invoice'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 64, child: Text(label, style: TextStyle(color: s.bodySubtle))),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
