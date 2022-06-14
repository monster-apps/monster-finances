import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vrouter/vrouter.dart';

class WidgetInputDialog extends HookWidget {
  WidgetInputDialog({
    Key? key,
    required this.title,
    required this.value,
    required this.onConfirm,
  }) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  final String title;
  final String value;
  final Function(String value) onConfirm;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: FormBuilder(
                key: _formKey,
                child: FormBuilderTextField(
                  name: title,
                  autofocus: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => context.vRouter.pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      onConfirm(
                          _formKey.currentState!.value.entries.first.value);
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
