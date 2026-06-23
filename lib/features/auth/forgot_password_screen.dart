import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/widgets/sketch_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
              Icon(
                Icons.lock_reset_outlined,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Reset password', style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Enter your email and we\'ll send a reset link',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SketchButton(
                label: 'Send reset link',
                icon: Icons.send_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset link sent')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
