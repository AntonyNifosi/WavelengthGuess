/// Constantes du jeu Wavelength.
class GameConstants {
  GameConstants._();

  // --- Scoring ---
  /// Points pour le bullseye (zone centrale).
  static const int bullseyePoints = 4;

  /// Points pour la zone intermédiaire.
  static const int closePoints = 3;

  /// Points pour la zone extérieure.
  static const int farPoints = 2;

  /// Points si complètement raté.
  static const int missPoints = 0;

  // --- Target Zone ---
  /// Largeur angulaire totale de la zone cible en degrés (sur 180°).
  static const double targetZoneDegrees = 36.0;

  /// Largeur du bullseye en degrés.
  static const double bullseyeDegrees = 8.0;

  /// Largeur de la zone intermédiaire en degrés (de chaque côté du bullseye).
  static const double closeDegrees = 8.0;

  /// Largeur de la zone extérieure en degrés (de chaque côté).
  static const double farDegrees = 6.0;

  // --- Rounds ---
  /// Options de nombre de manches.
  static const List<int> roundOptions = [5, 10, 15];

  /// Nombre de manches par défaut.
  static const int defaultRounds = 10;

  // --- Dial ---
  /// Angle de départ du dial (en radians, pi = gauche du demi-cercle).
  static const double dialStartAngle = 3.14159265358979; // pi

  /// Angle de fin du dial (en radians, 0 = droite du demi-cercle).
  static const double dialEndAngle = 0.0;

  // --- Animation ---
  /// Durée de l'animation de révélation en millisecondes.
  static const int revealDurationMs = 1200;

  /// Durée de l'animation de l'aiguille en millisecondes.
  static const int needleAnimDurationMs = 300;
}
