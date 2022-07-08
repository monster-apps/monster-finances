import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class WidgetInput extends HookWidget {
  const WidgetInput({
    Key? key,
    this.icon,
    this.maxLines,
    this.value,
    required this.title,
    required this.hint,
  }) : super(key: key);

  final String title;
  final String hint;
  final IconData? icon;
  final int? maxLines;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: FormBuilderTextField(
        name: title,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: title,
          alignLabelWithHint: true,
          hintText: hint,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    );
  }
}
