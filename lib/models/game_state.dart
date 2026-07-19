import 'dart:math';
import 'package:flutter/material.dart';
import '../models/spectrum_card.dart';
import '../core/spectrum_cards.dart';
import '../core/constants.dart';

/// Phase actuelle du jeu.
enum GamePhase {
  /// Menu d'accueil.
  home,

  /// Le clue-giver voit la cible et prépare son indice.
  clueGiver,

  /// Transition : passez le téléphone au guesser.
  handoff,

  /// Le guesser place l'aiguille.
  guesser,

  /// Révélation de la zone cible et score.
  result,

  /// Score final après toutes les manches.
  finalScore,
}

/// État global du jeu, géré avec ChangeNotifier.
class GameState extends ChangeNotifier {
  final Random _random = Random();

  // --- Configuration ---
  int _totalRounds = GameConstants.defaultRounds;
  int get totalRounds => _totalRounds;

  // --- État du jeu ---
  GamePhase _phase = GamePhase.home;
  GamePhase get phase => _phase;

  int _currentRound = 0;
  int get currentRound => _currentRound;

  int _score = 0;
  int get score => _score;

  List<int> _roundScores = [];
  List<int> get roundScores => List.unmodifiable(_roundScores);

  // --- Carte courante ---
  SpectrumCard? _currentCard;
  SpectrumCard? get currentCard => _currentCard;

  // --- Cible ---
  /// Position de la cible sur le spectre, normalisée entre 0.0 (gauche) et 1.0 (droite).
  double _targetPosition = 0.5;
  double get targetPosition => _targetPosition;

  // --- Guess ---
  /// Position de l'aiguille du guesser, normalisée entre 0.0 (gauche) et 1.0 (droite).
  double _guessPosition = 0.5;
  double get guessPosition => _guessPosition;

  // --- Deck ---
  late List<SpectrumCard> _deck;

  // ========================================================================
  // Actions
  // ========================================================================

  /// Démarre une nouvelle partie avec le nombre de manches choisi.
  void startGame(int totalRounds) {
    _totalRounds = totalRounds;
    _currentRound = 0;
    _score = 0;
    _roundScores = [];

    // Créer et mélanger le deck
    _deck = List.from(SpectrumCardDatabase.cards);
    _deck.shuffle(_random);

    // Éventuellement flipper aléatoirement les cartes
    _deck = _deck.map((card) {
      return _random.nextBool() ? card.flipped : card;
    }).toList();

    _nextRound();
  }

  /// Passe à la manche suivante.
  void _nextRound() {
    _currentRound++;

    // Piocher une carte
    if (_deck.isEmpty) {
      _deck = List.from(SpectrumCardDatabase.cards);
      _deck.shuffle(_random);
    }
    _currentCard = _deck.removeLast();

    // Placer la cible aléatoirement (entre 0.05 et 0.95 pour éviter les bords)
    _targetPosition = 0.05 + _random.nextDouble() * 0.9;

    // Reset la position du guess au centre
    _guessPosition = 0.5;

    // Passer en mode clue-giver
    _phase = GamePhase.clueGiver;
    notifyListeners();
  }

  /// Le clue-giver a donné son indice. Passer au handoff.
  void clueGiven() {
    _phase = GamePhase.handoff;
    notifyListeners();
  }

  /// Le guesser a le téléphone. Passer en mode guesser.
  void startGuessing() {
    _phase = GamePhase.guesser;
    notifyListeners();
  }

  /// Met à jour la position de l'aiguille du guesser.
  void updateGuess(double position) {
    _guessPosition = position.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Le guesser valide sa réponse. Calculer le score et passer en mode résultat.
  void submitGuess() {
    final roundScore = calculateScore();
    _score += roundScore;
    _roundScores.add(roundScore);
    _phase = GamePhase.result;
    notifyListeners();
  }

  /// Passe à la manche suivante ou au score final.
  void nextRoundOrEnd() {
    if (_currentRound >= _totalRounds) {
      _phase = GamePhase.finalScore;
      notifyListeners();
    } else {
      _nextRound();
    }
  }

  /// Retour au menu.
  void goHome() {
    _phase = GamePhase.home;
    notifyListeners();
  }

  // ========================================================================
  // Scoring
  // ========================================================================

  /// Calcule le score de la manche actuelle.
  int calculateScore() {
    // Distance normalisée entre le guess et la cible
    final distance = (_guessPosition - _targetPosition).abs();

    // Convertir en degrés (sur 180°)
    final distanceDegrees = distance * 180.0;

    // Le bullseye est à ± bullseyeDegrees/2 du centre
    if (distanceDegrees <= GameConstants.bullseyeDegrees / 2) {
      return GameConstants.bullseyePoints;
    }
    // Zone intermédiaire
    if (distanceDegrees <=
        (GameConstants.bullseyeDegrees / 2 + GameConstants.closeDegrees)) {
      return GameConstants.closePoints;
    }
    // Zone extérieure
    if (distanceDegrees <=
        (GameConstants.bullseyeDegrees / 2 +
            GameConstants.closeDegrees +
            GameConstants.farDegrees)) {
      return GameConstants.farPoints;
    }
    // Raté
    return GameConstants.missPoints;
  }

  /// Score maximum possible.
  int get maxScore => _totalRounds * GameConstants.bullseyePoints;

  /// Pourcentage de score.
  double get scorePercentage => maxScore > 0 ? _score / maxScore : 0.0;
}
