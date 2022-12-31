import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:monster_finances/data/database/entities/category.dart';
import 'package:monster_finances/providers/category_list_provider.dart';
import 'package:monster_finances/widgets/progress_indicator.dart';

class ErrorIndicator extends HookConsumerWidget {
  final Object error;

  const ErrorIndicator({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Category>> categoryList =
        ref.watch(categoryListProvider);

    buildField(List<Category> categories) {
      return FormBuilderDropdown(
        name: 'category',
        decoration: const InputDecoration(
          labelText: 'Category',
          icon: Icon(null),
        ),
        allowClear: true,
        hint: const Text('Select category'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        items: categories
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                ))
            .toList(),
      );
    }

    return categoryList.when(
      data: (data) => buildField(data),
      error: (e, st) => ErrorIndicator(
        key: const Key('error_category_list'),
        error: e,
      ),
      loading: () => const ProgressIndicator(key: Key('loading_category_list')),
    );
  }
}
