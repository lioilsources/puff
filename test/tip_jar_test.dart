import 'package:flutter_test/flutter_test.dart';
import 'package:puff/app/tip_jar.dart';

void main() {
  test('product IDs match App Store Connect and Play', () {
    expect(Tip.values.map((t) => t.productId), [
      'puff.tip.small',
      'puff.tip.medium',
      'puff.tip.large',
    ]);
  });

  test('unknown product IDs are not tips', () {
    expect(Tip.byProductId('puff.tip.large'), Tip.large);
    expect(Tip.byProductId('puff.tip.huge'), isNull);
  });
}
