import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:vrouter/vrouter.dart';

class WidgetInputDialog extends StatefulWidget {
  const WidgetInputDialog({
    Key? key,
    required this.label,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  State<WidgetInputDialog> createState() => _WidgetInputDialogState();

  final String label;
  final String title;
  final String value;
}

class _WidgetInputDialogState extends State<WidgetInputDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(widget.label[0].toUpperCase())),
      title: Text('Add ${widget.title}'),
      subtitle: Text(widget.value),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add ${widget.title}'),
              content: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                child: FormBuilderTextField(
                  name: 'account',
                  onChanged: _onChanged,
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
                    print("validation");
                    print(_formKey.currentState?.saveAndValidate() ?? false);

                    // if (_formKey.currentState!.validate()) {
                    //   print(_formKey.currentState!.value);
                    // } else {
                    //   print("Error validation");
                    // }
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
