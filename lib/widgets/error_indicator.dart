import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final Object error;

  const ErrorIndicator({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Something went wrong. Error ${error.toString()}'),
    );
  }
}
