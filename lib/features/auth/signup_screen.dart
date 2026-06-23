import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/widgets/sketch_button.dart';
import 'package:evora/features/auth/widgets/password_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create account', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Join Evora to book events',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const PasswordField(label: 'Password'),
              const SizedBox(height: AppSpacing.md),
              const PasswordField(label: 'Confirm password'),
              const SizedBox(height: AppSpacing.xl),
              SketchButton(
                label: 'Create account',
                icon: Icons.check,
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?', style: theme.textTheme.bodyMedium),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Sign in'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
