import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../models/game_state.dart';
import '../widgets/glass_card.dart';

/// Écran du score final après toutes les manches.
class FinalScoreScreen extends StatefulWidget {
  const FinalScoreScreen({super.key});

  @override
  State<FinalScoreScreen> createState() => _FinalScoreScreenState();
}

class _FinalScoreScreenState extends State<FinalScoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getVerdict(double percentage) {
    if (percentage >= 0.9) return '🏆 INCROYABLE !';
    if (percentage >= 0.75) return '🌟 EXCELLENT !';
    if (percentage >= 0.6) return '👏 BIEN JOUÉ !';
    if (percentage >= 0.4) return '👍 PAS MAL !';
    if (percentage >= 0.2) return '🤔 PEUT MIEUX FAIRE';
    return '😅 PROCHAINE FOIS !';
  }

  Color _getVerdictColor(double percentage) {
    if (percentage >= 0.75) return WavelengthColors.bullseye;
    if (percentage >= 0.5) return WavelengthColors.closeZone;
    if (percentage >= 0.25) return WavelengthColors.farZone;
    return WavelengthColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, game, _) {
        final percentage = game.scorePercentage;
        final verdictColor = _getVerdictColor(percentage);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.2,
                colors: [
                  verdictColor.withValues(alpha: 0.15),
                  WavelengthColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),
                        // Verdict
                        Text(
                          _getVerdict(percentage),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: verdictColor,
                                fontWeight: FontWeight.w900,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Score principal
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32, horizontal: 24),
                          borderColor: verdictColor.withValues(alpha: 0.3),
                          child: Column(
                            children: [
                              Text(
                                'SCORE FINAL',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: WavelengthColors.textMuted,
                                      letterSpacing: 3,
                                      fontSize: 13,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${game.score}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          color: verdictColor,
                                          fontSize: 72,
                                          fontWeight: FontWeight.w900,
                                          shadows: [
                                            Shadow(
                                              color: verdictColor
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                  ),
                                  Text(
                                    ' / ${game.maxScore}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: WavelengthColors.textMuted,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Barre de progression
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: percentage,
                                  minHeight: 8,
                                  backgroundColor:
                                      WavelengthColors.surfaceLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      verdictColor),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Détail par manche
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                alignment: WrapAlignment.center,
                                children: game.roundScores
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final i = entry.key;
                                  final score = entry.value;
                                  return Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      color: _getScoreChipColor(score)
                                          .withValues(alpha: 0.2),
                                      border: Border.all(
                                        color: _getScoreChipColor(score)
                                            .withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$score',
                                        style: TextStyle(
                                          color: _getScoreChipColor(score),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 1),
                        // Boutons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                game.startGame(game.totalRounds),
                            child: const Text('REJOUER'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => game.goHome(),
                            child: const Text('MENU PRINCIPAL'),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getScoreChipColor(int score) {
    switch (score) {
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
}
