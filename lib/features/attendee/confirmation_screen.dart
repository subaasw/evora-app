import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/ticket_qr.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingStore>().bookingById(bookingId);
    final s = context.sketch;
    final theme = Theme.of(context);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Booking not found')));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: SketchBox(
                fill: s.successSoft,
                radius: 999,
                padding: const EdgeInsets.all(20),
                child: Icon(Icons.check, size: 40, color: s.success),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Center(child: Text('Booking confirmed!', style: theme.textTheme.headlineSmall)),
            const SizedBox(height: AppSpacing.xs),
            Center(
              child: Text(
                'Show this QR at the entrance',
                style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(child: TicketQr(data: booking.id)),
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
                  _Row(label: 'Seats', value: booking.seats.join(', ')),
                  _Row(label: 'Paid', value: '\$${booking.total.toStringAsFixed(0)}'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SketchButton(
              label: 'View my tickets',
              icon: Icons.confirmation_number_outlined,
              onPressed: () => context.go('/attendee/tickets'),
            ),
          ],
        ),
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
