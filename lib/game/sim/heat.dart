/// How far a run has escalated: 0 at the start, 1 at [fullAt] seconds, up to
/// [max] in overdrive. Every escalating knob is a [heatLerp] on this.
class HeatCurve {
  const HeatCurve({
    this.warmUp = 20,
    this.fullAt = 150,
    this.overdriveAt = 240,
    this.max = 1.5,
  }) : assert(warmUp < fullAt && fullAt < overdriveAt && max > 1);

  /// Seconds during which the run is exactly the unescalated game.
  final double warmUp;

  /// Seconds at which heat reaches 1.
  final double fullAt;

  /// Seconds at which heat reaches [max] and stays there.
  final double overdriveAt;
  final double max;

  static const tierNames = ['', 'HEAT I', 'HEAT II', 'HEAT III', 'OVERDRIVE'];

  /// Smoothstep from [warmUp] to [fullAt], then linear to [max].
  double at(double elapsed) {
    if (elapsed <= warmUp) {
      return 0;
    }
    if (elapsed < fullAt) {
      final u = (elapsed - warmUp) / (fullAt - warmUp);
      return u * u * (3 - 2 * u);
    }
    final over = ((elapsed - fullAt) / (overdriveAt - fullAt)).clamp(0.0, 1.0);
    return 1 + (max - 1) * over;
  }

  /// 0 while cold, 1 once heat rises, 2 from 0.5, 3 from 1.0, 4 at [max].
  int tierOf(double heat) {
    if (heat <= 0) {
      return 0;
    }
    if (heat < 0.5) {
      return 1;
    }
    if (heat < 1) {
      return 2;
    }
    return heat < max ? 3 : 4;
  }
}

/// [cold] at heat 0, [hot] at heat 1, and [over] (default: [hot]) at heat 1.5.
double heatLerp(double heat, double cold, double hot, [double? over]) {
  if (heat <= 1) {
    return cold + (hot - cold) * heat.clamp(0.0, 1.0);
  }
  final top = over ?? hot;
  return hot + (top - hot) * ((heat - 1) / 0.5).clamp(0.0, 1.0);
}
