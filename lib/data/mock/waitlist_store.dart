import 'package:flutter/foundation.dart';

/// Tracks which sold-out events the user has joined the waitlist for, plus a
/// mock base count so positions look realistic. UI-only.
class WaitlistStore extends ChangeNotifier {
  final Set<String> _joined = {};

  int _baseCount(String eventId) => (eventId.hashCode % 40).abs() + 8;

  bool isJoined(String eventId) => _joined.contains(eventId);

  /// Total people waiting, including the user once joined.
  int count(String eventId) => _baseCount(eventId) + (isJoined(eventId) ? 1 : 0);

  /// The user's position in line (they join at the back).
  int position(String eventId) => count(eventId);

  void join(String eventId) {
    _joined.add(eventId);
    notifyListeners();
  }

  void leave(String eventId) {
    _joined.remove(eventId);
    notifyListeners();
  }
}
