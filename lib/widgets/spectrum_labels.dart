import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Affiche les labels des deux extrêmes du spectre.
class SpectrumLabels extends StatelessWidget {
  final String left;
  final String right;

  const SpectrumLabels({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _LabelChip(
              text: left,
              alignment: Alignment.centerLeft,
              glowColor: WavelengthColors.pink,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: _LabelChip(
              text: right,
              alignment: Alignment.centerRight,
              glowColor: WavelengthColors.cyan,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final Color glowColor;

  const _LabelChip({
    required this.text,
    required this.alignment,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: WavelengthColors.surfaceLight,
        border: Border.all(
          color: glowColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.15),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: WavelengthColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
        textAlign: alignment == Alignment.centerLeft
            ? TextAlign.left
            : TextAlign.right,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
