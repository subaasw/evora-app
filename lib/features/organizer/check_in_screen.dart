import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import 'package:evora/data/app_role.dart';
import 'package:evora/data/mock/booking_store.dart';
import 'package:evora/theme/app_tokens.dart';
import 'package:evora/theme/sketch_colors.dart';
import 'package:evora/widgets/profile_menu_button.dart';
import 'package:evora/widgets/sketch_box.dart';
import 'package:evora/widgets/sketch_button.dart';

enum _Result { none, success, already, invalid }

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  late final AnimationController _line = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  final Set<String> _checkedIn = {};
  _Result _result = _Result.none;
  Booking? _lastBooking;
  int _scanned = 0;
  String? _lastCode;
  DateTime _lastAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void dispose() {
    _line.dispose();
    _scanner.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;
    final now = DateTime.now();
    if (raw == _lastCode && now.difference(_lastAt).inMilliseconds < 2500) return;
    _lastCode = raw;
    _lastAt = now;
    _handleCode(raw);
  }

  void _handleCode(String raw) {
    final id = raw.startsWith('EVORA-TICKET:') ? raw.substring(13) : raw;
    final confirmed = context.read<BookingStore>().confirmed;
    Booking? match;
    for (final b in confirmed) {
      if (b.id == id) {
        match = b;
        break;
      }
    }
    setState(() {
      _scanned++;
      if (match == null) {
        _result = _Result.invalid;
        _lastBooking = null;
      } else if (_checkedIn.contains(match.id)) {
        _result = _Result.already;
        _lastBooking = match;
      } else {
        _checkedIn.add(match.id);
        _lastBooking = match;
        _result = _Result.success;
      }
    });
  }

  void _simulate() {
    final confirmed = context.read<BookingStore>().confirmed;
    if (confirmed.isEmpty) {
      _handleCode('EVORA-TICKET:none');
      return;
    }
    final next = confirmed.firstWhere(
      (b) => !_checkedIn.contains(b.id),
      orElse: () => confirmed.first,
    );
    _handleCode('EVORA-TICKET:${next.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
        actions: [
          IconButton(
            onPressed: () => _scanner.toggleTorch(),
            icon: const Icon(Icons.flash_on_outlined),
          ),
          IconButton(
            onPressed: () => _scanner.switchCamera(),
            icon: const Icon(Icons.cameraswitch_outlined),
          ),
          ...profileActions(AppRole.organizer),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xl),
        children: [
          Text('Point the camera at an attendee ticket QR to validate entry.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          _ScannerView(controller: _scanner, line: _line, onDetect: _onDetect),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _ResultCard(
              key: ValueKey('${_result}_${_lastBooking?.id}_$_scanned'),
              result: _result,
              booking: _lastBooking,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SketchButton(
            label: 'Simulate scan',
            icon: Icons.qr_code_scanner,
            secondary: true,
            onPressed: _simulate,
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text('$_scanned scanned · ${_checkedIn.length} checked in',
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

class _ScannerView extends StatelessWidget {
  const _ScannerView({
    required this.controller,
    required this.line,
    required this.onDetect,
  });

  final MobileScannerController controller;
  final Animation<double> line;
  final void Function(BarcodeCapture) onDetect;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: s.ink, width: 2)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: s.ink),
              MobileScanner(
                controller: controller,
                onDetect: onDetect,
                fit: BoxFit.cover,
                errorBuilder: (context, error) => _CameraFallback(error: error),
              ),
              IgnorePointer(
                child: CustomPaint(painter: _OverlayPainter(brand: s.brand, animation: line)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraFallback extends StatelessWidget {
  const _CameraFallback({required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined, color: Colors.white54, size: 40),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Camera unavailable here.\nUse "Simulate scan" below.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({required this.brand, required this.animation})
      : super(repaint: animation);

  final Color brand;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final corner = Paint()
      ..color = brand
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const len = 34.0;
    const pad = 28.0;
    void bracket(Offset o, Offset h, Offset v) {
      canvas.drawLine(o, o + h, corner);
      canvas.drawLine(o, o + v, corner);
    }

    bracket(const Offset(pad, pad), const Offset(len, 0), const Offset(0, len));
    bracket(Offset(size.width - pad, pad), const Offset(-len, 0), const Offset(0, len));
    bracket(Offset(pad, size.height - pad), const Offset(len, 0), const Offset(0, -len));
    bracket(Offset(size.width - pad, size.height - pad), const Offset(-len, 0),
        const Offset(0, -len));

    final y = pad + (size.height - pad * 2) * animation.value;
    final line = Paint()
      ..shader = LinearGradient(
        colors: [brand.withValues(alpha: 0), brand, brand.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(pad, y - 2, size.width - pad * 2, 4));
    canvas.drawRect(Rect.fromLTWH(pad, y - 2, size.width - pad * 2, 4), line);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter old) => false;
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({super.key, required this.result, required this.booking});

  final _Result result;
  final Booking? booking;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final theme = Theme.of(context);

    final (Color bg, Color fg, IconData icon, String title, String subtitle) =
        switch (result) {
      _Result.none => (
          s.paperSoft,
          s.bodySubtle,
          Icons.qr_code_scanner,
          'Ready to scan',
          'Point the camera at a ticket QR code.'
        ),
      _Result.success => (
          s.successSoft,
          s.success,
          Icons.check_circle_outline,
          'Valid · entry granted',
          booking == null
              ? ''
              : '${booking!.event.title} · Seats ${booking!.seats.join(', ')} · ${booking!.id}'
        ),
      _Result.already => (
          s.warningSoft,
          s.warning,
          Icons.error_outline,
          'Already checked in',
          'This ticket has already been used for entry.'
        ),
      _Result.invalid => (
          s.dangerSoft,
          s.danger,
          Icons.cancel_outlined,
          'Invalid ticket',
          'Not recognised. Book a ticket as an attendee to test check-in.'
        ),
    };

    return SketchBox(
      fill: bg,
      radius: AppRadius.lg,
      child: Row(
        children: [
          Icon(icon, color: fg, size: 32),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(color: fg)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: s.body)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
