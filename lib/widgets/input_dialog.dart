import 'package:flutter/material.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              content: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter the ${widget.label}',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some value';
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
            );
          },
        );
      },
    );
  }
}
