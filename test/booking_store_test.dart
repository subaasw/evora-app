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
  test('subtotal sums quantity × price', () {
    final store = BookingStore()..start(_event());
    store.setQty('General', 2); // 40
    store.setQty('VIP', 1); // 50
    expect(store.subtotal, 90);
    expect(store.seatTarget, 3);
  });

  test('seat selection is capped at the ticket count', () {
    final store = BookingStore()..start(_event());
    store.setQty('General', 2);
    store.toggleSeat('A1');
    store.toggleSeat('A2');
    store.toggleSeat('A3'); // rejected — over cap
    expect(store.seats, {'A1', 'A2'});

    store.toggleSeat('A1'); // deselect
    expect(store.seats, {'A2'});
  });

  test('lowering quantity drops overflowing seats', () {
    final store = BookingStore()..start(_event());
    store.setQty('General', 3);
    store.toggleSeat('A1');
    store.toggleSeat('A2');
    store.toggleSeat('A3');
    store.setQty('General', 1);
    expect(store.seats.length, 1);
  });

  test('valid promo discounts the total, invalid does not', () {
    final store = BookingStore()..start(_event());
    store.setQty('General', 5); // 100

    expect(store.applyPromo('nope'), isFalse);
    expect(store.total, 100);

    expect(store.applyPromo('save10'), isTrue); // case-insensitive
    expect(store.discount, 10);
    expect(store.total, 90);

    store.clearPromo();
    expect(store.total, 100);
  });
}
