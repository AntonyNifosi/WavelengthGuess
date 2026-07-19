import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/constants.dart';

/// Painter du dial Wavelength — le demi-cercle spectral.
///
/// Dessine :
/// - Le fond du demi-cercle avec un dégradé spectral
/// - La zone cible (si [showTarget] est true)
/// - L'aiguille du guesser
class WavelengthDialPainter extends CustomPainter {
  /// Position de la cible (0.0 = gauche, 1.0 = droite).
  final double targetPosition;

  /// Position du guess (0.0 = gauche, 1.0 = droite).
  final double guessPosition;

  /// Si true, affiche la zone cible.
  final bool showTarget;

  /// Si true, affiche l'aiguille.
  final bool showNeedle;

  /// Progression de l'animation de révélation (0.0 → 1.0).
  final double revealProgress;

  /// Si l'aiguille est en cours de drag.
  final bool isDragging;

  WavelengthDialPainter({
    required this.targetPosition,
    required this.guessPosition,
    required this.showTarget,
    this.showNeedle = true,
    this.revealProgress = 1.0,
    this.isDragging = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width / 2, size.height) * 0.9;
    final center = Offset(size.width / 2, (size.height + radius) / 2);

    _drawDialBackground(canvas, center, radius);
    _drawDialSegments(canvas, center, radius);

    if (showTarget) {
      _drawTargetZone(canvas, center, radius);
    }

    if (showNeedle) {
      _drawNeedle(canvas, center, radius);
    }
    _drawCenterKnob(canvas, center);
  }

  /// Dessine le fond du demi-cercle.
  void _drawDialBackground(Canvas canvas, Offset center, double radius) {
    // Ombre extérieure glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20)
      ..shader = SweepGradient(
        startAngle: pi,
        endAngle: 2 * pi,
        colors: WavelengthColors.dialGradient,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      glowPaint,
    );

    // Fond sombre du dial
    final bgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = WavelengthColors.surface;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      true,
      bgPaint,
    );

    // Bordure extérieure
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        startAngle: pi,
        endAngle: 2 * pi,
        colors: WavelengthColors.dialGradient,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      borderPaint,
    );
  }

  /// Dessine les segments/ticks du dial.
  void _drawDialSegments(Canvas canvas, Offset center, double radius) {
    final tickPaint = Paint()
      ..color = WavelengthColors.textMuted.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Ticks mineurs tous les 10°
    for (int i = 0; i <= 18; i++) {
      final angle = pi + (i / 18) * pi;
      final innerR = radius * 0.92;
      final outerR = radius * 0.97;
      final start = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final end = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

  }

  /// Dessine la zone cible avec les 3 zones de score.
  void _drawTargetZone(Canvas canvas, Offset center, double radius) {
    // Convertir targetPosition (0-1) en angle (pi - 2*pi)
    final targetAngle = pi + targetPosition * pi;

    // Les demi-largeurs en radians
    final bullseyeHalf =
        (GameConstants.bullseyeDegrees / 2) * (pi / 180);
    final closeHalf =
        (GameConstants.bullseyeDegrees / 2 + GameConstants.closeDegrees) *
            (pi / 180);
    final farHalf =
        (GameConstants.bullseyeDegrees / 2 +
                GameConstants.closeDegrees +
                GameConstants.farDegrees) *
            (pi / 180);

    // Appliquer la progression de révélation
    final currentFarHalf = farHalf * revealProgress;
    final currentCloseHalf = closeHalf * revealProgress;
    final currentBullseyeHalf = bullseyeHalf * revealProgress;

    // Zone extérieure (violette)
    _drawArcZone(
      canvas,
      center,
      radius * 0.88,
      targetAngle - currentFarHalf,
      currentFarHalf * 2,
      WavelengthColors.farZone.withValues(alpha: 0.5 * revealProgress),
    );

    // Zone intermédiaire (orange)
    _drawArcZone(
      canvas,
      center,
      radius * 0.88,
      targetAngle - currentCloseHalf,
      currentCloseHalf * 2,
      WavelengthColors.closeZone.withValues(alpha: 0.6 * revealProgress),
    );

    // Bullseye (jaune)
    _drawArcZone(
      canvas,
      center,
      radius * 0.88,
      targetAngle - currentBullseyeHalf,
      currentBullseyeHalf * 2,
      WavelengthColors.bullseye.withValues(alpha: 0.7 * revealProgress),
    );

    // Ligne centrale de la cible retirée pour éviter la confusion avec l'aiguille.

    // Affichage des points (2, 3, 4) dans chaque section
    if (revealProgress > 0.3) {
      final textAlpha = ((revealProgress - 0.3) / 0.7).clamp(0.0, 1.0);
      final textDistance = radius * 0.80; // Placement des textes près du bord extérieur
      
      void drawPoints(int points, double angleOffset) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: points.toString(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: textAlpha * 0.9),
              fontSize: max(12.0, radius * 0.055),
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        
        final angle = targetAngle + angleOffset;
        final position = Offset(
          center.dx + textDistance * cos(angle),
          center.dy + textDistance * sin(angle),
        );
        
        canvas.save();
        canvas.translate(position.dx, position.dy);
        // On pivote le texte pour qu'il soit perpendiculaire au rayon du cercle
        canvas.rotate(angle + pi / 2);
        textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
        canvas.restore();
      }

      final rad8 = 8 * (pi / 180);
      final rad15 = 15 * (pi / 180);

      drawPoints(GameConstants.farPoints, -rad15);
      drawPoints(GameConstants.farPoints, rad15);
      drawPoints(GameConstants.closePoints, -rad8);
      drawPoints(GameConstants.closePoints, rad8);
      drawPoints(GameConstants.bullseyePoints, 0);
    }
  }

  void _drawArcZone(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Color color,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      true,
      paint,
    );
  }

  /// Dessine l'aiguille du guesser.
  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    final needleAngle = pi + guessPosition * pi;
    final needleLength = radius * 0.82;

    // Ombre de l'aiguille
    final shadowPaint = Paint()
      ..color = WavelengthColors.cyan.withValues(alpha: isDragging ? 0.4 : 0.2)
      ..strokeWidth = isDragging ? 5 : 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDragging ? 12 : 6);

    canvas.drawLine(
      center,
      Offset(
        center.dx + needleLength * cos(needleAngle),
        center.dy + needleLength * sin(needleAngle),
      ),
      shadowPaint,
    );

    // Aiguille principale
    final needlePaint = Paint()
      ..color = WavelengthColors.cyan
      ..strokeWidth = isDragging ? 4 : 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        center.dx + needleLength * cos(needleAngle),
        center.dy + needleLength * sin(needleAngle),
      ),
      needlePaint,
    );

    // Point lumineux au bout
    final tipPaint = Paint()
      ..color = WavelengthColors.cyan
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(
        center.dx + needleLength * cos(needleAngle),
        center.dy + needleLength * sin(needleAngle),
      ),
      isDragging ? 6 : 4,
      tipPaint,
    );

    canvas.drawCircle(
      Offset(
        center.dx + needleLength * cos(needleAngle),
        center.dy + needleLength * sin(needleAngle),
      ),
      isDragging ? 4 : 3,
      Paint()..color = Colors.white,
    );
  }

  /// Dessine le bouton central du dial.
  void _drawCenterKnob(Canvas canvas, Offset center) {
    // Cercle extérieur (glow)
    canvas.drawCircle(
      center,
      14,
      Paint()
        ..color = WavelengthColors.cyan.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Cercle principal
    canvas.drawCircle(
      center,
      10,
      Paint()..color = WavelengthColors.surface,
    );

    // Bordure
    canvas.drawCircle(
      center,
      10,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = WavelengthColors.cyan
        ..strokeWidth = 2,
    );

    // Point intérieur
    canvas.drawCircle(
      center,
      3,
      Paint()..color = WavelengthColors.cyan,
    );
  }

  @override
  bool shouldRepaint(WavelengthDialPainter oldDelegate) {
    return oldDelegate.targetPosition != targetPosition ||
        oldDelegate.guessPosition != guessPosition ||
        oldDelegate.showTarget != showTarget ||
        oldDelegate.showNeedle != showNeedle ||
        oldDelegate.revealProgress != revealProgress ||
        oldDelegate.isDragging != isDragging;
  }
}

/// Widget du dial Wavelength avec gestion des gestes.
class WavelengthDial extends StatefulWidget {
  /// Position de la cible (0.0 - 1.0).
  final double targetPosition;

  /// Position initiale du guess.
  final double guessPosition;

  /// Si true, affiche la zone cible.
  final bool showTarget;

  /// Si true, affiche l'aiguille.
  final bool showNeedle;

  /// Si true, l'aiguille est déplaçable.
  final bool interactive;

  /// Callback quand le guess change.
  final ValueChanged<double>? onGuessChanged;

  /// Si true, joue l'animation de révélation.
  final bool animateReveal;

  const WavelengthDial({
    super.key,
    required this.targetPosition,
    required this.guessPosition,
    this.showTarget = false,
    this.showNeedle = true,
    this.interactive = false,
    this.onGuessChanged,
    this.animateReveal = false,
  });

  @override
  State<WavelengthDial> createState() => _WavelengthDialState();
}

class _WavelengthDialState extends State<WavelengthDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;
  bool _isDragging = false;
  double _currentGuess = 0.5;

  @override
  void initState() {
    super.initState();
    _currentGuess = widget.guessPosition;

    _revealController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: GameConstants.revealDurationMs),
    );

    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutCubic,
    );

    if (widget.animateReveal) {
      // Délai court avant de lancer l'animation
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _revealController.forward();
      });
    } else if (widget.showTarget) {
      _revealController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(WavelengthDial oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animateReveal && !oldWidget.animateReveal) {
      _revealController.forward(from: 0);
    }
    if (!widget.interactive) {
      _currentGuess = widget.guessPosition;
    }
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    if (!widget.interactive) return;
    setState(() => _isDragging = true);
  }

  void _handlePanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (!widget.interactive) return;

    final radius = min(constraints.maxWidth / 2, constraints.maxHeight) * 0.9;
    final center = Offset(
      constraints.maxWidth / 2,
      (constraints.maxHeight + radius) / 2,
    );

    final dx = details.localPosition.dx - center.dx;
    final dy = details.localPosition.dy - center.dy;

    // Calculer l'angle par rapport au centre
    var angle = atan2(dy, dx);

    // Convertir en position 0.0 - 1.0 sur le demi-cercle supérieur
    // angle va de -pi (gauche) à 0 (droite) pour la partie supérieure
    // et de 0 (droite) à pi (gauche) pour la partie inférieure

    // On veut mapper pi → 0.0 et 0/2pi → 1.0
    if (angle > 0) {
      // En dessous du centre, ignorer
      return;
    }

    // angle est entre -pi et 0
    // -pi = tout à gauche = 0.0
    // 0 = tout à droite = 1.0
    final position = (angle + pi) / pi;

    setState(() {
      _currentGuess = position.clamp(0.0, 1.0);
    });
    widget.onGuessChanged?.call(_currentGuess);
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!widget.interactive) return;
    setState(() => _isDragging = false);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanStart: _handlePanStart,
            onPanUpdate: (details) =>
                _handlePanUpdate(details, constraints),
            onPanEnd: _handlePanEnd,
            child: AnimatedBuilder(
              animation: _revealAnimation,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: WavelengthDialPainter(
                    targetPosition: widget.targetPosition,
                    guessPosition: _currentGuess,
                    showTarget: widget.showTarget,
                    showNeedle: widget.showNeedle,
                    revealProgress: _revealAnimation.value,
                    isDragging: _isDragging,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
