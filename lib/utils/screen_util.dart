import 'package:flutter/widgets.dart';
import 'package:monster_finances/config.dart';

class ScreenUtil {
  bool isLargeScreen(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= Config().breakpoint;
  }
}
