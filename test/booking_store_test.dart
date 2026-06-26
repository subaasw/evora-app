import 'package:flutter_test/flutter_test.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/models.dart';

EventModel _event() => EventModel(
      id: 't1',
      title: 'Test',
      category: EventCategory.concert,
      date: DateTime(2026, 7, 1, 19, 0),
      venue: 'Hall',
      description: '',
      ticketTypes: const [
        TicketType(name: 'General', price: 20),
        TicketType(name: 'VIP', price: 50),
      ],
      seatsLeft: 100,
    );

void main() {
  test('selected seats drive subtotal and per-category quantities', () {
    final store = BookingStore()..start(_event());
    store.toggleSeat('A1', 'VIP'); // 50
    store.toggleSeat('B1', 'General'); // 20
    store.toggleSeat('B2', 'General'); // 20
    expect(store.subtotal, 90);
    expect(store.seatCount, 3);
    expect(store.qtyOf('General'), 2);
    expect(store.qtyOf('VIP'), 1);
    expect(store.quantities, {'VIP': 1, 'General': 2});
  });

  test('tapping a selected seat deselects it', () {
    final store = BookingStore()..start(_event());
    store.toggleSeat('A1', 'General');
    store.toggleSeat('A2', 'General');
    store.toggleSeat('A1', 'General'); // deselect
    expect(store.seats, ['A2']);
    expect(store.subtotal, 20);
  });

  test('valid promo discounts the total, invalid does not', () {
    final store = BookingStore()..start(_event());
    for (var i = 1; i <= 5; i++) {
      store.toggleSeat('A$i', 'General'); // 5 × 20 = 100
    }

    expect(store.applyPromo('nope'), isFalse);
    expect(store.total, 100);

    expect(store.applyPromo('save10'), isTrue); // case-insensitive
    expect(store.discount, 10);
    expect(store.total, 90);

    store.clearPromo();
    expect(store.total, 100);
  });
}
