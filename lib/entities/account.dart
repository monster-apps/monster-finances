import 'package:objectbox/objectbox.dart';

import 'account_responsible.dart';
import 'account_type.dart';
import 'currency.dart';

@Entity()
class Account {
  int id = 0;
  String name;
  String? description;

  final type = ToOne<AccountType>();
  final responsible = ToOne<AccountResponsible>();
  final operatingCurrency = ToOne<Currency>();

  Account({
    this.id = 0,
    required this.name,
    this.description,
  });
}
