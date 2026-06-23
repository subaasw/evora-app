import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/checkout_bar.dart';
import 'package:evora/widgets/sketch_box.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const _methods = [
    (icon: Icons.credit_card, label: 'Credit / Debit card'),
    (icon: Icons.account_balance_wallet_outlined, label: 'E-wallet'),
    (icon: Icons.account_balance_outlined, label: 'Bank transfer'),
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BookingStore>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          Text('Payment method', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < _methods.length; i++) ...[
            _MethodTile(
              icon: _methods[i].icon,
              label: _methods[i].label,
              selected: _selected == i,
              onTap: () => setState(() => _selected = i),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
      bottomNavigationBar: CheckoutBar(
        subtitle: 'Total',
        amount: store.total,
        icon: Icons.lock_outline,
        label: 'Pay now',
        onPressed: () {
          final booking = store.confirm();
          context.go('/event/${widget.eventId}/confirm?b=${booking.id}');
        },
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return GestureDetector(
      onTap: onTap,
      child: SketchBox(
        fill: selected ? s.brandSofter : s.paperSoft,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: s.brandStrong),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? s.brand : s.bodySubtle,
            ),
          ],
        ),
      ),
    );
  }
}
