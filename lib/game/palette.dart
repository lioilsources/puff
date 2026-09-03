import 'dart:ui';

/// Semantic color slots. Components and shaders only ever ask for a role,
/// never for a literal color.
enum PaletteRole { bg, bgAlt, primary, secondary, accent, hazard, glow }

class Palette {
  const Palette({
    required this.name,
    required this.bg,
    required this.bgAlt,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.hazard,
    required this.glow,
  });

  final String name;
  final Color bg;
  final Color bgAlt;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color hazard;
  final Color glow;

  Color byRole(PaletteRole role) => switch (role) {
    PaletteRole.bg => bg,
    PaletteRole.bgAlt => bgAlt,
    PaletteRole.primary => primary,
    PaletteRole.secondary => secondary,
    PaletteRole.accent => accent,
    PaletteRole.hazard => hazard,
    PaletteRole.glow => glow,
  };

  Map<String, dynamic> toJson() => {
    'name': name,
    'bg': bg.toARGB32(),
    'bgAlt': bgAlt.toARGB32(),
    'primary': primary.toARGB32(),
    'secondary': secondary.toARGB32(),
    'accent': accent.toARGB32(),
    'hazard': hazard.toARGB32(),
    'glow': glow.toARGB32(),
  };

  factory Palette.fromJson(Map<String, dynamic> json) => Palette(
    name: json['name'] as String,
    bg: Color(json['bg'] as int),
    bgAlt: Color(json['bgAlt'] as int),
    primary: Color(json['primary'] as int),
    secondary: Color(json['secondary'] as int),
    accent: Color(json['accent'] as int),
    hazard: Color(json['hazard'] as int),
    glow: Color(json['glow'] as int),
  );

  Palette copyWith({
    String? name,
    Color? bg,
    Color? bgAlt,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? hazard,
    Color? glow,
  }) => Palette(
    name: name ?? this.name,
    bg: bg ?? this.bg,
    bgAlt: bgAlt ?? this.bgAlt,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    accent: accent ?? this.accent,
    hazard: hazard ?? this.hazard,
    glow: glow ?? this.glow,
  );

  static const cyberpunk = Palette(
    name: 'Cyberpunk',
    bg: Color(0xFF07060F),
    bgAlt: Color(0xFF14112E),
    primary: Color(0xFF00F0FF),
    secondary: Color(0xFFFF2A6D),
    accent: Color(0xFFF9F002),
    hazard: Color(0xFFFF3D00),
    glow: Color(0xFF7DF9FF),
  );

  static const vaporwave = Palette(
    name: 'Vaporwave',
    bg: Color(0xFF0D0221),
    bgAlt: Color(0xFF1E0B44),
    primary: Color(0xFFFF71CE),
    secondary: Color(0xFF01CDFE),
    accent: Color(0xFFB967FF),
    hazard: Color(0xFFFFFB96),
    glow: Color(0xFFFF9DE6),
  );

  static const acid = Palette(
    name: 'Acid',
    bg: Color(0xFF040804),
    bgAlt: Color(0xFF0C180C),
    primary: Color(0xFF39FF14),
    secondary: Color(0xFFCCFF00),
    accent: Color(0xFF00FFC6),
    hazard: Color(0xFFFF6F00),
    glow: Color(0xFFB6FF9C),
  );

  static const mono = Palette(
    name: 'Mono',
    bg: Color(0xFF050505),
    bgAlt: Color(0xFF141414),
    primary: Color(0xFFFFFFFF),
    secondary: Color(0xFFB4B4B4),
    accent: Color(0xFFE6E6E6),
    hazard: Color(0xFFFF4A4A),
    glow: Color(0xFFFFFFFF),
  );

  static const ember = Palette(
    name: 'Ember',
    bg: Color(0xFF0A0402),
    bgAlt: Color(0xFF1E0B05),
    primary: Color(0xFFFF7A00),
    secondary: Color(0xFFFFC400),
    accent: Color(0xFFFF2E00),
    hazard: Color(0xFFFF0033),
    glow: Color(0xFFFFB36B),
  );

  static const arctic = Palette(
    name: 'Arctic',
    bg: Color(0xFF030A12),
    bgAlt: Color(0xFF0A1E30),
    primary: Color(0xFF7FE7FF),
    secondary: Color(0xFFB7C9FF),
    accent: Color(0xFFFFFFFF),
    hazard: Color(0xFFFF5E7A),
    glow: Color(0xFFC8F6FF),
  );

  static const builtIns = [cyberpunk, vaporwave, acid, mono, ember, arctic];

  static Palette byName(String name) =>
      builtIns.firstWhere((p) => p.name == name, orElse: () => cyberpunk);
}
