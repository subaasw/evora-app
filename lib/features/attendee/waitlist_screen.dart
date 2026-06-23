import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/waitlist_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class WaitlistScreen extends StatelessWidget {
  const WaitlistScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<WaitlistStore>();
    final event = context.read<EventStore>().byId(eventId);

    return Scaffold(
      appBar: AppBar(title: const Text('Waitlist')),
      body: SafeArea(
        child: store.isJoined(eventId)
            ? _Status(eventId: eventId)
            : _Join(eventId: eventId, eventTitle: event.title),
      ),
    );
  }
}

class _Join extends StatelessWidget {
  const _Join({required this.eventId, required this.eventTitle});

  final String eventId;
  final String eventTitle;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.md),
        Center(
          child: SketchBox(
            fill: s.warningSoft,
            radius: 999,
            padding: const EdgeInsets.all(20),
            child: Icon(Icons.hourglass_top_outlined, size: 40, color: s.warning),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('This event is sold out', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Join the waitlist for "$eventTitle" and we\'ll notify you by email if a '
          'seat frees up.',
          style: theme.textTheme.bodyMedium?.copyWith(color: s.bodySubtle),
        ),
        const SizedBox(height: AppSpacing.lg),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const TextField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone (optional)',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SketchButton(
          label: 'Join waitlist',
          icon: Icons.notifications_active_outlined,
          onPressed: () => context.read<WaitlistStore>().join(eventId),
        ),
      ],
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<WaitlistStore>();
    final s = context.sketch;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        const SizedBox(height: AppSpacing.md),
        Center(
          child: SketchBox(
            fill: s.successSoft,
            radius: 999,
            padding: const EdgeInsets.all(20),
            child: Icon(Icons.check, size: 40, color: s.success),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(child: Text("You're on the waitlist", style: theme.textTheme.headlineSmall)),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: _StatBox(
                value: '#${store.position(eventId)}',
                label: 'Your position',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatBox(
                value: '${store.count(eventId)}',
                label: 'People waiting',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        SketchBox(
          fill: s.brandSofter,
          radius: AppRadius.lg,
          child: Row(
            children: [
              Icon(Icons.mail_outline, color: s.brandStrong),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'We\'ll email you the moment a seat opens up. You can leave the '
                  'waitlist anytime.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SketchButton(
          label: 'Leave waitlist',
          icon: Icons.close,
          secondary: true,
          onPressed: () {
            context.read<WaitlistStore>().leave(eventId);
            context.pop();
          },
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return SketchBox(
      fill: s.paper,
      radius: AppRadius.lg,
      child: Column(
        children: [
          Text(value,
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: s.brandStrong, fontWeight: FontWeight.w700)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
        ],
      ),
    );
  }
}
