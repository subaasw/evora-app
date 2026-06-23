import 'package:flutter/material.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_button.dart';

/// Sticky bottom bar used across the booking flow: a price block + primary CTA.
class CheckoutBar extends StatelessWidget {
  const CheckoutBar({
    super.key,
    required this.subtitle,
    required this.amount,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.enabled = true,
  });

  final String subtitle;
  final double amount;
  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool enabled;

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
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${amount.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                      color: s.brandStrong, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SketchButton(
              label: label,
              icon: icon,
              onPressed: enabled ? onPressed : null,
            ),
          ),
        ],
      ),
    );
  }
}
