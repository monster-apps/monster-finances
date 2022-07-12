import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/account_responsible.dart';
import 'package:monster_finances/providers/responsible_query_provider.dart';

final FutureProvider<List<AccountResponsible>> responsibleListProvider =
    FutureProvider((ref) async {
  final responsibleList = ref.watch(responsibleListNotifierProvider);
  return responsibleList;
});

final StateNotifierProvider<ResponsibleListNotifier, List<AccountResponsible>>
    responsibleListNotifierProvider =
    StateNotifierProvider<ResponsibleListNotifier, List<AccountResponsible>>(
        (ref) {
  return ResponsibleListNotifier(ref);
});

class ResponsibleListNotifier extends StateNotifier<List<AccountResponsible>> {
  ResponsibleListNotifier(ref)
      : super(ref.read(responsibleQueryProvider).getAllResponsible());

  void add(ref, AccountResponsible responsible) async {
    ref.read(responsibleQueryProvider).put(responsible);
    state = ref.read(responsibleQueryProvider).getAllResponsible();
  }

  void remove(ref, AccountResponsible responsible) async {
    ref.read(responsibleQueryProvider).remove(responsible);
    state.remove(responsible);
    state = [...state];
  }
}
