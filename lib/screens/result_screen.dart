import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/game_state.dart';
import '../widgets/wavelength_dial.dart';
import '../widgets/spectrum_labels.dart';
import '../widgets/score_display.dart';

/// Écran de résultat : révélation de la cible et score de la manche.
class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _revealController;
  late AnimationController _scoreController;
  late Animation<double> _scoreScale;
  late Animation<double> _scoreOpacity;
  bool _showScore = false;

  @override
  void initState() {
    super.initState();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scoreScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.elasticOut),
    );

    _scoreOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scoreController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Séquence : révélation puis score
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _revealController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _showScore = true);
        _scoreController.forward();
      }
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Color _getScoreColor(int points) {
    switch (points) {
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

  String _getScoreEmoji(int points) {
    switch (points) {
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
    return Consumer<GameState>(
      builder: (context, game, _) {
        final card = game.currentCard!;
        final lastScore = game.roundScores.isNotEmpty
            ? game.roundScores.last
            : 0;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 1.3,
                colors: [
                  Color(0xFF1A1040),
                  WavelengthColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    // Score header
                    ScoreDisplay(
                      score: game.score,
                      maxScore: game.maxScore,
                      currentRound: game.currentRound,
                      totalRounds: game.totalRounds,
                    ),
                    const SizedBox(height: 8),
                    // Titre
                    Text(
                      'RÉVÉLATION',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            letterSpacing: 3,
                            color: WavelengthColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    // Dial avec révélation animée
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WavelengthDial(
                            targetPosition: game.targetPosition,
                            guessPosition: game.guessPosition,
                            showTarget: true,
                            interactive: false,
                            animateReveal: true,
                          ),
                          // Score animé superposé
                          if (_showScore)
                            AnimatedBuilder(
                              animation: _scoreController,
                              builder: (context, _) {
                                return Opacity(
                                  opacity: _scoreOpacity.value,
                                  child: Transform.scale(
                                    scale: _scoreScale.value,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '+$lastScore',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                color: _getScoreColor(
                                                    lastScore),
                                                fontSize: 56,
                                                fontWeight: FontWeight.w900,
                                                shadows: [
                                                  Shadow(
                                                    color: _getScoreColor(
                                                            lastScore)
                                                        .withValues(
                                                            alpha: 0.6),
                                                    blurRadius: 30,
                                                  ),
                                                ],
                                              ),
                                        ),
                                        Text(
                                          _getScoreEmoji(lastScore),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                color: _getScoreColor(
                                                    lastScore),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Labels
                    SpectrumLabels(
                      left: card.left,
                      right: card.right,
                    ),
                    const SizedBox(height: 24),
                    // Bouton suivant
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => game.nextRoundOrEnd(),
                        child: Text(
                          game.currentRound >= game.totalRounds
                              ? 'VOIR LE RÉSULTAT FINAL'
                              : 'MANCHE SUIVANTE →',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
