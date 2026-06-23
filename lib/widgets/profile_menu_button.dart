import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';

/// Mock signed-in user per role.
({String name, String email}) _userFor(AppRole role) => switch (role) {
      AppRole.attendee => (name: 'Alex Tan', email: 'alex.tan@email.com'),
      AppRole.organizer => (name: 'Aisha Rahman', email: 'aisha@soundwave.com'),
      AppRole.admin => (name: 'Auditorium Admin', email: 'admin@helpevents.com'),
    };

String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
}

/// Convenience for AppBar `actions:` — the profile avatar with trailing padding.
List<Widget> profileActions(AppRole role) => [
      Padding(
        padding: const EdgeInsets.only(right: AppSpacing.md),
        child: ProfileMenuButton(role: role),
      ),
    ];

/// Circular avatar shown at the top-right of every role's main screens.
/// Opens a sheet with account actions including sign out.
class ProfileMenuButton extends StatelessWidget {
  const ProfileMenuButton({super.key, required this.role});

  final AppRole role;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final user = _userFor(role);
    return GestureDetector(
      onTap: () => _openSheet(context, user),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: s.brandSofter,
          shape: BoxShape.circle,
          border: Border.all(color: s.ink, width: 2),
        ),
        child: Text(
          _initials(user.name),
          style: TextStyle(
              color: s.brandStrong, fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
    );
  }

  void _openSheet(BuildContext context, ({String name, String email}) user) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.sketch.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => _ProfileSheet(role: role, user: user),
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  const _ProfileSheet({required this.role, required this.user});

  final AppRole role;
  final ({String name, String email}) user;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: s.brandSofter,
                    shape: BoxShape.circle,
                    border: Border.all(color: s.ink, width: 2),
                  ),
                  child: Text(_initials(user.name),
                      style: theme.textTheme.titleLarge?.copyWith(color: s.brandStrong)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: theme.textTheme.titleMedium),
                      Text(role.label,
                          style: theme.textTheme.bodySmall?.copyWith(color: s.brandStrong)),
                      Text(user.email,
                          style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Item(icon: Icons.person_outline, label: 'Edit profile'),
            _Item(icon: Icons.settings_outlined, label: 'Settings'),
            _Item(icon: Icons.help_outline, label: 'Help & support'),
            const Divider(height: AppSpacing.lg),
            _Item(
              icon: Icons.logout,
              label: 'Sign out',
              danger: true,
              onTap: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.icon, required this.label, this.danger = false, this.onTap});

  final IconData icon;
  final String label;
  final bool danger;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final color = danger ? s.danger : s.body;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: onTap ??
          () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$label (mock)')),
            );
          },
    );
  }
}
