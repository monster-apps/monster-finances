import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:objectbox/objectbox.dart';

import 'account_responsible.dart';
import 'account_type.dart';

@Entity()
class Account {
  int id = 0;
  String name;
  String? description;
  String? notes;

  final type = ToOne<AccountType>();
  final responsible = ToOne<AccountResponsible>();

  @Backlink('account')
  final transactions = ToMany<Transaction>();

  Account({this.id = 0, required this.name, this.description, this.notes});
}
