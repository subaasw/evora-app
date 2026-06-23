import 'package:flutter/foundation.dart';

import 'package:evora/data/mock/models.dart';
import 'package:evora/data/mock/seed.dart';

/// Live, mutable list of events backing browse, detail and the organizer
/// screens. Seeded from [seedEvents]; UI-only (no persistence).
class EventStore extends ChangeNotifier {
  final List<EventModel> _events = [...seedEvents];

  List<EventModel> get events => List.unmodifiable(_events);

  EventModel byId(String id) => _events.firstWhere((e) => e.id == id);

  List<EventModel> search({String query = '', EventCategory? category}) {
    final q = query.trim().toLowerCase();
    return _events.where((e) {
      final matchesCategory = category == null || e.category == category;
      final matchesQuery = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          e.venue.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void add(EventModel event) {
    _events.insert(0, event);
    notifyListeners();
  }

  void update(EventModel event) {
    final i = _events.indexWhere((e) => e.id == event.id);
    if (i >= 0) {
      _events[i] = event;
      notifyListeners();
    }
  }

  void remove(String id) {
    _events.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
