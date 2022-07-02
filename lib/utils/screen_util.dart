import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as pkg_screenutil;
import 'package:monster_finances/config.dart';

class ScreenUtil {
  bool isLargeScreen(BuildContext context) {
    return pkg_screenutil.ScreenUtil().screenWidth >= Config().breakpoint;
  }
}
