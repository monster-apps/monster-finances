import 'package:objectbox/objectbox.dart';

import 'account.dart';
import 'transaction.dart';

@Entity()
class AccountResponsible {
  int id = 0;
  String name;

  @Backlink('responsible')
  final accounts = ToMany<Account>();

  @Backlink('responsible')
  final transactions = ToMany<Transaction>();

  AccountResponsible({
    this.id = 0,
    required this.name,
  });
}
