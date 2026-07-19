import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/game_state.dart';
import '../widgets/wavelength_dial.dart';
import '../widgets/spectrum_labels.dart';
import '../widgets/score_display.dart';

/// Écran du Guesser : place l'aiguille sur le dial sans voir la cible.
class GuesserScreen extends StatefulWidget {
  const GuesserScreen({super.key});

  @override
  State<GuesserScreen> createState() => _GuesserScreenState();
}

class _GuesserScreenState extends State<GuesserScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, game, _) {
        final card = game.currentCard!;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.5),
                radius: 1.3,
                colors: [
                  Color(0xFF0F1A30),
                  WavelengthColors.background,
                ],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
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
                      // Rôle
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:
                              WavelengthColors.cyan.withValues(alpha: 0.15),
                          border: Border.all(
                            color:
                                WavelengthColors.cyan.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '🎧 VOUS ÊTES LE GUESSER',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WavelengthColors.cyan,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 13,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Dial interactif (cible cachée)
                      Expanded(
                        child: WavelengthDial(
                          targetPosition: game.targetPosition,
                          guessPosition: game.guessPosition,
                          showTarget: false,
                          interactive: true,
                          onGuessChanged: (pos) => game.updateGuess(pos),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Labels du spectre
                      SpectrumLabels(
                        left: card.left,
                        right: card.right,
                      ),
                      const SizedBox(height: 20),
                      // Instructions
                      Text(
                        'Faites glisser l\'aiguille vers\nla position que vous pensez juste !',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: WavelengthColors.textSecondary,
                                  height: 1.4,
                                ),
                      ),
                      const SizedBox(height: 20),
                      // Bouton valider
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => game.submitGuess(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WavelengthColors.green,
                            foregroundColor: WavelengthColors.background,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                          child: const Text('VALIDER ✓'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
