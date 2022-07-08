import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:monster_finances/data/database/entities/account.dart';
import 'package:monster_finances/data/database/entities/account_type.dart';
import 'package:objectbox/objectbox.dart';

import 'fake_accounts.mocks.dart';

@GenerateMocks([Account, ToOne])
class AccountTestUtil {
  List<Account> createFakeAccounts({
    int amount = 1,
    int startFromId = 1,
    int typeId = 1,
  }) {
    List<Account> accounts = [];
    for (int i = startFromId; i <= startFromId + amount - 1; i++) {
      MockAccount account = MockAccount();

      MockToOne<AccountType> toOne = MockToOne();
      when(toOne.hasValue).thenReturn(true);
      when(toOne.target).thenReturn(
        AccountType(id: typeId, name: 'Type $typeId'),
      );
      when(toOne.targetId).thenReturn(typeId);
      when(account.type).thenReturn(toOne);
      when(account.id).thenReturn(i);
      when(account.name).thenReturn('Bank $i');
      when(account.description).thenReturn(null);

      accounts.add(account);
    }

    return accounts;
  }
}
