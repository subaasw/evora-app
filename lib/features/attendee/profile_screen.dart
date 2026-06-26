import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/session_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    final session = context.watch<SessionStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          GestureDetector(
            onTap: () => context.push('/edit-profile'),
            child: SketchCard(
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
                    child: Text(session.initials,
                        style: theme.textTheme.headlineSmall?.copyWith(color: s.brandStrong)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session.name, style: theme.textTheme.titleLarge),
                        Text(session.email,
                            style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle)),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: s.brandStrong),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Account', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _Tile(
            icon: Icons.confirmation_number_outlined,
            label: 'My tickets',
            onTap: () => context.go('/attendee/tickets'),
          ),
          _Tile(
            icon: Icons.notifications_none,
            label: 'Notifications',
            onTap: () => context.push('/notifications'),
          ),
          _Tile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => context.push('/settings'),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Support', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _Tile(
            icon: Icons.help_outline,
            label: 'Help & support',
            onTap: () => context.push('/help'),
          ),
          _Tile(
            icon: Icons.info_outline,
            label: 'About Evora',
            onTap: () => context.push('/about'),
          ),
          const SizedBox(height: AppSpacing.xl),
          SketchButton(
            label: 'Sign out',
            icon: Icons.logout,
            secondary: true,
            onPressed: () {
              context.read<SessionStore>().signOut();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
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
      ),
    );
  }
}
