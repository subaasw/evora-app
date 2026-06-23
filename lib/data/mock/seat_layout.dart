import 'package:evora/data/mock/models.dart';

class Seat {
  const Seat({required this.id, required this.row, required this.col, required this.taken});

  final String id; // e.g. "C5"
  final int row;
  final int col;
  final bool taken;
}

class SeatLayout {
  const SeatLayout({required this.rows, required this.sectionForRow});

  final List<List<Seat>> rows;

  /// Maps a row index to a ticket-category label for the legend/colour bands.
  final String Function(int row) sectionForRow;
}

const _rowLabels = 'ABCDEFGH';
const _seatsPerRow = 12;

/// Deterministic auditorium layout (Fig. 1): 8 rows of 12, with a stable set of
/// already-taken seats derived from the event id so availability looks real.
SeatLayout seatLayoutFor(EventModel event) {
  final seed = event.id.hashCode;
  final rows = <List<Seat>>[];
  for (var r = 0; r < _rowLabels.length; r++) {
    final row = <Seat>[];
    for (var c = 0; c < _seatsPerRow; c++) {
      final taken = !event.soldOut && (seed + r * 7 + c * 13) % 6 == 0;
      row.add(Seat(id: '${_rowLabels[r]}${c + 1}', row: r, col: c, taken: event.soldOut || taken));
    }
    rows.add(row);
  }

  String section(int r) {
    if (r < 2) return 'VIP';
    if (r < 5) return 'General';
    if (r < 7) return 'Senior Citizen';
    return 'Child';
  }

  return SeatLayout(rows: rows, sectionForRow: section);
}
