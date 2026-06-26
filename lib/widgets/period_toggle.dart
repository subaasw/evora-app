import 'package:flutter/material.dart';

import 'package:evora/data/mock/analytics.dart';

class PeriodToggle extends StatelessWidget {
  const PeriodToggle({super.key, required this.selected, required this.onChanged});

  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      children: [
        for (final p in ReportPeriod.values)
          ChoiceChip(
            selected: selected == p,
            onSelected: (_) => onChanged(p),
            label: Text(p.label),
            showCheckmark: false,
            selectedColor: scheme.primary,
            labelStyle: TextStyle(
              color: selected == p ? scheme.onPrimary : scheme.onSurface,
            ),
            side: BorderSide(color: scheme.outline, width: 2),
          ),
      ],
    );
  }
}
