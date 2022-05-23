import 'package:objectbox/objectbox.dart';

import 'account_responsible.dart';
import 'category.dart';
import 'tag.dart';

@Entity()
class Transaction {
  int id = 0;
  double value;
  String description;

  @Property(type: PropertyType.date)
  DateTime date;

  String? notes;

  final category = ToOne<Category>();
  final responsible = ToOne<AccountResponsible>();
  final currency = ToOne<Tag>();
  final tags = ToMany<Tag>();

  late bool isPositiveValue;

  Transaction({
    this.id = 0,
    required this.value,
    required this.description,
    required this.date,
    this.notes,
  }) {
    isPositiveValue = value > 0;
  }
}
