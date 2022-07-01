import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:vrouter/vrouter.dart';

class SelectAccountUtil {
  void select(BuildContext context, WidgetRef ref, Account account) {
    ref.read(currentAccountProvider.notifier).update(ref, account);
    VRouter.of(context).toSegments([
      'accounts',
      account.id.toString(),
      'transactions',
    ]);
  }
}
