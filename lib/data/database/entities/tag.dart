import 'package:monster_finances/data/database/entities/transaction.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Tag {
  int id = 0;
  String value;

  @Backlink('tags')
  final transactions = ToMany<Transaction>();

  Tag({
    this.id = 0,
    required this.value,
  });
}
