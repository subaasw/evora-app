import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/organizer_store.dart';
import 'package:evora/data/mock/organizers.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class RegisterOrganizerScreen extends StatefulWidget {
  const RegisterOrganizerScreen({super.key});

  @override
  State<RegisterOrganizerScreen> createState() => _RegisterOrganizerScreenState();
}

class _RegisterOrganizerScreenState extends State<RegisterOrganizerScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _org = TextEditingController();
  String? _emailError;
  bool _done = false;

  @override
  void dispose() {
    for (final c in [_name, _email, _phone, _org]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final store = context.read<OrganizerStore>();
    final email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }
    if (store.emailExists(email)) {
      setState(() => _emailError = 'This email is already registered');
      return;
    }
    store.add(Organizer(
      name: _name.text.trim().isEmpty ? 'New Organizer' : _name.text.trim(),
      org: _org.text.trim().isEmpty ? '—' : _org.text.trim(),
      email: email,
      phone: _phone.text.trim(),
      events: 0,
    ));
    setState(() {
      _emailError = null;
      _done = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register organizer')),
      body: SafeArea(
        child: _done ? _Success(name: _name.text) : _form(context),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
      children: [
        Text(
          'A welcome email with login details is sent on registration.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: context.sketch.bodySubtle),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _name,
          decoration: const InputDecoration(
            labelText: 'Full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.mail_outline),
            errorText: _emailError,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone number',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _org,
          decoration: const InputDecoration(
            labelText: 'Organization name (optional)',
            prefixIcon: Icon(Icons.business_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SketchButton(label: 'Register & send invite', icon: Icons.send_outlined, onPressed: _submit),
      ],
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SketchBox(
            fill: s.successSoft,
            radius: 999,
            padding: const EdgeInsets.all(24),
            child: Icon(Icons.check, size: 44, color: s.success),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Organizer registered', style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${name.isEmpty ? 'They' : name} will receive login details by email.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle),
          ),
          const SizedBox(height: AppSpacing.xl),
          SketchButton(
            label: 'Done',
            icon: Icons.arrow_back,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
