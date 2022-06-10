import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:vrouter/vrouter.dart';

class SelectAccountUtil {
  void select(BuildContext context, WidgetRef ref, int accountId) {
    ref.read(currentAccountProvider.notifier).update(accountId);

    if (!ScreenUtil().isLargeScreen(context)) {
      VRouter.of(context)
          .toSegments(['accounts', accountId.toString(), 'transactions']);
    }
  }
}
