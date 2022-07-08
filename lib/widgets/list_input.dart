import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class WidgetInput extends HookWidget {
  WidgetInput({
    Key? key,
    this.icon,
    this.maxLines,
    required this.title,
    required this.hint,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  final IconData? icon;
  final int? maxLines;
  final String title;
  final String hint;
  final String value;
  final ValueChanged<String?> onChange;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: FormBuilder(
        key: _formKey,
        child: FormBuilderTextField(
          name: title,
          maxLines: maxLines,
          onChanged: onChange,
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
      ),
    );
  }
}
