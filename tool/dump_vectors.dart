// Golden vectors and generated data for the Babylon.js web client (babylon/, plan 06).
//
// Runs the pure Dart sim (lib/game/sim, lib/game/tuning.dart) over fixed inputs and writes:
//   babylon/src/rules/generated/tuning.json   the Tuning constants the web uses (TS imports it)
//   babylon/test/golden/<name>.json           {"cases": [{"in": …, "out": …}]}, replayed by Vitest
//
//   dart run tool/dump_vectors.dart     (from the repo root, after flutter pub get)
//
// Deterministic: no clock, no Random() without a seed. Rerunning on unchanged Dart
// code must give byte-identical files (CI diffs them).
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:puff/game/sim/blast.dart';
import 'package:puff/game/sim/energy.dart';
import 'package:puff/game/sim/environment.dart';
import 'package:puff/game/sim/fracture.dart';
import 'package:puff/game/sim/heat.dart';
import 'package:puff/game/sim/score.dart';
import 'package:puff/game/sim/shapes.dart';
import 'package:puff/game/tuning.dart';
import 'package:vector_math/vector_math.dart';

const goldenDir = 'babylon/test/golden';
const generatedDir = 'babylon/src/rules/generated';

/// Seeded LCG, mirrored bit for bit by babylon/src/rules/random.ts. Only picks inputs.
class Lcg {
  int _s;
  Lcg(int seed) : _s = seed & 0x7fffffff;
  int next(int n) {
    _s = (_s * 1103515245 + 12345) & 0x7fffffff;
    return _s % n;
  }

  double unit() => next(1 << 30) / (1 << 30);
}

/// A math.Random over [Lcg], mirrored by gameRandom(seed) in babylon/src/rules/random.ts, so the
/// rules that take a Random (ShapeFactory) replay draw for draw.
class LcgRandom implements math.Random {
  LcgRandom(int seed) : _lcg = Lcg(seed);
  final Lcg _lcg;
  @override
  int nextInt(int max) => _lcg.next(max);
  @override
  double nextDouble() => _lcg.unit();
  @override
  bool nextBool() => _lcg.next(2) == 0;
}

void writeJson(String path, Object json) {
  final f = File(path);
  f.parent.createSync(recursive: true);
  f.writeAsStringSync('${const JsonEncoder.withIndent(' ').convert(json)}\n');
  stdout.writeln('wrote ${f.path} (${f.lengthSync()} B)');
}

void writeCases(String name, List<Map<String, Object?>> cases) => writeJson('$goldenDir/$name', {'cases': cases});

List<double> v2(Vector2 v) => [v.x, v.y];

/// Infinity is not JSON; the TS side maps the string back.
Object jnum(double x) => x.isFinite ? x : (x > 0 ? 'inf' : '-inf');

// ── Generated data ───────────────────────────────────────────────────────

Map<String, Object?> envJson(Environment e) => {
  'kind': e.kind.name,
  'linearDamping': e.linearDamping,
  'angularDamping': e.angularDamping,
  'blastMultiplier': e.blastMultiplier,
  'gravityY': e.gravityY,
  'windAmplitude': e.windAmplitude,
  'windPeriod': e.windPeriod,
  'ambient': e.ambient == null ? null : {'interval': e.ambient!.interval, 'strength': e.ambient!.strength},
};

Map<String, Object?> tuningJson() => {
  'worldWidth': Tuning.worldWidth,
  'maxDt': Tuning.maxDt,
  'cloudRMin': Tuning.cloudRMin,
  'cloudRMax': Tuning.cloudRMax,
  'tOverpressure': Tuning.tOverpressure,
  'easeInDuration': Tuning.easeInDuration,
  'overpressurePenalty': Tuning.overpressurePenalty,
  'lagBase': Tuning.lagBase,
  'lagPerRadius': Tuning.lagPerRadius,
  'drainRate': Tuning.drainRate,
  'blast': {
    'roeMin': Tuning.blast.roeMin,
    'roeMax': Tuning.blast.roeMax,
    'rMin': Tuning.blast.rMin,
    'falloffPower': Tuning.blast.falloffPower,
    'impulseScale': Tuning.blast.impulseScale,
    'torqueScale': Tuning.blast.torqueScale,
  },
  'breakThreshold': Tuning.breakThreshold,
  'shapeMinSize': Tuning.shapeMinSize,
  'shapeMaxSize': Tuning.shapeMaxSize,
  'metalChance': Tuning.metalChance,
  'strokeWidth': Tuning.strokeWidth,
  'maxBodies': Tuning.maxBodies,
  'despawnMargin': Tuning.despawnMargin,
  'spawnIntervalStart': Tuning.spawnIntervalStart,
  'spawnIntervalMin': Tuning.spawnIntervalMin,
  'spawnRampSeconds': Tuning.spawnRampSeconds,
  'spawnSpeedMin': Tuning.spawnSpeedMin,
  'spawnSpeedMax': Tuning.spawnSpeedMax,
  'spawnAngleJitter': Tuning.spawnAngleJitter,
  'spawnMargin': Tuning.spawnMargin,
  'spawnInitialBurst': Tuning.spawnInitialBurst,
  'coreRadius': Tuning.coreRadius,
  'coreHp': Tuning.coreHp,
  'fractureMaxDepth': Tuning.fractureMaxDepth,
  'minFragmentSize': Tuning.minFragmentSize,
  'fractureOutwardSpeed': Tuning.fractureOutwardSpeed,
  'fractureSpin': Tuning.fractureSpin,
  'pointsPerImpulse': Tuning.pointsPerImpulse,
  'comboWindow': Tuning.comboWindow,
  'comboStep': Tuning.comboStep,
  'maxMultiplier': Tuning.maxMultiplier,
  'comboHitSpeed': Tuning.comboHitSpeed,
  'fractureBonus': Tuning.fractureBonus,
  'heat': {
    'warmUp': Tuning.heat.warmUp,
    'fullAt': Tuning.heat.fullAt,
    'overdriveAt': Tuning.heat.overdriveAt,
    'max': Tuning.heat.max,
  },
  'spawnIntervalOver': Tuning.spawnIntervalOver,
  'shapeMinSizeHot': Tuning.shapeMinSizeHot,
  'shapeMinSizeOver': Tuning.shapeMinSizeOver,
  'shapeMaxSizeHot': Tuning.shapeMaxSizeHot,
  'shapeMaxSizeOver': Tuning.shapeMaxSizeOver,
  'metalChanceHot': Tuning.metalChanceHot,
  'metalChanceOver': Tuning.metalChanceOver,
  'spawnSpeedMaxHot': Tuning.spawnSpeedMaxHot,
  'spawnSpeedMaxOver': Tuning.spawnSpeedMaxOver,
  'cloudRMaxHot': Tuning.cloudRMaxHot,
  'cloudRMaxOver': Tuning.cloudRMaxOver,
  'blastRadiusHot': Tuning.blastRadiusHot,
  'blastRadiusOver': Tuning.blastRadiusOver,
  'blastImpulseHot': Tuning.blastImpulseHot,
  'blastImpulseOver': Tuning.blastImpulseOver,
  'environments': [for (final e in Environment.presets) envJson(e)],
};

// ── Vectors ──────────────────────────────────────────────────────────────

/// Energy curve and a charge held with bodies draining it.
List<Map<String, Object?>> energyCases() {
  final r = Lcg(3);
  final out = <Map<String, Object?>>[];
  for (var i = 0; i < 12; i++) {
    final c = Charge(
      curve: Tuning.energyCurve,
      tOverpressure: Tuning.tOverpressure,
      overpressurePenalty: Tuning.overpressurePenalty,
      drainRate: Tuning.drainRate,
    );
    final steps = <List<num>>[];
    final states = <List<Object>>[];
    for (var k = 0; k < 20 + r.next(40); k++) {
      final dt = (1 + r.next(8)) / 120;
      final bodies = r.next(5) == 0 ? r.next(4) : 0;
      c.tick(dt, drainingBodies: bodies);
      steps.add([dt, bodies]);
      states.add([c.energy, c.overpressureProgress, c.overpressured, c.drainedThisTick, c.releaseEnergy()]);
    }
    out.add({'in': steps, 'out': states});
  }
  return out;
}

List<Map<String, Object?>> blastCases() {
  final r = Lcg(5);
  return [
    for (var i = 0; i < 80; i++)
      () {
        final origin = Vector2(r.unit() * 9 - 4.5, r.unit() * 16 - 8);
        final body = i % 10 == 0 ? origin.clone() : origin + Vector2(r.unit() * 10 - 5, r.unit() * 10 - 5);
        final energy = r.unit();
        final mult = 0.6 + r.unit();
        final sign = r.next(2) == 0 ? 1.0 : -1.0;
        final dir = r.next(4) == 0 ? -1.0 : 1.0;
        final radius = r.next(3) == 0 ? 2 + r.unit() * 3 : null;
        final res = computeBlast(
          params: Tuning.blast,
          origin: origin,
          bodyPos: body,
          energy: energy,
          blastMultiplier: mult,
          randomSign: sign,
          radiusOverride: radius,
          directionSign: dir,
        );
        return {
          'in': {
            'origin': v2(origin),
            'body': v2(body),
            'energy': energy,
            'mult': mult,
            'sign': sign,
            'radius': radius,
            'dir': dir,
          },
          'out': res == null
              ? null
              : {'impulse': v2(res.impulse), 'angular': res.angularImpulse, 'falloff': res.falloff},
        };
      }(),
  ];
}

/// Score: a timeline of update(dt) / blast / impulse(m) / hit / fracture and the state after each.
List<Map<String, Object?>> scoreCases() {
  final r = Lcg(11);
  final out = <Map<String, Object?>>[];
  for (var i = 0; i < 12; i++) {
    final s = ScoreModel(
      pointsPerImpulse: Tuning.pointsPerImpulse,
      comboWindow: Tuning.comboWindow,
      comboStep: Tuning.comboStep,
      maxMultiplier: Tuning.maxMultiplier,
      fractureBonus: Tuning.fractureBonus,
    );
    final ops = <Object>[];
    final states = <Object>[];
    for (var k = 0; k < 60; k++) {
      switch (r.next(6)) {
        case 0:
          ops.add('blast');
          s.onBlast();
        case 1:
          final m = r.unit() * 6;
          ops.add(['impulse', m]);
          s.onImpulse(m);
        case 2:
          ops.add('hit');
          s.onShapeHit();
        case 3:
          ops.add('fracture');
          s.onFracture();
        default:
          final dt = (1 + r.next(30)) / 60;
          ops.add(dt);
          s.update(dt);
      }
      states.add([s.score, s.combo, s.bestCombo, s.bodiesDisplaced, s.fractures, s.multiplier, s.comboRemaining]);
    }
    out.add({'in': ops, 'out': states});
  }
  return out;
}

List<Map<String, Object?>> heatCases() {
  const h = Tuning.heat;
  return [
    for (var t = -5.0; t <= 300; t += 2.5)
      {
        'in': t,
        'out': [
          h.at(t),
          h.tierOf(h.at(t)),
          Tuning.blastRadiusScale(h.at(t)),
          Tuning.blastImpulseScale(h.at(t)),
          heatLerp(h.at(t), 0.3, 0.8, 0.9),
        ],
      },
  ];
}

Map<String, Object?> specJson(ShapeSpec s) => {
  'kind': s.kind.name,
  'size': s.size,
  'sides': s.sides,
  'density': s.density,
  'restitution': s.restitution,
  'friction': s.friction,
  'breakThreshold': jnum(s.breakThreshold),
  'material': s.material.name,
  'outline': s.outline == null ? null : [for (final v in s.outline!) v2(v)],
};

/// ShapeFactory from a seeded Random, with the geometry of each spec.
List<Map<String, Object?>> shapeCases() {
  final r = Lcg(13);
  return [
    for (var i = 0; i < 8; i++)
      () {
        final seed = 1 + r.next(1 << 30);
        final f = ShapeFactory(
          LcgRandom(seed),
          baseBreakThreshold: Tuning.breakThreshold,
          metalChance: Tuning.metalChance,
        );
        final minSize = i.isEven ? Tuning.shapeMinSize : 0.32;
        final maxSize = i.isEven ? Tuning.shapeMaxSize : 0.8;
        final metal = i % 3 == 0 ? null : 0.45;
        return {
          'in': {'seed': seed, 'minSize': minSize, 'maxSize': maxSize, 'metalChance': metal},
          'out': [
            for (var k = 0; k < 12; k++)
              () {
                final s = f.next(minSize: minSize, maxSize: maxSize, metalChance: metal);
                final verts = s.vertices();
                return {
                  'spec': specJson(s),
                  'vertices': [for (final v in verts) v2(v)],
                  'area': s.area,
                  'centroid': verts.isEmpty ? null : v2(polygonCentroid(verts)),
                };
              }(),
          ],
        };
      }(),
  ];
}

/// Fracture of factory shapes and of their fragments, over impulse directions.
List<Map<String, Object?>> fractureCases() {
  const rules = FractureRules(maxDepth: Tuning.fractureMaxDepth, minFragmentSize: Tuning.minFragmentSize);
  final r = Lcg(17);
  final f = ShapeFactory(LcgRandom(99), baseBreakThreshold: Tuning.breakThreshold, metalChance: Tuning.metalChance);
  final out = <Map<String, Object?>>[];
  Map<String, Object?> one(ShapeSpec spec, int gen, Vector2 imp, int? depth) {
    final res = rules.fracture(spec: spec, generation: gen, localImpulse: imp, maxDepth: depth);
    return {
      'in': {'spec': specJson(spec), 'generation': gen, 'impulse': v2(imp), 'maxDepth': depth},
      'out': {
        'fragments': [
          for (final fr in res.fragments) {'spec': specJson(fr.spec), 'offset': v2(fr.offset)},
        ],
        'dust': [for (final d in res.dust) v2(d)],
      },
    };
  }

  for (var i = 0; i < 24; i++) {
    final spec = f.next(minSize: 0.26, maxSize: i < 12 ? 0.5 : 1.4);
    final a = r.unit() * 2 * math.pi;
    final axis = r.next(3);
    final imp = axis == 0
        ? Vector2(r.next(2) == 0 ? 3 : -3, 0.1)
        : axis == 1
        ? Vector2(0.05, 4)
        : Vector2(math.cos(a) * 3, math.sin(a) * 3);
    out.add(one(spec, 0, imp, i >= 18 ? 3 : null));
    final first = rules.fracture(spec: spec, generation: 0, localImpulse: imp);
    if (first.fragments.isNotEmpty) {
      out.add(one(first.fragments.first.spec, 1, Vector2(1, 2), i >= 18 ? 3 : null));
    }
  }
  return out;
}

void main() {
  writeJson('$generatedDir/tuning.json', tuningJson());
  writeCases('blast.json', blastCases());
  writeCases('energy.json', energyCases());
  writeCases('fracture.json', fractureCases());
  writeCases('heat.json', heatCases());
  writeCases('score.json', scoreCases());
  writeCases('shapes.json', shapeCases());
}
