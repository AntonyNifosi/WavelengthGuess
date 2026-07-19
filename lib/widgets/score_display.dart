import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'glass_card.dart';

/// Affichage du score avec animation.
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int maxScore;
  final int currentRound;
  final int totalRounds;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.maxScore,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      borderRadius: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Manche
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'MANCHE',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WavelengthColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                '$currentRound / $totalRounds',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: WavelengthColors.textPrimary,
                    ),
              ),
            ],
          ),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SCORE',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: WavelengthColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$score',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: WavelengthColors.cyan,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    ' / $maxScore',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: WavelengthColors.textMuted,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Affichage animé du score d'une manche.
class RoundScoreAnimation extends StatefulWidget {
  final int points;

  const RoundScoreAnimation({
    super.key,
    required this.points,
  });

  @override
  State<RoundScoreAnimation> createState() => _RoundScoreAnimationState();
}

class _RoundScoreAnimationState extends State<RoundScoreAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Lancer l'animation après un court délai (attente de la révélation)
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor() {
    switch (widget.points) {
      case 4:
        return WavelengthColors.bullseye;
      case 3:
        return WavelengthColors.closeZone;
      case 2:
        return WavelengthColors.farZone;
      default:
        return WavelengthColors.textMuted;
    }
  }

  String _getScoreLabel() {
    switch (widget.points) {
      case 4:
        return 'BULLSEYE ! 🎯';
      case 3:
        return 'PROCHE ! 👏';
      case 2:
        return 'PAS MAL 👍';
      default:
        return 'RATÉ 😬';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '+${widget.points}',
                  style:
                      Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: _getScoreColor(),
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                color:
                                    _getScoreColor().withValues(alpha: 0.6),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getScoreLabel(),
                  style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: _getScoreColor(),
                            fontWeight: FontWeight.w700,
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
