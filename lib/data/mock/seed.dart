import 'package:evora/data/mock/models.dart';

const _standardTickets = [
  TicketType(name: 'General', price: 25, maxPerOrder: 8),
  TicketType(name: 'VIP', price: 60, maxPerOrder: 4),
  TicketType(name: 'Senior Citizen', price: 18, maxPerOrder: 4),
  TicketType(name: 'Child', price: 12, maxPerOrder: 6),
];

final List<EventModel> seedEvents = [
  EventModel(
    id: 'e1',
    title: 'Midnight Echoes Live',
    category: EventCategory.concert,
    date: DateTime(2026, 7, 4, 19, 30),
    venue: 'HELP Auditorium, Main Hall',
    description:
        'An intimate acoustic evening with Midnight Echoes, performing their '
        'full discography across a two-hour set with a live string section.',
    ticketTypes: _standardTickets,
    seatsLeft: 142,
  ),
  EventModel(
    id: 'e2',
    title: 'FlutterConf 2026',
    category: EventCategory.conference,
    date: DateTime(2026, 7, 12, 9, 0),
    venue: 'HELP Auditorium, Conference Wing',
    description:
        'A full-day developer conference on building beautiful cross-platform '
        'apps, with talks, workshops, and a panel from the core team.',
    ticketTypes: [
      TicketType(name: 'General', price: 40, maxPerOrder: 6),
      TicketType(name: 'VIP', price: 90, maxPerOrder: 2),
    ],
    seatsLeft: 58,
  ),
  EventModel(
    id: 'e3',
    title: 'Watercolour Basics Workshop',
    category: EventCategory.workshop,
    date: DateTime(2026, 7, 18, 14, 0),
    venue: 'HELP Auditorium, Studio 2',
    description:
        'Hands-on introduction to watercolour techniques. Materials provided. '
        'Suitable for complete beginners.',
    ticketTypes: [
      TicketType(name: 'General', price: 30, maxPerOrder: 4),
      TicketType(name: 'Child', price: 15, maxPerOrder: 4),
    ],
    seatsLeft: 12,
  ),
  EventModel(
    id: 'e4',
    title: 'Symphony Under Stars',
    category: EventCategory.concert,
    date: DateTime(2026, 8, 2, 20, 0),
    venue: 'HELP Auditorium, Main Hall',
    description:
        'The city orchestra performs a curated programme of film scores and '
        'classical favourites.',
    ticketTypes: _standardTickets,
    seatsLeft: 0,
  ),
  EventModel(
    id: 'e5',
    title: 'Startup Founders Summit',
    category: EventCategory.conference,
    date: DateTime(2026, 8, 9, 10, 0),
    venue: 'HELP Auditorium, Conference Wing',
    description:
        'Founders and investors share lessons on building, funding, and scaling '
        'early-stage companies.',
    ticketTypes: [
      TicketType(name: 'General', price: 35, maxPerOrder: 6),
      TicketType(name: 'VIP', price: 80, maxPerOrder: 2),
    ],
    seatsLeft: 33,
  ),
  EventModel(
    id: 'e6',
    title: 'Pottery & Clay Lab',
    category: EventCategory.workshop,
    date: DateTime(2026, 8, 16, 11, 0),
    venue: 'HELP Auditorium, Studio 1',
    description:
        'Throw your first bowl on the wheel and learn hand-building basics in a '
        'relaxed half-day session.',
    ticketTypes: [
      TicketType(name: 'General', price: 28, maxPerOrder: 4),
    ],
    seatsLeft: 6,
  ),
];
