import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/event_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/checkout_bar.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/quantity_stepper.dart';

class TicketSelectScreen extends StatefulWidget {
  const TicketSelectScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<TicketSelectScreen> createState() => _TicketSelectScreenState();
}

class _TicketSelectScreenState extends State<TicketSelectScreen> {
  @override
  void initState() {
    super.initState();
    final event = context.read<EventStore>().byId(widget.eventId);
    context.read<BookingStore>().start(event);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BookingStore>();
    final event = context.read<EventStore>().byId(widget.eventId);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose tickets')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          Text(event.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          for (final t in event.ticketTypes) ...[
            SketchBox(
              fill: context.sketch.paperSoft,
              radius: AppRadius.lg,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name, style: theme.textTheme.titleMedium),
                        Text('\$${t.price.toStringAsFixed(0)} · max ${t.maxPerOrder}',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  QuantityStepper(
                    value: store.qtyOf(t.name),
                    max: t.maxPerOrder,
                    onChanged: (v) => store.setQty(t.name, v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
      bottomNavigationBar: CheckoutBar(
        subtitle: '${store.seatTarget} ticket(s)',
        amount: store.subtotal,
        enabled: store.seatTarget > 0,
        label: 'Choose seats',
        onPressed: () => context.push('/event/${widget.eventId}/seats'),
      ),
    );
  }
}
