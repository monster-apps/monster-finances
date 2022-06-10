import 'package:flutter_test/flutter_test.dart';
import 'package:monster_finances/config.dart';

void main() {
  test('Config breakpoint should be 600.0', () {
    final config = Config();

    expect(config.breakpoint, 600.0);
  });
}
