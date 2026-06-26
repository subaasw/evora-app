import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_badge.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/ticket_perforation.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    final booking = context.read<BookingStore>().bookingById(bookingId);

    if (booking == null) {
      return const Scaffold(body: Center(child: Text('Invoice not found')));
    }

    final s = context.sketch;
    final theme = Theme.of(context);

    // Reprice each line from the event's published prices, so the breakdown
    // always reconciles to the stored total. Discount falls out of the gap.
    final priceOf = {for (final t in booking.event.ticketTypes) t.name: t.price};
    var subtotal = 0.0;
    final lines = <(String, int, double)>[];
    booking.quantities.forEach((name, qty) {
      final price = priceOf[name] ?? 0;
      subtotal += price * qty;
      lines.add((name, qty, price * qty));
    });
    final discount = subtotal - booking.total;

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          SketchBox(
            fill: s.paper,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text('INVOICE',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(letterSpacing: 3)),
                          ),
                          SketchBadge(
                            label: 'PAID',
                            foreground: s.success,
                            background: s.successSoft,
                            border: s.success,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _Meta(label: 'Ref', value: booking.id),
                      _Meta(
                          label: 'Date',
                          value:
                              '${formatDay(booking.bookedAt)} · ${formatTime(booking.bookedAt)}'),
                      const SizedBox(height: AppSpacing.md),
                      Text(booking.event.title, style: theme.textTheme.titleMedium),
                      Text(booking.event.venue,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: s.bodySubtle)),
                    ],
                  ),
                ),
                const TicketPerforation(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      for (final (name, qty, amount) in lines)
                        _LineItem(
                            label: '$name  ×$qty',
                            value: '\$${amount.toStringAsFixed(0)}'),
                      const Divider(height: AppSpacing.lg),
                      _LineItem(
                          label: 'Subtotal',
                          value: '\$${subtotal.toStringAsFixed(0)}',
                          muted: true),
                      if (discount > 0.01)
                        _LineItem(
                          label: 'Discount',
                          value: '-\$${discount.toStringAsFixed(0)}',
                          muted: true,
                        ),
                      const SizedBox(height: AppSpacing.sm),
                      _LineItem(
                          label: 'Total',
                          value: '\$${booking.total.toStringAsFixed(0)}',
                          emphasize: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text('Thanks for booking with Evora.',
                style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 48, child: Text(label, style: TextStyle(color: s.bodySubtle, fontSize: 13))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({
    required this.label,
    required this.value,
    this.muted = false,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool muted;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleLarge
        : theme.textTheme.bodyLarge?.copyWith(color: muted ? s.bodySubtle : s.body);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(label,
                  style: style, maxLines: 1, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: AppSpacing.md),
          Text(value, style: style),
        ],
      ),
    );
  }
}
