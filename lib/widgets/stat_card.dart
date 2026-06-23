import 'package:flutter/material.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return SketchBox(
      fill: s.paper,
      radius: AppRadius.lg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: s.brandSofter,
              shape: BoxShape.circle,
              border: Border.all(color: s.ink, width: 2),
            ),
            child: Icon(icon, size: 18, color: s.brandStrong),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: s.brandStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
        ],
      ),
    );
  }
}
