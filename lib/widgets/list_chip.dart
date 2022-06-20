import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class WidgetChip extends HookWidget {
  WidgetChip({
    Key? key,
    this.icon,
    required this.title,
    required this.value,
    required this.onChange,
    required this.options,
  }) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  final IconData? icon;
  final String title;
  final String value;
  final List<FormBuilderChipOption<String>> options;
  final ValueChanged<String?> onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon),
        title: FormBuilder(
          key: _formKey,
          child: FormBuilderChoiceChip<String>(
            name: 'choice_chip',
            onChanged: onChange,
            decoration: const InputDecoration(
              labelText: 'Select an option',
            ),
            options: options,
          ),
        ));
  }
}
