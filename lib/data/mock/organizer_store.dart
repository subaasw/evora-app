import 'package:flutter/foundation.dart';

import 'package:evora/data/mock/organizers.dart';

/// Live list of registered organizers backing the admin screens.
class OrganizerStore extends ChangeNotifier {
  final List<Organizer> _organizers = [...seedOrganizers];

  List<Organizer> get organizers => List.unmodifiable(_organizers);

  List<Organizer> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return organizers;
    return _organizers
        .where((o) =>
            o.name.toLowerCase().contains(q) ||
            o.org.toLowerCase().contains(q) ||
            o.email.toLowerCase().contains(q))
        .toList();
  }

  bool emailExists(String email) =>
      _organizers.any((o) => o.email.toLowerCase() == email.trim().toLowerCase());

  void add(Organizer organizer) {
    _organizers.insert(0, organizer);
    notifyListeners();
  }
}
