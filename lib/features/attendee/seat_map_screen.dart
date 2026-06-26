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

    return Scaffold(
      appBar: AppBar(title: const Text('Choose seats')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        children: [
          const _Screen(),
          const SizedBox(height: AppSpacing.lg),
          _SeatGrid(layout: layout, store: store),
          const SizedBox(height: AppSpacing.lg),
          _CategoryLegend(categories: layout.categories),
        ],
      ),
      bottomNavigationBar: CheckoutBar(
        subtitle: store.seatCount == 0
            ? 'Tap seats to select'
            : '${store.seatCount} seat(s) · ${store.seats.join(', ')}',
        amount: store.subtotal,
        enabled: store.seatCount > 0,
        label: 'Review order',
        onPressed: () => context.push('/event/$eventId/cart'),
      ),
    );
  }
}

/// Curved cinema-style screen arc at the top of the map.
class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return Column(
      children: [
        SizedBox(
          height: 44,
          width: double.infinity,
          child: CustomPaint(painter: _ScreenPainter(s.brand, s.brandStrong, s.ink)),
        ),
        const SizedBox(height: 6),
        Text(
          'S C R E E N',
          style: TextStyle(
            color: s.bodySubtle,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _ScreenPainter extends CustomPainter {
  _ScreenPainter(this.brand, this.brandStrong, this.ink);

  final Color brand;
  final Color brandStrong;
  final Color ink;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = 32.0;
    final path = Path()
      ..moveTo(inset, size.height)
      ..quadraticBezierTo(size.width / 2, -size.height * 0.5,
          size.width - inset, size.height)
      ..lineTo(size.width - inset + 10, size.height)
      ..quadraticBezierTo(size.width / 2, -size.height * 0.5 + 14,
          inset - 10, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()..shader = LinearGradient(colors: [brand, brandStrong]).createShader(
          Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _ScreenPainter old) => false;
}

class _SeatGrid extends StatelessWidget {
  const _SeatGrid({required this.layout, required this.store});

  final SeatLayout layout;
  final BookingStore store;

  @override
  Widget build(BuildContext context) {
    SeatCategory? lastCat;
    final children = <Widget>[];

    for (var r = 0; r < layout.rows.length; r++) {
      final cat = layout.rowCategory[r];
      if (cat != lastCat) {
        children.add(_CategoryHeader(category: cat));
        lastCat = cat;
      }
      children.add(_SeatRow(
        letter: _rowLetters[r],
        seats: layout.rows[r],
        color: cat.color,
        store: store,
      ));
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(children: children),
    );
  }
}

/// Typed, coloured tier divider: category name + price on a soft pill.
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});

  final SeatCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: category.color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: category.color, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: category.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              category.name.toUpperCase(),
              style: TextStyle(
                color: category.color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${category.price.toStringAsFixed(0)}',
              style: TextStyle(
                color: category.color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatRow extends StatelessWidget {
  const _SeatRow({
    required this.letter,
    required this.seats,
    required this.color,
    required this.store,
  });

  final String letter;
  final List<Seat> seats;
  final Color color;
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
              color: color,
              selected: store.isSelected(seats[i].id),
              onTap: () => store.toggleSeat(seats[i].id, seats[i].category),
            ),
          ],
          label(),
        ],
      ),
    );
  }
}

class _SeatBox extends StatelessWidget {
  const _SeatBox({
    required this.seat,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Seat seat;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final Color fill;
    final Color border;
    if (seat.taken) {
      fill = s.borderDefault;
      border = s.borderDefault;
    } else if (selected) {
      fill = color;
      border = s.ink;
    } else {
      fill = color.withValues(alpha: 0.18);
      border = color;
    }
    return GestureDetector(
      onTap: seat.taken ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 26,
        height: 26,
        margin: const EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
          color: fill,
          // Curved seat: rounded back, squared-off front edge.
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(13),
            bottom: Radius.circular(5),
          ),
          border: Border.all(color: border, width: 1.5),
        ),
        child: selected
            ? const Icon(Icons.check, size: 14, color: Colors.white)
            : null,
      ),
    );
  }
}

class _CategoryLegend extends StatelessWidget {
  const _CategoryLegend({required this.categories});

  final List<SeatCategory> categories;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return SketchBox(
      fill: s.paperSoft,
      radius: AppRadius.lg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              for (final c in categories)
                _LegendItem(color: c.color, label: '${c.name}  \$${c.price.toStringAsFixed(0)}'),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          Row(
            children: [
              _LegendItem(color: s.borderDefault, label: 'Taken'),
              const SizedBox(width: 18),
              _LegendItem(color: s.brand, label: 'Selected', filled: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label, this.filled = false});

  final Color color;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: filled ? color : color.withValues(alpha: 0.18),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(9),
              bottom: Radius.circular(4),
            ),
            border: Border.all(color: color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
