/// Scoring: points per impulse delivered, combo multiplier for chain hits
/// inside a window after a blast, flat fracture bonus.
class ScoreModel {
  ScoreModel({
    required this.pointsPerImpulse,
    required this.comboWindow,
    required this.comboStep,
    required this.maxMultiplier,
    required this.fractureBonus,
  });

  final double pointsPerImpulse;
  final double comboWindow;
  final double comboStep;
  final double maxMultiplier;
  final int fractureBonus;

  int score = 0;
  int combo = 0;
  int bestCombo = 0;
  int bodiesDisplaced = 0;
  int fractures = 0;

  double _time = 0;
  double _lastBlastTime = double.negativeInfinity;
  double _lastHitTime = double.negativeInfinity;

  double get multiplier =>
      (1 + combo * comboStep).clamp(1.0, maxMultiplier).toDouble();

  bool get comboActive => _time - _lastHitTime <= comboWindow;

  /// 1 -> 0 as the combo window runs out.
  double get comboRemaining {
    if (!comboActive) {
      return 0;
    }
    return 1 - (_time - _lastHitTime) / comboWindow;
  }

  void update(double dt) {
    _time += dt;
    if (combo > 0 && !comboActive) {
      combo = 0;
    }
  }

  void onBlast() {
    _lastBlastTime = _time;
  }

  /// Called per body that received an impulse.
  int onImpulse(double magnitude) {
    final points = (magnitude * pointsPerImpulse * multiplier).round();
    score += points;
    bodiesDisplaced += 1;
    return points;
  }

  /// A shape hit another shape. Counts toward the combo only inside the
  /// window after the last blast (or after the previous hit, so chains extend).
  void onShapeHit() {
    final sinceBlast = _time - _lastBlastTime;
    final sinceHit = _time - _lastHitTime;
    if (sinceBlast <= comboWindow || sinceHit <= comboWindow) {
      combo += 1;
      if (combo > bestCombo) {
        bestCombo = combo;
      }
      _lastHitTime = _time;
    }
  }

  void onFracture() {
    fractures += 1;
    score += (fractureBonus * multiplier).round();
  }

  void reset() {
    score = 0;
    combo = 0;
    bestCombo = 0;
    bodiesDisplaced = 0;
    fractures = 0;
    _time = 0;
    _lastBlastTime = double.negativeInfinity;
    _lastHitTime = double.negativeInfinity;
  }
}
