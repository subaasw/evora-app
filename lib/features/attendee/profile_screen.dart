import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _name = 'Alex Tan';
  static const _email = 'alex.tan@email.com';

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          SketchCard(
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: s.brandSofter,
                    shape: BoxShape.circle,
                    border: Border.all(color: s.ink, width: 2),
                  ),
                  child: Text('AT',
                      style: theme.textTheme.headlineSmall?.copyWith(color: s.brandStrong)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name, style: theme.textTheme.titleLarge),
                      Text(_email,
                          style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle)),
                    ],
                  ),
                ),
                Icon(Icons.edit_outlined, color: s.brandStrong),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Account', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          const _Tile(icon: Icons.confirmation_number_outlined, label: 'My tickets'),
          const _Tile(icon: Icons.payment_outlined, label: 'Payment methods'),
          const _Tile(icon: Icons.notifications_none, label: 'Notifications'),
          const SizedBox(height: AppSpacing.md),
          Text('Support', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          const _Tile(icon: Icons.help_outline, label: 'Help & support'),
          const _Tile(icon: Icons.info_outline, label: 'About Evora'),
          const SizedBox(height: AppSpacing.xl),
          SketchButton(
            label: 'Sign out',
            icon: Icons.logout,
            secondary: true,
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SketchBox(
        fill: s.paperSoft,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: s.brandStrong),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
            Icon(Icons.chevron_right, color: s.bodySubtle),
          ],
        ),
      ),
    );
  }
}
