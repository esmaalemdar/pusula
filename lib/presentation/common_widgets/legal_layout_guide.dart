// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Legal Layout Guide (Yazım Kılavuzu)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

class LegalLayoutGuide extends StatelessWidget {
  final Widget child;
  final bool showGuide;

  const LegalLayoutGuide({
    super.key,
    required this.child,
    this.showGuide = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Arka Plan Kağıt Görünümü
        Container(color: Theme.of(context).cardColor),
        
        if (showGuide)
          CustomPaint(
            painter: _GuidePainter(
              color: AppColors.accent.withOpacity(0.2),
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
            ),
            size: Size.infinite,
          ),
        
        // İçerik (Marjinler buraya uygulanacak)
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 60, 20, 20), // Görsel marjin simülasyonu
          child: child,
        ),
      ],
    );
  }
}

class _GuidePainter extends CustomPainter {
  final Color color;
  final bool isDarkMode;

  _GuidePainter({required this.color, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Sol Marjin Çizgisi (3.5cm simülasyonu)
    canvas.drawLine(const Offset(35, 0), Offset(35, size.height), paint);

    // Üst Marjin Çizgisi (3.0cm simülasyonu)
    canvas.drawLine(const Offset(0, 50), Offset(size.width, 50), paint);

    // Sağ Marjin Çizgisi (2.0cm simülasyonu)
    canvas.drawLine(Offset(size.width - 20, 0), Offset(size.width - 20, size.height), paint);
    
    // Antetli Başlık Alanı Belirteci (Opsiyonel)
    if (!isDarkMode) {
      canvas.drawRect(
        Rect.fromLTWH(size.width - 100, 10, 80, 30),
        paint..style = PaintingStyle.fill..color = color.withOpacity(0.05),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



