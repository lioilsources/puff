import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'settings.dart';

/// The three tips. Consumable products with the same ID in App Store Connect
/// and Google Play; prices come from the store.
enum Tip {
  small,
  medium,
  large;

  String get productId => 'puff.tip.$name';

  static Tip? byProductId(String id) {
    for (final t in values) {
      if (t.productId == id) {
        return t;
      }
    }
    return null;
  }
}

enum TipOutcome { thanks, failed }

/// A tip unlocks nothing but the supporter badge. The game stays the same
/// for everybody, and leaderboards stay fair.
class TipJar extends ChangeNotifier {
  TipJar(this.settings);

  final PuffSettings settings;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  /// Products the store returned. Empty when the store is unreachable or
  /// the products are not set up yet; the menu then hides the tip jar.
  final Map<Tip, ProductDetails> products = {};

  /// A purchase sheet is open or the payment is pending.
  bool busy = false;

  /// What happened to the last purchase, shown until the overlay closes.
  TipOutcome? outcome;

  bool get offered => products.length == Tip.values.length;

  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Listens before asking for products, so a purchase left unfinished
  /// last time (app killed mid-payment) is delivered and completed now.
  Future<void> init() async {
    if (!_supported) {
      return;
    }
    final iap = InAppPurchase.instance;
    _sub = iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object e) => debugPrint('Puff: purchase stream: $e'),
    );
    try {
      if (!await iap.isAvailable()) {
        return;
      }
      final response = await iap.queryProductDetails(Tip.values.map((t) => t.productId).toSet());
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Puff: tip products not found: ${response.notFoundIDs}');
      }
      for (final p in response.productDetails) {
        final tip = Tip.byProductId(p.id);
        if (tip != null) {
          products[tip] = p;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Puff: tip jar unavailable: $e');
    }
  }

  Future<void> buy(Tip tip) async {
    final product = products[tip];
    if (product == null || busy) {
      return;
    }
    busy = true;
    outcome = null;
    notifyListeners();
    try {
      final started = await InAppPurchase.instance.buyConsumable(
        purchaseParam: PurchaseParam(productDetails: product),
      );
      if (!started) {
        busy = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Puff: tip failed to start: $e');
      busy = false;
      outcome = TipOutcome.failed;
      notifyListeners();
    }
  }

  /// Clears the thank-you line when the overlay closes.
  void dismiss() {
    outcome = null;
    notifyListeners();
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          busy = true;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (Tip.byProductId(p.productID) != null) {
            await settings.addTip();
          }
          busy = false;
          outcome = TipOutcome.thanks;
        case PurchaseStatus.error:
          debugPrint('Puff: tip error: ${p.error}');
          busy = false;
          outcome = TipOutcome.failed;
        case PurchaseStatus.canceled:
          busy = false;
      }
      if (p.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(p);
        } catch (e) {
          debugPrint('Puff: completing tip failed: $e');
        }
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
