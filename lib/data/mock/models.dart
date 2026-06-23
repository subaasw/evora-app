import 'package:flutter/material.dart';

enum EventCategory { concert, conference, workshop }

extension EventCategoryX on EventCategory {
  String get label => switch (this) {
        EventCategory.concert => 'Concert',
        EventCategory.conference => 'Conference',
        EventCategory.workshop => 'Workshop',
      };

  IconData get icon => switch (this) {
        EventCategory.concert => Icons.music_note,
        EventCategory.conference => Icons.groups_outlined,
        EventCategory.workshop => Icons.handyman_outlined,
      };

  // Accent tokens from the design system's accent palette.
  Color get accent => switch (this) {
        EventCategory.concert => const Color(0xFFD87BA1),
        EventCategory.conference => const Color(0xFF5E6FB4),
        EventCategory.workshop => const Color(0xFFE29F5C),
      };
}

class TicketType {
  const TicketType({required this.name, required this.price, this.maxPerOrder = 10});

  final String name;
  final double price;
  final int maxPerOrder;
}

class EventModel {
  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.venue,
    required this.description,
    required this.ticketTypes,
    required this.seatsLeft,
  });

  final String id;
  final String title;
  final EventCategory category;
  final DateTime date;
  final String venue;
  final String description;
  final List<TicketType> ticketTypes;
  final int seatsLeft;

  bool get soldOut => seatsLeft <= 0;

  double get priceFrom =>
      ticketTypes.map((t) => t.price).reduce((a, b) => a < b ? a : b);
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String formatDay(DateTime d) => '${_months[d.month - 1]} ${d.day}';

String formatTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour < 12 ? 'AM' : 'PM'}';
}
