import 'package:flutter_test/flutter_test.dart';

import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/models.dart';
import 'package:evora/data/mock/organizer_store.dart';
import 'package:evora/data/mock/organizers.dart';

EventModel _event(String id, String title, EventCategory cat) => EventModel(
      id: id,
      title: title,
      category: cat,
      date: DateTime(2026, 8, 1, 19, 0),
      venue: 'Hall',
      description: '',
      ticketTypes: const [TicketType(name: 'General', price: 20)],
      seatsLeft: 50,
    );

void main() {
  group('EventStore', () {
    test('add / update / remove mutate the list', () {
      final store = EventStore();
      final before = store.events.length;

      store.add(_event('x1', 'New Show', EventCategory.concert));
      expect(store.events.length, before + 1);
      expect(store.byId('x1').title, 'New Show');

      store.update(_event('x1', 'Renamed Show', EventCategory.concert));
      expect(store.byId('x1').title, 'Renamed Show');

      store.remove('x1');
      expect(store.events.length, before);
    });

    test('search filters by query and category', () {
      final store = EventStore()
        ..add(_event('s1', 'Jazz Night', EventCategory.concert))
        ..add(_event('s2', 'AI Summit', EventCategory.conference));

      expect(store.search(query: 'jazz').map((e) => e.id), contains('s1'));
      expect(store.search(query: 'jazz').map((e) => e.id), isNot(contains('s2')));

      final concerts = store.search(category: EventCategory.conference);
      expect(concerts.every((e) => e.category == EventCategory.conference), isTrue);
    });
  });

  group('OrganizerStore', () {
    test('add inserts and emailExists detects duplicates', () {
      final store = OrganizerStore();
      expect(store.emailExists('brand@new.com'), isFalse);

      store.add(const Organizer(
        name: 'Sam Lee',
        org: 'Indie Co',
        email: 'brand@new.com',
        phone: '123',
        events: 0,
      ));
      expect(store.emailExists('BRAND@NEW.COM'), isTrue); // case-insensitive
      expect(store.search('sam').first.name, 'Sam Lee');
    });
  });
}
