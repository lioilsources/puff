import 'package:flutter/material.dart';

import '../game/palette.dart';

/// Neon UI primitives built from the active palette. No literal colors.
class NeonText extends StatelessWidget {
  const NeonText(
    this.text, {
    super.key,
    required this.color,
    this.size = 16,
    this.weight = FontWeight.w600,
    this.spacing = 2,
    this.glow = true,
    this.align = TextAlign.center,
  });

  final String text;
  final Color color;
  final double size;
  final FontWeight weight;
  final double spacing;
  final bool glow;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: spacing,
        fontFamily: 'monospace',
        shadows: glow
            ? [
                Shadow(color: color.withValues(alpha: 0.9), blurRadius: size * 0.6),
                Shadow(color: color.withValues(alpha: 0.4), blurRadius: size * 1.6),
              ]
            : null,
      ),
    );
  }
}

class NeonButton extends StatelessWidget {
  const NeonButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.primary = false,
    this.width = 220,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool primary;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color, width: primary ? 2 : 1.2),
            color: color.withValues(alpha: primary ? 0.16 : 0.06),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: primary ? 0.55 : 0.25),
                blurRadius: primary ? 18 : 10,
              ),
            ],
          ),
          child: NeonText(label, color: color, size: primary ? 18 : 14),
        ),
      ),
    );
  }
}

/// Horizontal row of selectable chips.
class NeonPicker<T> extends StatelessWidget {
  const NeonPicker({
    super.key,
    required this.title,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelect,
    required this.palette,
    this.colorOf,
  });

  final String title;
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final void Function(T) onSelect;
  final Palette palette;
  final Color Function(T)? colorOf;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NeonText(
            title,
            color: palette.secondary.withValues(alpha: 0.8),
            size: 11,
            glow: false,
            spacing: 3,
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final v in values)
                _Chip(
                  label: labelOf(v),
                  color: colorOf?.call(v) ?? palette.primary,
                  selected: v == selected,
                  onTap: () => onSelect(v),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: selected ? 1 : 0.45),
            width: selected ? 1.6 : 1,
          ),
          color: color.withValues(alpha: selected ? 0.22 : 0.0),
          boxShadow: selected
              ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 12)]
              : null,
        ),
        child: NeonText(
          label,
          color: color.withValues(alpha: selected ? 1 : 0.7),
          size: 12,
          glow: selected,
          spacing: 1,
        ),
      ),
    );
  }
}

class NeonToggle extends StatelessWidget {
  const NeonToggle({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 140,
              child: NeonText(label, color: color, size: 13, glow: false, align: TextAlign.left),
            ),
            const SizedBox(width: 16),
            _Chip(label: value ? 'ON' : 'OFF', color: color, selected: value, onTap: () => onChanged(!value)),
          ],
        ),
      ),
    );
  }
}

/// Dim scrim used behind every overlay so the world stays visible.
class OverlayScrim extends StatelessWidget {
  const OverlayScrim({super.key, required this.palette, required this.child, this.opacity = 0.72});

  final Palette palette;
  final Widget child;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: palette.bg.withValues(alpha: opacity),
      alignment: Alignment.center,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );
  }
}
