import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:evora/theme/sketch_colors.dart';

/// A real, scannable QR code for a ticket, on a light tile with a dashed ink
/// frame to match the hand-drawn aesthetic.
class TicketQr extends StatelessWidget {
  const TicketQr({super.key, required this.data, this.size = 200, this.framed = true});

  final String data;
  final double size;
  final bool framed;

  @override
  Widget build(BuildContext context) {
    final s = context.sketch;
    final qr = QrImageView(
      data: 'EVORA-TICKET:$data',
      version: QrVersions.auto,
      size: size,
      gapless: true,
      backgroundColor: const Color(0xFFFFFAF5),
      eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: s.ink),
      dataModuleStyle:
          QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: s.ink),
    );

    if (!framed) return qr;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: s.ink, width: 2),
      ),
      child: qr,
    );
  }
}
