import 'package:objectbox/objectbox.dart';

import 'account.dart';
import 'transaction.dart';

@Entity()
class Currency {
  int id = 0;
  String name;
  String code;
  String symbol;

  @Backlink('operatingCurrency')
  final accounts = ToMany<Account>();

  @Backlink('currency')
  final transactions = ToMany<Transaction>();

  Currency({
    this.id = 0,
    required this.name,
    required this.code,
    required this.symbol,
  });
}
