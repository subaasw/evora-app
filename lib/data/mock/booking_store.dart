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
  final Map<String, int> _qty = {};
  final Set<String> _seats = {};
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
      _qty.clear();
      _seats.clear();
      _promo = null;
      _rate = 0;
    }
    notifyListeners();
  }

  int qtyOf(String ticketName) => _qty[ticketName] ?? 0;

  void setQty(String ticketName, int value) {
    if (value <= 0) {
      _qty.remove(ticketName);
    } else {
      _qty[ticketName] = value;
    }
    // Drop seats that no longer fit the (possibly lower) quantity.
    while (_seats.length > seatTarget) {
      _seats.remove(_seats.last);
    }
    notifyListeners();
  }

  int get seatTarget => _qty.values.fold(0, (a, b) => a + b);

  Set<String> get seats => _seats;

  void toggleSeat(String id) {
    if (_seats.contains(id)) {
      _seats.remove(id);
    } else if (_seats.length < seatTarget) {
      _seats.add(id);
    }
    notifyListeners();
  }

  double get subtotal {
    final event = _event;
    if (event == null) return 0;
    var sum = 0.0;
    for (final t in event.ticketTypes) {
      sum += t.price * qtyOf(t.name);
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
      quantities: Map.of(_qty),
      seats: _seats.toList()..sort(),
      total: total,
      bookedAt: DateTime.now(),
    );
    confirmed.insert(0, booking);
    notifyListeners();
    return booking;
  }
}
