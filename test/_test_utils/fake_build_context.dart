import 'package:flutter/widgets.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fake_build_context.mocks.dart';

@GenerateMocks([BuildContext])
class BuildContextTestUtil {
  BuildContext createFakeContext({double width = 600.0}) {
    final context = MockBuildContext();

    final mediaQuery = MediaQuery(
      data: MediaQueryData(size: Size.fromWidth(width)),
      child: const SizedBox(),
    );
    when(context.widget).thenReturn(const SizedBox());
    when(context.findAncestorWidgetOfExactType()).thenReturn(mediaQuery);
    when(context.dependOnInheritedWidgetOfExactType<MediaQuery>())
        .thenReturn(mediaQuery);
    when(context.getElementForInheritedWidgetOfExactType())
        .thenReturn(InheritedElement(mediaQuery));

    return context;
  }
}
