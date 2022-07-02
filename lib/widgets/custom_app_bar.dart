import 'package:flutter/material.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:vrouter/vrouter.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: !ScreenUtil().isLargeScreen(context) &&
              context.vRouter.path != '/overview' &&
              VRouter.of(context).historyCanBack()
          ? const BackButton(
              color: Colors.black,
            )
          : null,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
