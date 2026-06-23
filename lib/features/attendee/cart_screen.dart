import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/checkout_bar.dart';
import 'package:evora/widgets/sketch_box.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();
  String? _promoError;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(BookingStore store) {
    final ok = store.applyPromo(_promoController.text);
    setState(() => _promoError = ok ? null : 'Invalid code');
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BookingStore>();
    final event = store.event!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review order')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          Text(event.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          SketchCard(
            child: Column(
              children: [
                for (final t in event.ticketTypes)
                  if (store.qtyOf(t.name) > 0)
                    _Line(
                      label: '${t.name} × ${store.qtyOf(t.name)}',
                      value: '\$${(t.price * store.qtyOf(t.name)).toStringAsFixed(0)}',
                    ),
                const Divider(height: AppSpacing.lg),
                _Line(label: 'Seats', value: store.seats.join(', ')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _PromoField(
            controller: _promoController,
            error: _promoError,
            applied: store.promo,
            onApply: () => _applyPromo(store),
            onClear: () {
              store.clearPromo();
              _promoController.clear();
              setState(() => _promoError = null);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          SketchBox(
            fill: context.sketch.brandSofter,
            radius: AppRadius.lg,
            child: Column(
              children: [
                _Line(label: 'Subtotal', value: '\$${store.subtotal.toStringAsFixed(0)}'),
                if (store.promo != null)
                  _Line(
                    label: 'Discount (${store.promo})',
                    value: '-\$${store.discount.toStringAsFixed(0)}',
                  ),
                const Divider(height: AppSpacing.lg),
                _Line(
                  label: 'Total',
                  value: '\$${store.total.toStringAsFixed(0)}',
                  emphasize: true,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CheckoutBar(
        subtitle: 'Total',
        amount: store.total,
        label: 'Continue to pay',
        onPressed: () => context.push('/event/${widget.eventId}/payment'),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value, this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700, color: context.sketch.brandStrong)
        : theme.textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _PromoField extends StatelessWidget {
  const _PromoField({
    required this.controller,
    required this.error,
    required this.applied,
    required this.onApply,
    required this.onClear,
  });

  final TextEditingController controller;
  final String? error;
  final String? applied;
  final VoidCallback onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    if (applied != null) {
      return SketchBox(
        fill: context.sketch.successSoft,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.check_circle_outline, color: context.sketch.success),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text('Promo "$applied" applied')),
            TextButton(onPressed: onClear, child: const Text('Remove')),
          ],
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Promo code',
              prefixIcon: const Icon(Icons.local_offer_outlined),
              errorText: error,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: FilledButton(
            onPressed: onApply,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 56),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }
}
