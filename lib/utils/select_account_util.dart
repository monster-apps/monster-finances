import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/utils/screen_util.dart';
import 'package:vrouter/vrouter.dart';

class SelectAccountUtil {
  void select(context, ref, accountId) {
    ref.read(currentAccountProvider.notifier).update(accountId);

    if (!ScreenUtil().isLargeScreen(context)) {
      VRouter.of(context)
          .toSegments(['accounts', accountId.toString(), 'transactions']);
    }
  }
}
