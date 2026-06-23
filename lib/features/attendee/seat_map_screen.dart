import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/data/mock/event_store.dart';
import 'package:evora/data/mock/seat_layout.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/checkout_bar.dart';
import 'package:evora/widgets/sketch_box.dart';

const _rowLetters = 'ABCDEFGH';

class SeatMapScreen extends StatelessWidget {
  const SeatMapScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<BookingStore>();
    final event = context.read<EventStore>().byId(eventId);
    final layout = seatLayoutFor(event);
    final remaining = store.seatTarget - store.seats.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Pick seats')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        children: [
          const _Stage(),
          const SizedBox(height: AppSpacing.lg),
          _SeatGrid(layout: layout, store: store),
          const SizedBox(height: AppSpacing.lg),
          const _Legend(),
        ],
      ),
      bottomNavigationBar: CheckoutBar(
        subtitle: remaining > 0
            ? 'Select $remaining more seat(s)'
            : '${store.seats.length} selected · ${store.seats.join(', ')}',
        amount: store.subtotal,
        enabled: remaining == 0 && store.seatTarget > 0,
        label: 'Review order',
        onPressed: () => context.push('/event/$eventId/cart'),
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage();

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Column(
      children: [
        Container(
          height: 38,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [s.brand, s.brandStrong]),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(40),
              bottom: Radius.circular(8),
            ),
            border: Border.all(color: s.ink, width: 2),
          ),
          child: Text(
            'S T A G E',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({required this.layout, required this.store});

  final SeatLayout layout;
  final BookingStore store;

  @override
  Widget build(BuildContext context) {
    String? lastSection;
    final children = <Widget>[];

    for (var r = 0; r < layout.rows.length; r++) {
      final section = layout.sectionForRow(r);
      if (section != lastSection) {
        children.add(_SectionLabel(label: section));
        lastSection = section;
      }
      children.add(_SeatRow(letter: _rowLetters[r], seats: layout.rows[r], store: store));
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(children: children),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 28, height: 2, color: s.borderDefault),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: s.bodySubtle,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Container(width: 28, height: 2, color: s.borderDefault),
        ],
      ),
    );
  }
}

class _SeatRow extends StatelessWidget {
  const _SeatRow({required this.letter, required this.seats, required this.store});

  final String letter;
  final List<Seat> seats;
  final BookingStore store;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final mid = seats.length ~/ 2;

    Widget label() => SizedBox(
          width: 22,
          child: Text(
            letter,
            textAlign: TextAlign.center,
            style: TextStyle(color: s.bodySubtle, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          label(),
          for (var i = 0; i < seats.length; i++) ...[
            if (i == mid) const SizedBox(width: 18), // aisle
            _SeatBox(
              seat: seats[i],
              selected: store.seats.contains(seats[i].id),
              onTap: () => store.toggleSeat(seats[i].id),
            ),
          ],
          label(),
        ],
      ),
    );
  }
}

class _SeatBox extends StatelessWidget {
  const _SeatBox({required this.seat, required this.selected, required this.onTap});

  final Seat seat;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final Color fill;
    if (seat.taken) {
      fill = s.borderDefault;
    } else if (selected) {
      fill = s.brand;
    } else {
      fill = s.brandSofter;
    }
    return GestureDetector(
      onTap: seat.taken ? null : onTap,
      child: Container(
        width: 26,
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(8),
            bottom: Radius.circular(4),
          ),
          border: Border.all(color: seat.taken ? s.borderDefault : s.ink, width: 1.5),
        ),
        child: selected
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return SketchBox(
      fill: s.paperSoft,
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _LegendItem(color: s.brandSofter, label: 'Available'),
          _LegendItem(color: s.brand, label: 'Selected'),
          _LegendItem(color: s.borderDefault, label: 'Taken'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
              bottom: Radius.circular(3),
            ),
            border: Border.all(color: context.sketch.ink, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
