import 'package:flutter_test/flutter_test.dart';
import 'package:adder/adder.dart';

void main() {
  Adder adder = Adder();

  test('it works', () async {
    expect(adder.add(2, 2), 4);
  });
}
