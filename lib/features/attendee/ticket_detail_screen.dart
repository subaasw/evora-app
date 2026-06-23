import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/ticket_qr.dart';
import 'package:evora/widgets/sketch_box.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingStore>().bookingById(bookingId);
    final theme = Theme.of(context);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Ticket not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ticket')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Center(child: TicketQr(data: booking.id, size: 220)),
          const SizedBox(height: AppSpacing.md),
          Center(child: Text(booking.id, style: theme.textTheme.titleMedium)),
          const SizedBox(height: AppSpacing.lg),
          SketchCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.event.title, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                _Row(label: 'When', value: '${formatDay(booking.event.date)} · ${formatTime(booking.event.date)}'),
                _Row(label: 'Venue', value: booking.event.venue),
                _Row(label: 'Seats', value: booking.seats.join(', ')),
                _Row(label: 'Paid', value: '\$${booking.total.toStringAsFixed(0)}'),
              ],
            ),
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
