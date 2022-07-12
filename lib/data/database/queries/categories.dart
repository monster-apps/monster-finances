import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/providers/database_provider.dart';

class CategoryQuery {
  final ProviderRef ref;

  CategoryQuery(this.ref);

  List<Category> getAllCategories() {
    return ref.read(databaseProvider).categories.getAll();
  }

  void put(Category category) {
    ref.read(databaseProvider).categories.put(category);
  }
}
