import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'models/game_state.dart';
import 'screens/home_screen.dart';
import 'screens/clue_giver_screen.dart';
import 'screens/handoff_screen.dart';
import 'screens/guesser_screen.dart';
import 'screens/result_screen.dart';
import 'screens/final_score_screen.dart';

class WavelengthApp extends StatelessWidget {
  const WavelengthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Wavelength',
        debugShowCheckedModeBanner: false,
        theme: WavelengthTheme.darkTheme,
        home: const _GameRouter(),
      ),
    );
  }
}

/// Router qui affiche l'écran correspondant à la phase actuelle du jeu.
class _GameRouter extends StatelessWidget {
  const _GameRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, game, _) {
        // Utiliser AnimatedSwitcher pour des transitions fluides
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _buildScreen(game.phase),
        );
      },
    );
  }

  Widget _buildScreen(GamePhase phase) {
    switch (phase) {
      case GamePhase.home:
        return const HomeScreen(key: ValueKey('home'));
      case GamePhase.clueGiver:
        return const ClueGiverScreen(key: ValueKey('clueGiver'));
      case GamePhase.handoff:
        return const HandoffScreen(key: ValueKey('handoff'));
      case GamePhase.guesser:
        return const GuesserScreen(key: ValueKey('guesser'));
      case GamePhase.result:
        return const ResultScreen(key: ValueKey('result'));
      case GamePhase.finalScore:
        return const FinalScoreScreen(key: ValueKey('finalScore'));
    }
  }
}
