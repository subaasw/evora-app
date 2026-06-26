import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/session_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';
import 'package:evora/features/auth/widgets/password_field.dart';

class StaffLoginScreen extends StatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  State<StaffLoginScreen> createState() => _StaffLoginScreenState();
}

class _StaffLoginScreenState extends State<StaffLoginScreen> {
  AppRole _role = AppRole.organizer;
  late final _email = TextEditingController(text: _defaultEmail(_role));

  static const _staffRoles = [AppRole.organizer, AppRole.admin];

  // Demo staff accounts, prefilled per role.
  static String _defaultEmail(AppRole role) => switch (role) {
        AppRole.organizer => 'subash.org@gmail.com',
        AppRole.admin => 'subash.admin@gmail.com',
        AppRole.attendee => 'subash.giri@gmail.com',
      };

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _selectRole(AppRole role) {
    setState(() {
      _role = role;
      _email.text = _defaultEmail(role);
    });
  }

  void _signIn() {
    context.read<SessionStore>().signIn(email: _email.text);
    context.go(switch (_role) {
      AppRole.organizer => '/organizer/events',
      AppRole.admin => '/admin/organizers',
      AppRole.attendee => '/attendee/browse',
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.sketch;

    return Scaffold(
      appBar: AppBar(title: const Text('Staff sign in')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Who are you signing in as?',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (final role in _staffRoles) ...[
                    Expanded(
                      child: _RoleCard(
                        role: role,
                        selected: _role == role,
                        onTap: () => _selectRole(role),
                      ),
                    ),
                    if (role != _staffRoles.last) const SizedBox(width: AppSpacing.md),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Work email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const PasswordField(label: 'Password'),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot'),
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SketchButton(label: 'Sign in', icon: Icons.login, onPressed: _signIn),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Organizer accounts are created by the auditorium admin.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.role, required this.selected, required this.onTap});

  final AppRole role;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SketchBox(
        fill: selected ? s.brandSofter : s.paperSoft,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(role.icon, size: 32, color: selected ? s.brandStrong : s.bodySubtle),
            const SizedBox(height: AppSpacing.sm),
            Text(role.label, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: selected ? s.brand : s.bodySubtle,
            ),
          ],
        ),
      ),
    );
  }
}
