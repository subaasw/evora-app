import 'package:flutter/material.dart';

import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/fade_in_up.dart';
import 'package:evora/widgets/sketch_box.dart';

class _Note {
  const _Note(this.icon, this.title, this.body, this.time);
  final IconData icon;
  final String title;
  final String body;
  final String time;
}

const _notes = [
  _Note(Icons.confirmation_number_outlined, 'Booking confirmed',
      'Your tickets for Midnight Echoes Live are ready.', '2h ago'),
  _Note(Icons.local_fire_department_outlined, 'Selling fast',
      'Only 12 seats left for Watercolour Basics Workshop.', '1d ago'),
  _Note(Icons.notifications_active_outlined, 'Waitlist update',
      'A seat may open soon for Symphony Under Stars.', '2d ago'),
  _Note(Icons.local_offer_outlined, 'Promo for you',
      'Use SAVE10 for 10% off your next booking.', '4d ago'),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _notes.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) => FadeInUp(
          delay: staggerDelay(i),
          child: _NoteTile(note: _notes[i]),
        ),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final _Note note;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return SketchCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: s.brandSofter,
              shape: BoxShape.circle,
              border: Border.all(color: s.ink, width: 2),
            ),
            child: Icon(note.icon, color: s.brandStrong, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(note.title, style: theme.textTheme.titleMedium)),
                    Text(note.time,
                        style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(note.body,
                    style: theme.textTheme.bodyMedium?.copyWith(color: s.body)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
