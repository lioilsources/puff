// Generates all placeholder SFX as 16-bit mono WAV files (CC0, synthesized).
//
//   dart run tool/gen_sfx.dart
//
// Everything is procedural: sines, noise, simple one-pole filters.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const sampleRate = 44100;
final rng = math.Random(7);

void main() {
  final out = Directory('assets/audio');
  out.createSync(recursive: true);

  // Charge loop stages: seamless loops with rising pitch.
  const stageFreqs = [96.0, 138.0, 196.0, 262.0, 349.0];
  for (var i = 0; i < stageFreqs.length; i++) {
    write(out, 'charge_${i + 1}.wav', chargeLoop(stageFreqs[i], 0.6, i));
  }

  write(out, 'release_low.wav', release(0.25));
  write(out, 'release_mid.wav', release(0.6));
  write(out, 'release_high.wav', release(1.0));
  write(out, 'release_water_low.wav', lowpass(release(0.25), 500));
  write(out, 'release_water_mid.wav', lowpass(release(0.6), 450));
  write(out, 'release_water_high.wav', lowpass(release(1.0), 400));
  write(out, 'fizzle.wav', fizzle());
  write(out, 'implosion.wav', implosion());
  write(out, 'fracture_1.wav', fracture(2200));
  write(out, 'fracture_2.wav', fracture(2900));
  write(out, 'fracture_3.wav', fracture(3700));
  write(out, 'arc.wav', arc());
  write(out, 'core_hit.wav', coreHit());
  write(out, 'ui_click.wav', click());
  write(out, 'game_over.wav', gameOver());
  stdout.writeln('SFX written to ${out.path}');
}

// ---- Synthesis -------------------------------------------------------------

Float64List chargeLoop(double freq, double seconds, int stage) {
  // Snap the frequency so the loop contains a whole number of cycles.
  final cycles = (freq * seconds).round();
  final f = cycles / seconds;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final ph = 2 * math.pi * f * t;
    // Fundamental + soft harmonics; more grit at higher stages.
    var v = math.sin(ph) * 0.6 +
        math.sin(ph * 2) * (0.12 + 0.05 * stage) +
        math.sin(ph * 3) * (0.05 + 0.03 * stage) +
        (rng.nextDouble() * 2 - 1) * 0.015 * stage;
    // Slow amplitude wobble that also loops (integer cycles).
    final wobbleCycles = 2;
    v *= 0.85 + 0.15 * math.sin(2 * math.pi * wobbleCycles * t / seconds);
    buf[i] = v * 0.35;
  }
  return lowpass(buf, 1800 + 600.0 * stage);
}

Float64List release(double energy) {
  final seconds = 0.5 + 0.9 * energy;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  // Sub thump: exponential pitch drop.
  var phase = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final f = 30 + (110 + 90 * energy) * math.exp(-t * 9);
    phase += 2 * math.pi * f / sampleRate;
    final env = math.exp(-t * (6 - 2.5 * energy));
    buf[i] += math.sin(phase) * env * (0.55 + 0.35 * energy);
  }
  // Crack: short bright noise.
  final crackLen = (0.03 * sampleRate).round();
  for (var i = 0; i < crackLen; i++) {
    final t = i / sampleRate;
    buf[i] += (rng.nextDouble() * 2 - 1) * math.exp(-t * 160) * (0.5 + 0.4 * energy);
  }
  // Tail: decaying noise, low-passed.
  final tail = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    tail[i] = (rng.nextDouble() * 2 - 1) * math.exp(-t * (5 - 2 * energy)) * 0.35;
  }
  final filtered = lowpass(tail, 900 + 1800 * energy);
  for (var i = 0; i < n; i++) {
    buf[i] += filtered[i];
  }
  return softclip(buf, 0.95);
}

Float64List fizzle() {
  final seconds = 0.7;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  var phase = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final f = 420 * math.exp(-t * 3) + 60;
    phase += 2 * math.pi * f / sampleRate;
    final sputter = rng.nextDouble() < 0.5 + 0.5 * math.sin(t * 60) ? 1.0 : 0.3;
    final env = math.exp(-t * 4);
    buf[i] = (math.sin(phase) * 0.3 + (rng.nextDouble() * 2 - 1) * 0.25) * env * sputter;
  }
  return lowpass(buf, 2500);
}

Float64List implosion() {
  final seconds = 0.45;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final env = math.pow(t / seconds, 2.2).toDouble();
    buf[i] = (rng.nextDouble() * 2 - 1) * env * 0.6;
  }
  // Rising filter cutoff: approximate by mixing two lowpasses.
  final lo = lowpass(buf, 400);
  final hi = lowpass(buf, 4000);
  for (var i = 0; i < n; i++) {
    final m = i / n;
    buf[i] = lo[i] * (1 - m) + hi[i] * m;
  }
  return buf;
}

Float64List fracture(double freq) {
  final seconds = 0.12;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final env = math.exp(-t * 45);
    buf[i] = (math.sin(2 * math.pi * freq * t) * 0.45 +
            math.sin(2 * math.pi * freq * 1.51 * t) * 0.25 +
            math.sin(2 * math.pi * freq * 2.13 * t) * 0.12 +
            (rng.nextDouble() * 2 - 1) * 0.12 * math.exp(-t * 200)) *
        env;
  }
  return buf;
}

Float64List arc() {
  final seconds = 0.16;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final buzz = 0.5 + 0.5 * math.sin(2 * math.pi * 55 * t);
    final env = math.exp(-t * 18);
    buf[i] = (rng.nextDouble() * 2 - 1) * buzz * env * 0.7 +
        math.sin(2 * math.pi * 1800 * t) * env * 0.15;
  }
  return highpass(buf, 900);
}

Float64List coreHit() {
  final seconds = 0.8;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  var phase = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final f = 40 + 120 * math.exp(-t * 7);
    phase += 2 * math.pi * f / sampleRate;
    buf[i] = math.sin(phase) * math.exp(-t * 4) * 0.7;
    // Two-tone alarm.
    final tone = (t * 8).floor().isEven ? 660.0 : 520.0;
    buf[i] += math.sin(2 * math.pi * tone * t) * math.exp(-t * 3) * 0.12;
  }
  return softclip(buf, 0.95);
}

Float64List click() {
  final n = (0.06 * sampleRate).round();
  final buf = Float64List(n);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    buf[i] = math.sin(2 * math.pi * 1400 * t) * math.exp(-t * 90) * 0.4;
  }
  return buf;
}

Float64List gameOver() {
  final seconds = 1.4;
  final n = (seconds * sampleRate).round();
  final buf = Float64List(n);
  const notes = [392.0, 349.2, 311.1, 261.6];
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final idx = math.min(notes.length - 1, (t / 0.3).floor());
    final local = t - idx * 0.3;
    final f = notes[idx];
    final env = math.exp(-local * 5) * (idx == notes.length - 1 ? 1.3 : 1.0);
    buf[i] = (math.sin(2 * math.pi * f * t) * 0.35 + math.sin(2 * math.pi * f * 0.5 * t) * 0.2) * env;
  }
  return lowpass(buf, 3000);
}

// ---- DSP helpers -----------------------------------------------------------

Float64List lowpass(Float64List input, double cutoff) {
  final out = Float64List(input.length);
  final rc = 1 / (2 * math.pi * cutoff);
  final dt = 1 / sampleRate;
  final a = dt / (rc + dt);
  var y = 0.0;
  for (var i = 0; i < input.length; i++) {
    y += a * (input[i] - y);
    out[i] = y;
  }
  return out;
}

Float64List highpass(Float64List input, double cutoff) {
  final lp = lowpass(input, cutoff);
  final out = Float64List(input.length);
  for (var i = 0; i < input.length; i++) {
    out[i] = input[i] - lp[i];
  }
  return out;
}

Float64List softclip(Float64List input, double drive) {
  final out = Float64List(input.length);
  for (var i = 0; i < input.length; i++) {
    out[i] = math.atan(input[i] * drive * 1.4) / (math.pi / 2);
  }
  return out;
}

void write(Directory dir, String name, Float64List samples) {
  // Short fade at both ends to avoid clicks (loops are seamless already but
  // a 1 ms fade is inaudible).
  final n = samples.length;
  final fade = (0.001 * sampleRate).round();
  final data = ByteData(44 + n * 2);
  void str(int o, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(o + i, s.codeUnitAt(i));
    }
  }

  str(0, 'RIFF');
  data.setUint32(4, 36 + n * 2, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  str(36, 'data');
  data.setUint32(40, n * 2, Endian.little);
  var peak = 0.0;
  for (final s in samples) {
    peak = math.max(peak, s.abs());
  }
  final norm = peak > 0 ? math.min(1.0, 0.9 / peak) : 1.0;
  for (var i = 0; i < n; i++) {
    var v = samples[i] * norm;
    if (!name.startsWith('charge')) {
      if (i < fade) {
        v *= i / fade;
      }
      if (i > n - fade) {
        v *= (n - i) / fade;
      }
    }
    data.setInt16(44 + i * 2, (v.clamp(-1.0, 1.0) * 32767).round(), Endian.little);
  }
  File('${dir.path}/$name').writeAsBytesSync(data.buffer.asUint8List());
}
