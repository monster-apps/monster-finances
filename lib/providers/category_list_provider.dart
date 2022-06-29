import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/providers/category_query_provider.dart';

final FutureProvider<List<Category>> categoryListProvider =
    FutureProvider((ref) async {
  final categoryList = ref.watch(categoryListNotifierProvider);
  return categoryList;
});

final StateNotifierProvider<CategoryListNotifier, List<Category>>
    categoryListNotifierProvider =
    StateNotifierProvider<CategoryListNotifier, List<Category>>((ref) {
  return CategoryListNotifier(ref);
});

class CategoryListNotifier extends StateNotifier<List<Category>> {
  CategoryListNotifier(ref)
      : super(ref.read(categoryQueryProvider).getAllCategories());

  void add(ref, Category category) async {
    ref.read(categoryQueryProvider).put(category);
    state = [...state, category];
  }
}
