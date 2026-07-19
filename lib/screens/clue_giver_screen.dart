import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/game_state.dart';
import '../widgets/wavelength_dial.dart';
import '../widgets/spectrum_labels.dart';
import '../widgets/score_display.dart';

/// Écran du Clue-Giver : voit la zone cible, doit trouver un indice.
class ClueGiverScreen extends StatefulWidget {
  const ClueGiverScreen({super.key});

  @override
  State<ClueGiverScreen> createState() => _ClueGiverScreenState();
}

class _ClueGiverScreenState extends State<ClueGiverScreen>
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
                  Color(0xFF1A1040),
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
                              WavelengthColors.violet.withValues(alpha: 0.15),
                          border: Border.all(
                            color:
                                WavelengthColors.violet.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '🎯 VOUS ÊTES LE CLUE-GIVER',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WavelengthColors.violet,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 13,
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Dial avec la cible visible
                      Expanded(
                        child: WavelengthDial(
                          targetPosition: game.targetPosition,
                          guessPosition: game.targetPosition,
                          showTarget: true,
                          showNeedle: false,
                          interactive: false,
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
                        'Trouvez un indice qui correspond\nà la position de la cible !',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: WavelengthColors.textSecondary,
                                  height: 1.4,
                                ),
                      ),
                      const SizedBox(height: 20),
                      // Bouton
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => game.clueGiven(),
                          child: const Text('INDICE DONNÉ →'),
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
