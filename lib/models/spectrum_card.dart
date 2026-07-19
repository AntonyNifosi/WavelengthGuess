/// Représente une carte de spectre avec deux concepts opposés.
class SpectrumCard {
  final String left;
  final String right;

  const SpectrumCard({
    required this.left,
    required this.right,
  });

  /// Retourne la carte inversée (gauche ↔ droite).
  SpectrumCard get flipped => SpectrumCard(left: right, right: left);

  @override
  String toString() => '$left ↔ $right';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpectrumCard && left == other.left && right == other.right;

  @override
  int get hashCode => left.hashCode ^ right.hashCode;
}
