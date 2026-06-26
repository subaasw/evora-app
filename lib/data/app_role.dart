import 'package:flutter/material.dart';

enum AppRole { attendee, organizer, admin }

extension AppRoleX on AppRole {
  String get label => switch (this) {
        AppRole.attendee => 'Attendee',
        AppRole.organizer => 'Organizer',
        AppRole.admin => 'Admin',
      };

  IconData get icon => switch (this) {
        AppRole.attendee => Icons.local_activity_outlined,
        AppRole.organizer => Icons.event_available_outlined,
        AppRole.admin => Icons.admin_panel_settings_outlined,
      };
}
