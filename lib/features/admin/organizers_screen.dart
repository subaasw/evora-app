import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/organizer_store.dart';
import 'package:evora/data/mock/organizers.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

class OrganizersScreen extends StatefulWidget {
  const OrganizersScreen({super.key});

  @override
  State<OrganizersScreen> createState() => _OrganizersScreenState();
}

class _OrganizersScreenState extends State<OrganizersScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.watch<OrganizerStore>();
    final results = store.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizers'),
        actions: profileActions(AppRole.admin),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
        children: [
          SketchButton(
            label: 'Register organizer',
            icon: Icons.person_add_alt,
            onPressed: () => context.push('/admin/register'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search organizers',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('${results.length} organizers', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.md),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: Center(
                child: Text('No organizers found', style: theme.textTheme.bodyMedium),
              ),
            )
          else
            for (final o in results) ...[
              _OrganizerTile(organizer: o),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _OrganizerTile extends StatelessWidget {
  const _OrganizerTile({required this.organizer});

  final Organizer organizer;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);
    return SketchCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: s.brandSofter,
              shape: BoxShape.circle,
              border: Border.all(color: s.ink, width: 2),
            ),
            child: Text(organizer.initials,
                style: theme.textTheme.titleMedium?.copyWith(color: s.brandStrong)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(organizer.name, style: theme.textTheme.titleMedium),
                Text(organizer.org,
                    style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
                const SizedBox(height: 2),
                Text(organizer.email,
                    style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
              ],
            ),
          ),
          Column(
            children: [
              Text('${organizer.events}',
                  style: theme.textTheme.titleMedium?.copyWith(color: s.brandStrong)),
              Text('events',
                  style: theme.textTheme.bodySmall?.copyWith(color: s.bodySubtle)),
            ],
          ),
        ],
      ),
    );
  }
}
