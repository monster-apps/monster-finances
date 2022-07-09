import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WidgetChip extends HookWidget {
  const WidgetChip({
    Key? key,
    this.icon,
    required this.title,
    required this.options,
  }) : super(key: key);

  final IconData? icon;
  final String title;
  final List<FormBuilderChipOption<String>> options;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: FormBuilderChoiceChip<String>(
        name: title,
        decoration: const InputDecoration(
          labelText: 'Select an option',
        ),
        options: options,
      ),
    );
  }
}
