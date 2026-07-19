import '../models/spectrum_card.dart';

/// Base de données de cartes de spectre.
/// ~80 paires de concepts opposés en français.
class SpectrumCardDatabase {
  SpectrumCardDatabase._();

  static const List<SpectrumCard> cards = [
    // --- Sensations & Physique ---
    SpectrumCard(left: 'Chaud', right: 'Froid'),
    SpectrumCard(left: 'Bruyant', right: 'Silencieux'),
    SpectrumCard(left: 'Rapide', right: 'Lent'),
    SpectrumCard(left: 'Lourd', right: 'Léger'),
    SpectrumCard(left: 'Sec', right: 'Humide'),
    SpectrumCard(left: 'Dur', right: 'Mou'),
    SpectrumCard(left: 'Grand', right: 'Petit'),
    SpectrumCard(left: 'Sent bon', right: 'Sent mauvais'),
    SpectrumCard(left: 'Lisse', right: 'Rugueux'),
    SpectrumCard(left: 'Brillant', right: 'Terne'),

    // --- Apparence & Esthétique ---
    SpectrumCard(left: 'Beau', right: 'Laid'),
    SpectrumCard(left: 'Coloré', right: 'Incolore'),
    SpectrumCard(left: 'Élégant', right: 'Vulgaire'),
    SpectrumCard(left: 'Mignon', right: 'Effrayant'),
    SpectrumCard(left: 'Propre', right: 'Sale'),
    SpectrumCard(left: 'À la mode', right: 'Démodé'),

    // --- Goût & Nourriture ---
    SpectrumCard(left: 'Sucré', right: 'Salé'),
    SpectrumCard(left: 'Délicieux', right: 'Dégoûtant'),
    SpectrumCard(left: 'Sain', right: 'Malsain'),
    SpectrumCard(left: 'Un sandwich', right: 'Pas un sandwich'),
    SpectrumCard(left: 'Bon au petit-déjeuner', right: 'Bon au dîner'),
    SpectrumCard(left: 'Plat de riche', right: 'Plat de pauvre'),
    SpectrumCard(left: 'Recette facile', right: 'Recette compliquée'),

    // --- Émotions & Personnalité ---
    SpectrumCard(left: 'Joyeux', right: 'Triste'),
    SpectrumCard(left: 'Courageux', right: 'Lâche'),
    SpectrumCard(left: 'Intelligent', right: 'Stupide'),
    SpectrumCard(left: 'Gentil', right: 'Méchant'),
    SpectrumCard(left: 'Drôle', right: 'Ennuyeux'),
    SpectrumCard(left: 'Calme', right: 'Stressant'),
    SpectrumCard(left: 'Romantique', right: 'Anti-romantique'),
    SpectrumCard(left: 'Introverti', right: 'Extraverti'),
    SpectrumCard(left: 'Mature', right: 'Immature'),

    // --- Jugement & Opinion ---
    SpectrumCard(left: 'Sous-estimé', right: 'Surestimé'),
    SpectrumCard(left: 'Facile', right: 'Difficile'),
    SpectrumCard(left: 'Normal', right: 'Bizarre'),
    SpectrumCard(left: 'Dangereux', right: 'Inoffensif'),
    SpectrumCard(left: 'Utile', right: 'Inutile'),
    SpectrumCard(left: 'Cher', right: 'Pas cher'),
    SpectrumCard(left: 'Nécessaire', right: 'Superflu'),
    SpectrumCard(left: 'Légal', right: 'Illégal'),
    SpectrumCard(left: 'Moral', right: 'Immoral'),
    SpectrumCard(left: 'Réaliste', right: 'Irréaliste'),

    // --- Culture & Divertissement ---
    SpectrumCard(left: 'Bon film', right: 'Mauvais film'),
    SpectrumCard(left: 'Le livre est meilleur', right: 'Le film est meilleur'),
    SpectrumCard(left: 'Chef-d\'œuvre musical', right: 'Bruit insupportable'),
    SpectrumCard(left: 'Jeu vidéo addictif', right: 'Jeu vidéo ennuyeux'),
    SpectrumCard(left: 'Classique', right: 'Moderne'),
    SpectrumCard(left: 'Pour enfants', right: 'Pour adultes'),
    SpectrumCard(left: 'Mainstream', right: 'Underground'),
    SpectrumCard(left: 'Fiction', right: 'Réalité'),

    // --- Société & Vie quotidienne ---
    SpectrumCard(left: 'Facile à trouver', right: 'Difficile à trouver'),
    SpectrumCard(left: 'Commun', right: 'Rare'),
    SpectrumCard(left: 'Du matin', right: 'Du soir'),
    SpectrumCard(left: 'D\'intérieur', right: 'D\'extérieur'),
    SpectrumCard(left: 'Ville', right: 'Campagne'),
    SpectrumCard(left: 'Vieux', right: 'Jeune'),
    SpectrumCard(left: 'Travail', right: 'Loisir'),
    SpectrumCard(left: 'High-tech', right: 'Low-tech'),
    SpectrumCard(left: 'Français', right: 'Américain'),
    SpectrumCard(left: 'Luxe', right: 'Basique'),

    // --- Comparaisons fun ---
    SpectrumCard(left: 'Pirate', right: 'Ninja'),
    SpectrumCard(left: 'Chat', right: 'Chien'),
    SpectrumCard(left: 'Été', right: 'Hiver'),
    SpectrumCard(left: 'Montagne', right: 'Plage'),
    SpectrumCard(left: 'Café', right: 'Thé'),
    SpectrumCard(left: 'Sucré', right: 'Épicé'),
    SpectrumCard(left: 'Pizza', right: 'Burger'),
    SpectrumCard(left: 'Avion', right: 'Train'),
    SpectrumCard(left: 'Cerveau', right: 'Muscles'),

    // --- Abstrait & Philosophique ---
    SpectrumCard(left: 'Rond', right: 'Carré'),
    SpectrumCard(left: 'Ancien', right: 'Futuriste'),
    SpectrumCard(left: 'Vivant', right: 'Mort'),
    SpectrumCard(left: 'Réel', right: 'Fictif'),
    SpectrumCard(left: 'Simple', right: 'Complexe'),
    SpectrumCard(left: 'Éphémère', right: 'Éternel'),
    SpectrumCard(left: 'Visible', right: 'Invisible'),
    SpectrumCard(left: 'Ordre', right: 'Chaos'),

    // --- Superlatifs & Records ---
    SpectrumCard(left: 'Meilleur sportif de tous les temps', right: 'Pire sportif de tous les temps'),
    SpectrumCard(left: 'Meilleur super-héros', right: 'Pire super-héros'),
    SpectrumCard(left: 'Activité surcotée', right: 'Activité sous-cotée'),
    SpectrumCard(left: 'Invention géniale', right: 'Invention inutile'),
    SpectrumCard(left: 'Métier de rêve', right: 'Pire métier'),
    SpectrumCard(left: 'Meilleur animal de compagnie', right: 'Pire animal de compagnie'),
    SpectrumCard(left: 'Bon cadeau', right: 'Mauvais cadeau'),
    SpectrumCard(left: 'Bonne excuse', right: 'Mauvaise excuse'),
    SpectrumCard(left: 'Premier rendez-vous réussi', right: 'Premier rendez-vous raté'),
    SpectrumCard(left: 'Survit à l\'apocalypse', right: 'Meurt en premier'),
  ];
}
