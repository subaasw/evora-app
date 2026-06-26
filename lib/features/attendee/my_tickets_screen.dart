import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/ticket_perforation.dart';
import 'package:evora/widgets/ticket_qr.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingStore>().confirmed;

    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: bookings.isEmpty
          ? _Empty()
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: bookings.length,
              itemBuilder: (_, i) => _TicketCard(booking: bookings[i]),
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
            ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    final accent = booking.event.category.accent;
    final ticketCount = booking.seats.length;

    return GestureDetector(
      onTap: () => context.push('/ticket/${booking.id}'),
      child: Stack(
        children: [
          SketchBox(
            fill: s.paper,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header band
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.16),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(booking.event.category.icon, color: Colors.white),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.event.title,
                                style: theme.textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(
                              '${formatDay(booking.event.date)} · ${formatTime(booking.event.date)}',
                              style: theme.textTheme.bodySmall?.copyWith(color: s.body),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const TicketPerforation(),
                // Stub
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      TicketQr(data: booking.id, size: 64, framed: false),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StubLine(label: 'Seats', value: booking.seats.join(', ')),
                            const SizedBox(height: 4),
                            _StubLine(
                              label: 'Tickets',
                              value: '$ticketCount · \$${booking.total.toStringAsFixed(0)}',
                            ),
                            const SizedBox(height: 4),
                            _StubLine(label: 'Ref', value: booking.id),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: s.bodySubtle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StubLine extends StatelessWidget {
  const _StubLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(color: s.heading, fontSize: 13),
        children: [
          TextSpan(text: '$label  ', style: TextStyle(color: s.bodySubtle)),
          TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.confirmation_number_outlined, size: 56, color: s.bodySubtle),
          const SizedBox(height: AppSpacing.md),
          Text('No tickets yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text('Booked events appear here', style: TextStyle(color: s.bodySubtle)),
        ],
      ),
    );
  }
}
