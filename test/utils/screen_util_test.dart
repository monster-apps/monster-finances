import 'package:flutter_test/flutter_test.dart';
import 'package:monster_finances/config.dart';
import 'package:monster_finances/utils/screen_util.dart';

import '../_test_utils/fake_build_context.dart';

void main() {
  group('ScreenUtil().isLargeScreen', () {
    test('should be true when width == breakpoint', () {
      final context =
          BuildContextTestUtil().createFakeContext(width: Config().breakpoint);

      final screenUtil = ScreenUtil();
      screenUtil.isLargeScreen(context);

      expect(screenUtil.isLargeScreen(context), isTrue);
    });

    test('should be true when width > breakpoint', () {
      final context = BuildContextTestUtil().createFakeContext(width: 601.0);

      final screenUtil = ScreenUtil();
      screenUtil.isLargeScreen(context);

      expect(screenUtil.isLargeScreen(context), isTrue);
    });

    test('should be false when width < breakpoint', () {
      final context = BuildContextTestUtil().createFakeContext(width: 599.0);

      final screenUtil = ScreenUtil();
      screenUtil.isLargeScreen(context);

      expect(screenUtil.isLargeScreen(context), isFalse);
    });
  });
}
