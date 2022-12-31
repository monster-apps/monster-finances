import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<PackageInfo> getPackageInfo() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo;
    }

    return FutureBuilder<PackageInfo>(
      future: getPackageInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Icon(Icons.house_outlined),
                  const Text('Monster Finances'),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.data!.version.toString()),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
