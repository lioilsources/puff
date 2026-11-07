import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import '../game/palette.dart';

/// Store links that carry a campaign, so App Analytics can count installs
/// that came from a shared score.
class ShareLinks {
  /// App Store Connect → App Analytics → Campaigns: the provider token of
  /// the team. Empty until Ol1n fills it in; the link then goes without it.
  static const providerToken = '';

  static const appStoreId = '6808586613';

  static String appStore() {
    final pt = providerToken.isEmpty ? '' : '&pt=$providerToken';
    return 'https://apps.apple.com/app/id$appStoreId?ct=share$pt';
  }

  static const play =
      'https://play.google.com/store/apps/details?id=com.ol1n.puff'
      '&referrer=utm_source%3Dshare%26utm_medium%3Dscore';

  static String forPlatform() =>
      defaultTargetPlatform == TargetPlatform.android ? play : appStore();
}

/// The picture that goes with a shared best: a neon blast in the player's
/// palette with the score over it. Drawn here rather than captured from the
/// game, so it looks the same whatever was on screen at game over.
class ShareCard {
  static const width = 1080.0;
  static const height = 1350.0;

  static Future<Uint8List> render({
    required Palette palette,
    required int score,
    required String headline,
    required String detail,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    _paint(canvas, palette, score, headline, detail);
    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    picture.dispose();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  }

  static void _paint(Canvas c, Palette p, int score, String headline, String detail) {
    const rect = Rect.fromLTWH(0, 0, width, height);
    const center = Offset(width / 2, 500);
    c.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.radial(center, 900, [p.bgAlt, p.bg], [0, 1]),
    );

    // Same picture for the same score.
    final r = math.Random(score);
    Paint neon(Color color, double width, {double blur = 0}) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = blur > 0 ? MaskFilter.blur(BlurStyle.normal, blur) : null;

    void glowing(void Function(Paint) draw, Color color, double width) {
      draw(neon(color.withValues(alpha: 0.45), width * 3, blur: 28));
      draw(neon(color, width, blur: 4));
      draw(neon(Color.lerp(color, const Color(0xFFFFFFFF), 0.6)!, width * 0.4));
    }

    // Rays.
    final rayColors = [p.primary, p.accent, p.glow];
    for (var i = 0; i < 30; i++) {
      final a = i / 30 * math.pi * 2 + r.nextDouble() * 0.12;
      final from = 130 + r.nextDouble() * 30;
      final to = from + 70 + r.nextDouble() * 190;
      final d = Offset(math.cos(a), math.sin(a));
      glowing(
        (paint) => c.drawLine(center + d * from, center + d * to, paint),
        rayColors[i % 3],
        7,
      );
    }

    // Shards flying out.
    for (var i = 0; i < 11; i++) {
      final a = i / 11 * math.pi * 2 + r.nextDouble() * 0.4;
      final dist = 330 + r.nextDouble() * 110;
      final at = center + Offset(math.cos(a), math.sin(a)) * dist;
      final sides = 3 + r.nextInt(3);
      final size = 22 + r.nextDouble() * 22;
      final spin = r.nextDouble() * math.pi;
      final path = Path();
      for (var k = 0; k < sides; k++) {
        final t = spin + k / sides * math.pi * 2;
        final v = at + Offset(math.cos(t), math.sin(t)) * size;
        k == 0 ? path.moveTo(v.dx, v.dy) : path.lineTo(v.dx, v.dy);
      }
      path.close();
      glowing((paint) => c.drawPath(path, paint), i.isEven ? p.secondary : p.primary, 6);
    }

    // The cloud at the heart of it.
    glowing((paint) => c.drawCircle(center, 92, paint), p.primary, 12);
    c.drawCircle(
      center,
      60,
      Paint()
        ..color = p.accent.withValues(alpha: 0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 26),
    );
    c.drawCircle(center, 30, Paint()..color = const Color(0xFFFFFFFF));

    _text(c, headline, 940, 54, p.accent, FontWeight.w700, spacing: 10);
    _text(c, '$score', 1000, 170, p.primary, FontWeight.w800, spacing: 4);
    _text(c, detail, 1190, 38, p.glow.withValues(alpha: 0.85), FontWeight.w500, spacing: 3);
    _text(c, 'PUFF', 1258, 46, p.secondary, FontWeight.w800, spacing: 18);
  }

  static void _text(
    Canvas c,
    String text,
    double top,
    double size,
    Color color,
    FontWeight weight, {
    double spacing = 0,
  }) {
    final builder =
        ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: TextAlign.center, maxLines: 2))
          ..pushStyle(
            ui.TextStyle(
              color: color,
              fontSize: size,
              fontWeight: weight,
              letterSpacing: spacing,
              shadows: [Shadow(color: color.withValues(alpha: 0.8), blurRadius: size * 0.4)],
            ),
          )
          ..addText(text);
    final paragraph = builder.build()..layout(const ui.ParagraphConstraints(width: width - 80));
    c.drawParagraph(paragraph, Offset(40, top));
  }

  /// Renders the card and opens the system share sheet. [origin] anchors
  /// the sheet's popover on iPad.
  static Future<void> share({
    required Palette palette,
    required int score,
    required String headline,
    required String detail,
    required String text,
    Rect? origin,
  }) async {
    try {
      final png = await render(palette: palette, score: score, headline: headline, detail: detail);
      await SharePlus.instance.share(
        ShareParams(
          text: text,
          files: [XFile.fromData(png, mimeType: 'image/png', name: 'puff-$score.png')],
          sharePositionOrigin: origin,
        ),
      );
    } catch (error) {
      debugPrint('Puff: share failed: $error');
    }
  }
}
