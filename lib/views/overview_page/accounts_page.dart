import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/entities/account.dart';
import 'package:monster_finances/providers/account_list_provider.dart';
import 'package:monster_finances/providers/current_account_provider.dart';
import 'package:monster_finances/providers/total_amount_by_account_provider.dart';
import 'package:monster_finances/providers/total_amount_by_account_type_provider.dart';
import 'package:monster_finances/providers/total_amount_provider.dart';
import 'package:monster_finances/utils/select_account_util.dart';
import 'package:monster_finances/utils/text_util.dart';
import 'package:vrouter/vrouter.dart';

class AccountsPage extends HookConsumerWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmount = ref.watch(totalAmountProvider);
    final int currentAccountId = ref.watch(currentAccountProvider);

    Future<void> createAccount() async {
      ref.read(accountListProvider.notifier).add(Account(name: 'Bank F'));
    }

    final Future<String> foo = Future<String>.delayed(
      const Duration(seconds: 1),
      () => 'Overview Page',
    );

    buildWithBody(Widget body) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text('Overview'),
        ),
        body: body,
        bottomNavigationBar: BottomAppBar(
          child: ListTile(
            title: const Text('Total'),
            trailing: Text(TextUtil().getFormattedAmount(totalAmount)),
            contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            VRouter.of(context).to('/accounts/new');
          },
          child: const Icon(Icons.add),
        ),
      );
    }

    mainBody() {
      return SingleChildScrollView(
        child: Row(children: [
          Expanded(
            child: GroupedListView<Account, String>(
              elements: ref.watch(accountListProvider),
              groupBy: (element) => element.type.target?.name ?? '',
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // itemExtent: 40.0,
              separator: const Divider(),
              groupHeaderBuilder: (element) {
                final amountByAccountType = ref.watch(
                    totalAmountByAccountTypeProvider(element.type.targetId));
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(element.type.target?.name ?? ''),
                      const Spacer(),
                      Text(TextUtil().getFormattedAmount(amountByAccountType)),
                    ],
                  ),
                );
              },
              itemBuilder: (context, element) {
                final amountByAccount =
                    ref.watch(totalAmountByAccountProvider(element.id));
                return ListTile(
                  title: Text(element.name),
                  subtitle: Text(element.description ?? ''),
                  selected: currentAccountId == element.id,
                  trailing:
                      Text(TextUtil().getFormattedAmount(amountByAccount)),
                  contentPadding:
                      const EdgeInsets.only(left: 16.0, right: 16.0),
                  onTap: () {
                    SelectAccountUtil().select(context, ref, element.id);
                  },
                );
              },
            ),
          ),
        ]),
      );
    }

    return FutureBuilder(
      future: foo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildWithBody(mainBody());
        }
        return buildWithBody(const Center(child: CircularProgressIndicator()));
      },
    );
  }
}
