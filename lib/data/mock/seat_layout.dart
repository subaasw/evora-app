import 'package:flutter/material.dart';

import 'package:evora/data/mock/models.dart';

class Seat {
  const Seat({
    required this.id,
    required this.row,
    required this.col,
    required this.taken,
    required this.category,
  });

  final String id; // e.g. "C5"
  final int row;
  final int col;
  final bool taken;
  final String category; // ticket category name, e.g. "VIP"
}

/// A priced seating tier shown as a coloured band on the map.
class SeatCategory {
  const SeatCategory({required this.name, required this.price, required this.color});

  final String name;
  final double price;
  final Color color;
}

class SeatLayout {
  const SeatLayout({required this.rows, required this.categories, required this.rowCategory});

  final List<List<Seat>> rows;
  final List<SeatCategory> categories; // premium first (front, near stage)
  final List<SeatCategory> rowCategory; // category per row index
}

const _rowLabels = 'ABCDEFGH';
const _seatsPerRow = 12;

// Tier colours, assigned premium-first.
const _palette = [
  Color(0xFFD87BA1), // rose
  Color(0xFF5E6FB4), // indigo
  Color(0xFFE29F5C), // amber
  Color(0xFF6FB07A), // green
];

/// Deterministic auditorium layout: 8 rows of 12. Rows are banded into the
/// event's ticket categories — most expensive nearest the stage — so the map
/// reads as a professional, typed seating chart. Taken seats are derived from
/// the event id so availability looks real.
SeatLayout seatLayoutFor(EventModel event) {
  final tiers = [...event.ticketTypes]..sort((a, b) => b.price.compareTo(a.price));
  final categories = [
    for (var i = 0; i < tiers.length; i++)
      SeatCategory(
        name: tiers[i].name,
        price: tiers[i].price,
        color: _palette[i % _palette.length],
      ),
  ];

  // Contiguous band per category across the 8 rows.
  final k = categories.length;
  final rowCategory = [
    for (var r = 0; r < _rowLabels.length; r++)
      categories[(r * k) ~/ _rowLabels.length],
  ];

  final seed = event.id.hashCode;
  final rows = <List<Seat>>[];
  for (var r = 0; r < _rowLabels.length; r++) {
    final row = <Seat>[];
    for (var c = 0; c < _seatsPerRow; c++) {
      final taken = !event.soldOut && (seed + r * 7 + c * 13) % 6 == 0;
      row.add(Seat(
        id: '${_rowLabels[r]}${c + 1}',
        row: r,
        col: c,
        taken: event.soldOut || taken,
        category: rowCategory[r].name,
      ));
    }
    rows.add(row);
  }

  return SeatLayout(rows: rows, categories: categories, rowCategory: rowCategory);
}
