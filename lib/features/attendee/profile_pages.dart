import 'package:flutter/material.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/evora_logo.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

// Mock signed-in attendee, mirrors ProfileScreen.
const _kName = 'Alex Tan';
const _kEmail = 'alex.tan@email.com';
const _kPhone = '+1 555 0142';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController(text: _kName);
  final _email = TextEditingController(text: _kEmail);
  final _phone = TextEditingController(text: _kPhone);

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        children: [
          Center(
            child: Container(
              width: 84,
              height: 84,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: s.brandSofter,
                shape: BoxShape.circle,
                border: Border.all(color: s.ink, width: 2),
              ),
              child: Text('AT',
                  style: theme.textTheme.displaySmall?.copyWith(color: s.brandStrong)),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _Field(label: 'Full name', controller: _name),
          _Field(
              label: 'Email',
              controller: _email,
              keyboardType: TextInputType.emailAddress),
          _Field(
              label: 'Phone',
              controller: _phone,
              keyboardType: TextInputType.phone),
          const SizedBox(height: AppSpacing.lg),
          SketchButton(
            label: 'Save changes',
            icon: Icons.check,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved')),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: AppSpacing.xs),
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          TextField(controller: controller, keyboardType: keyboardType),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ponytail: local-only mock toggles; wire to real prefs when settings persist.
  bool _push = true;
  bool _email = true;
  bool _reminders = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        children: [
          Text('Notifications', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          _Toggle(
            label: 'Push notifications',
            value: _push,
            onChanged: (v) => setState(() => _push = v),
          ),
          _Toggle(
            label: 'Email updates',
            value: _email,
            onChanged: (v) => setState(() => _email = v),
          ),
          _Toggle(
            label: 'Event reminders',
            value: _reminders,
            onChanged: (v) => setState(() => _reminders = v),
          ),
        ],
      ),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: SketchBox(
        fill: s.paperSoft,
        radius: AppRadius.lg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Expanded(
                child:
                    Text(label, style: Theme.of(context).textTheme.titleMedium)),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _faqs = [
    (
      'How do I get my ticket?',
      'After checkout your ticket appears under My Tickets with a QR code for entry.'
    ),
    (
      'Can I get a refund?',
      'Refunds are available up to 24 hours before the event from the ticket detail screen.'
    ),
    (
      'I joined a waitlist — what now?',
      'You will be notified the moment a seat opens up and given a short window to book.'
    ),
    (
      'How does check-in work?',
      'Show the QR code on your ticket at the door; staff scan it to admit you.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        children: [
          SketchBox(
            fill: s.brandSofter,
            child: Row(
              children: [
                Icon(Icons.support_agent, color: s.brandStrong, size: 32),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Need a hand?', style: theme.textTheme.titleLarge),
                      Text('We reply within a few hours.',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: s.body)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('FAQs', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          for (final (q, a) in _faqs)
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 4),
                childrenPadding:
                    const EdgeInsets.only(left: 4, right: 4, bottom: 12),
                title: Text(q, style: theme.textTheme.titleMedium),
                iconColor: s.brandStrong,
                collapsedIconColor: s.bodySubtle,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(a,
                        style:
                            theme.textTheme.bodyMedium?.copyWith(color: s.body)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          SketchButton(
            label: 'Email support',
            icon: Icons.mail_outline,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('support@evora.app')),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SketchButton(
            label: 'Live chat',
            icon: Icons.chat_bubble_outline,
            secondary: true,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat is opening… (mock)')),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutEvoraScreen extends StatelessWidget {
  const AboutEvoraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About Evora')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.xl),
        children: [
          const Center(child: EvoraLogo(size: 96, withWordmark: true)),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text('Version 0.1.0',
                style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle)),
          ),
          const SizedBox(height: AppSpacing.lg),
          SketchCard(
            child: Text(
              'Evora is an event management and auditorium ticketing app — '
              'discover events, pick your seats, and check in with a tap.',
              style: theme.textTheme.bodyLarge?.copyWith(color: s.body),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _LinkTile(icon: Icons.description_outlined, label: 'Terms of service'),
          const _LinkTile(icon: Icons.privacy_tip_outlined, label: 'Privacy policy'),
          const _LinkTile(icon: Icons.star_outline, label: 'Rate Evora'),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text('Made with ♥ for live events',
                style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.icon, required this.label});

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
            Expanded(
                child:
                    Text(label, style: Theme.of(context).textTheme.titleMedium)),
            Icon(Icons.chevron_right, color: s.bodySubtle),
          ],
        ),
      ),
    );
  }
}
