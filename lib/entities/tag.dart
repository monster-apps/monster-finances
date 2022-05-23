import 'package:objectbox/objectbox.dart';

@Entity()
class Tag {
  int id = 0;
  String value;

  Tag({
    this.id = 0,
    required this.value,
  });
}
