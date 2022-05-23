import 'package:objectbox/objectbox.dart';

import 'account.dart';

@Entity()
class AccountType {
  int id = 0;
  String name;

  @Backlink('type')
  final accounts = ToMany<Account>();

  AccountType({
    this.id = 0,
    required this.name,
  });
}
