import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/session_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/evora_logo.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';
import 'package:evora/features/auth/widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController(text: 'subash.giri@gmail.com');

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _signIn() {
    // Whatever email you type becomes the account for this session.
    context.read<SessionStore>().signIn(email: _email.text);
    context.go('/attendee/browse');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = context.sketch;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Center(child: EvoraLogo(size: 64, withWordmark: true)),
              const SizedBox(height: AppSpacing.xl),
              Text('Welcome back', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Sign in to book your next event',
                style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => _signIn(),
                decoration: const InputDecoration(
                  labelText: 'Email',
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
              SketchButton(
                label: 'Sign in',
                icon: Icons.login,
                onPressed: _signIn,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: theme.textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => context.push('/signup'),
                    child: const Text('Sign up'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const _StaffEntry(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StaffEntry extends StatelessWidget {
  const _StaffEntry();

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/staff-login'),
      child: SketchBox(
        fill: s.paperSoft,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.admin_panel_settings_outlined, color: s.brandStrong),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Organizer or Admin?', style: theme.textTheme.titleSmall),
                  Text('Staff sign in',
                      style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: s.bodySubtle),
          ],
        ),
      ),
    );
  }
}
