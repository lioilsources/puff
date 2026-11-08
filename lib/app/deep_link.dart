/// Where a `puff://` link asks the app to go.
///
/// ```text
/// puff://play               start a run with the current setup
/// puff://palette/<name>     switch palette, stay in the menu
/// puff://event/<id>         an In-App Event; `weekly` opens the challenge
/// anything else             the menu
/// ```
///
/// In-App Events in App Store Connect take these as their deep link.
sealed class DeepLink {
  const DeepLink();

  static const scheme = 'puff';

  static DeepLink parse(Uri uri) {
    if (uri.scheme != scheme) {
      return const OpenMenu();
    }
    // `puff://play` puts "play" in the host; `puff:/play` and `puff:play` in
    // the path. Accept all three.
    final parts = [
      if (uri.host.isNotEmpty) uri.host,
      ...uri.pathSegments.where((s) => s.isNotEmpty),
    ].map((s) => s.toLowerCase()).toList();
    if (parts.isEmpty) {
      return const OpenMenu();
    }
    return switch (parts) {
      ['play'] => const StartRun(),
      ['palette', final name] => SelectPalette(name),
      ['event', 'weekly'] => const StartWeekly(),
      ['event', final id] => OpenEvent(id),
      _ => const OpenMenu(),
    };
  }
}

class OpenMenu extends DeepLink {
  const OpenMenu();
}

class StartRun extends DeepLink {
  const StartRun();
}

class StartWeekly extends DeepLink {
  const StartWeekly();
}

/// [name] is lower-cased; match palettes case-insensitively.
class SelectPalette extends DeepLink {
  const SelectPalette(this.name);

  final String name;
}

/// An event the build does not handle specially opens the menu.
class OpenEvent extends DeepLink {
  const OpenEvent(this.id);

  final String id;
}
