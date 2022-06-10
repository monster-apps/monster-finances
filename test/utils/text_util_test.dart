import 'package:flutter_test/flutter_test.dart';
import 'package:monster_finances/utils/text_util.dart';

void main() {
  group('TextUtil().getFormattedAmount', () {
    test('should have - symbol when value is negative', () {
      expect(TextUtil().getFormattedAmount(-10.0), '- 10.0');
    });

    test('should have + symbol when value is positive', () {
      expect(TextUtil().getFormattedAmount(15.0), '+ 15.0');
    });

    test('should have no symbol when value is zero', () {
      expect(TextUtil().getFormattedAmount(0), '0.0');
    });
  });
}
