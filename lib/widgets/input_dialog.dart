import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class WidgetInputDialog extends StatefulWidget {
  const WidgetInputDialog({Key? key}) : super(key: key);

  @override
  State<WidgetInputDialog> createState() => _WidgetInputDialogState();
}

class _WidgetInputDialogState extends State<WidgetInputDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Text('N')),
      title: const Text('Add account'),
      subtitle: const Text('Bank of Montreal'),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Title"),
                  content: Form(
                    key: _formKey,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter the account name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => context.vRouter.pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.vRouter.pop();
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      },
    );
  }
}
