import 'package:flutter/foundation.dart';

import 'package:evora/data/mock/models.dart';

class PromoCode {
  const PromoCode(this.code, this.rate);
  final String code;
  final double rate;
}

const _promos = [
  PromoCode('SAVE10', 0.10),
  PromoCode('VIP20', 0.20),
];

class Booking {
  const Booking({
    required this.id,
    required this.event,
    required this.quantities,
    required this.seats,
    required this.total,
    required this.bookedAt,
  });

  final String id;
  final EventModel event;
  final Map<String, int> quantities;
  final List<String> seats;
  final double total;
  final DateTime bookedAt;
}

/// Holds the in-progress booking session plus confirmed bookings. UI-only:
/// nothing is persisted or sent anywhere.
class BookingStore extends ChangeNotifier {
  EventModel? _event;
  // Selected seats drive the whole order: seat id -> ticket category name.
  final Map<String, String> _seatCat = {};
  final Map<String, double> _price = {}; // category name -> price
  String? _promo;
  double _rate = 0;

  final List<Booking> confirmed = [];

  Booking? bookingById(String id) =>
      confirmed.where((b) => b.id == id).firstOrNull;

  EventModel? get event => _event;

  /// Begin (or reset) a session for [event].
  void start(EventModel event) {
    if (_event?.id != event.id) {
      _event = event;
      _seatCat.clear();
      _promo = null;
      _rate = 0;
    }
    _price
      ..clear()
      ..addEntries(event.ticketTypes.map((t) => MapEntry(t.name, t.price)));
    notifyListeners();
  }

  /// Seats selected, sorted for a stable display order.
  List<String> get seats => _seatCat.keys.toList()..sort();
  int get seatCount => _seatCat.length;
  bool isSelected(String id) => _seatCat.containsKey(id);

  /// Toggle a seat in [category]. No upfront cap — the seats you tap are the
  /// tickets you buy.
  void toggleSeat(String id, String category) {
    if (_seatCat.containsKey(id)) {
      _seatCat.remove(id);
    } else {
      _seatCat[id] = category;
    }
    notifyListeners();
  }

  int qtyOf(String ticketName) =>
      _seatCat.values.where((c) => c == ticketName).length;

  /// Per-category counts, derived from the selected seats.
  Map<String, int> get quantities {
    final m = <String, int>{};
    for (final c in _seatCat.values) {
      m[c] = (m[c] ?? 0) + 1;
    }
    return m;
  }

  double get subtotal {
    var sum = 0.0;
    for (final c in _seatCat.values) {
      sum += _price[c] ?? 0;
    }
    return sum;
  }

  String? get promo => _promo;
  double get discount => subtotal * _rate;
  double get total => subtotal - discount;

  bool applyPromo(String code) {
    final match = _promos.where((p) => p.code == code.trim().toUpperCase());
    if (match.isEmpty) return false;
    _promo = match.first.code;
    _rate = match.first.rate;
    notifyListeners();
    return true;
  }

  void clearPromo() {
    _promo = null;
    _rate = 0;
    notifyListeners();
  }

  Booking confirm() {
    final booking = Booking(
      id: 'EVO-${DateTime.now().millisecondsSinceEpoch % 100000}',
      event: _event!,
      quantities: quantities,
      seats: seats,
      total: total,
      bookedAt: DateTime.now(),
    );
    confirmed.insert(0, booking);
    notifyListeners();
    return booking;
  }
}
