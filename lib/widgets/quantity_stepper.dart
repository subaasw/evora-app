import 'package:flutter/material.dart';

import 'package:evora/theme/sketch_colors.dart';

/// Pill +/- stepper for picking ticket quantities.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Btn(
          icon: Icons.remove,
          enabled: value > min,
          onTap: () => onChanged(value - 1),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _Btn(
          icon: Icons.add,
          enabled: value < max,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  const _Btn({required this.icon, required this.enabled, required this.onTap});

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return InkResponse(
      onTap: enabled ? onTap : null,
      radius: 24,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: enabled ? s.brandSofter : s.disabled,
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? s.ink : s.borderDefault, width: 2),
        ),
        child: Icon(icon, size: 18, color: enabled ? s.brandStrong : s.fgDisabled),
      ),
    );
  }
}
