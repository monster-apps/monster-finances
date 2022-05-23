import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Page not found'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: context.vRouter.historyCanBack()
                      ? () {
                          context.vRouter.historyBack();
                        }
                      : null,
                  child: const Text('Go back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.vRouter.to('/');
                  },
                  child: const Text('Go home'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
