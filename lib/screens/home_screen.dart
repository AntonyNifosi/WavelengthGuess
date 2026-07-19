import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../models/game_state.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedRounds = GameConstants.defaultRounds;
  late AnimationController _titleController;
  late AnimationController _pulseController;
  late Animation<double> _titleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Animation du titre
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOutBack,
    );
    _titleController.forward();

    // Animation pulse du bouton
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFF1A1040),
              WavelengthColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Titre
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _titleAnimation.value,
                        child: Opacity(
                          opacity: _titleAnimation.value.clamp(0.0, 1.0),
                          child: child,
                        ),
                      );
                    },
                    child: _buildTitle(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Trouvez la bonne longueur d\'onde',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: WavelengthColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const Spacer(flex: 1),
                  // Mini dial décoratif
                  SizedBox(
                    height: 120,
                    child: CustomPaint(
                      size: const Size(240, 120),
                      painter: _MiniDialPainter(),
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Sélecteur de manches
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'NOMBRE DE MANCHES',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: WavelengthColors.textMuted,
                                    fontSize: 12,
                                    letterSpacing: 2,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: GameConstants.roundOptions.map((rounds) {
                            final isSelected = _selectedRounds == rounds;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedRounds = rounds),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: isSelected
                                        ? WavelengthColors.cyan
                                            .withValues(alpha: 0.15)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? WavelengthColors.cyan
                                          : WavelengthColors.textMuted
                                              .withValues(alpha: 0.3),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: WavelengthColors.cyan
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 12,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$rounds',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            color: isSelected
                                                ? WavelengthColors.cyan
                                                : WavelengthColors
                                                    .textSecondary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Bouton Jouer
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<GameState>()
                              .startGame(_selectedRounds);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: WavelengthColors.cyan,
                          foregroundColor: WavelengthColors.background,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ).copyWith(
                          overlayColor:
                              WidgetStateProperty.all(Colors.white24),
                        ),
                        child: const Text(
                          'JOUER',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            WavelengthColors.cyan,
            WavelengthColors.violet,
            WavelengthColors.pink,
          ],
        ).createShader(bounds);
      },
      child: Text(
        'WAVELENGTH',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              fontSize: 42,
              shadows: [
                Shadow(
                  color: WavelengthColors.cyan.withValues(alpha: 0.5),
                  blurRadius: 30,
                ),
                Shadow(
                  color: WavelengthColors.violet.withValues(alpha: 0.3),
                  blurRadius: 60,
                ),
              ],
            ),
      ),
    );
  }
}

/// Petit dial décoratif pour le home screen.
class _MiniDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.45;

    // Glow
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15)
      ..shader = SweepGradient(
        startAngle: pi,
        endAngle: 2 * pi,
        colors: WavelengthColors.dialGradient,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      glowPaint,
    );

    // Arc principal
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: pi,
        endAngle: 2 * pi,
        colors: WavelengthColors.dialGradient,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
