import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:evora/theme/sketch_colors.dart';

class RoleNavItem {
  const RoleNavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class RoleShell extends StatelessWidget {
  const RoleShell({super.key, required this.shell, required this.items});

  final StatefulNavigationShell shell;
  final List<RoleNavItem> items;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Scaffold(
      body: shell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: s.ink, width: 2)),
        ),
        child: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (i) =>
              shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: [
            for (final item in items)
              NavigationDestination(icon: Icon(item.icon), label: item.label),
          ],
        ),
      ),
    );
  }
}
