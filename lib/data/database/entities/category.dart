import 'package:objectbox/objectbox.dart';

import 'transaction.dart';

@Entity()
class Category {
  int id = 0;
  String name;

  @Backlink('category')
  final transactions = ToMany<Transaction>();

  Category({
    this.id = 0,
    required this.name,
  });
}
