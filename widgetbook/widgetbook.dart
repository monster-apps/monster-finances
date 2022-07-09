import 'package:flutter/material.dart';
import 'package:monster_finances/widgets/list_input.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const HotReloadWidgetBook());
}

class HotReloadWidgetBook extends StatelessWidget {
  const HotReloadWidgetBook({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      categories: [
        WidgetbookCategory(
          name: 'Form',
          widgets: [
            WidgetbookComponent(
              name: 'Button',
              useCases: [
                WidgetbookUseCase(
                  name: 'elevated',
                  builder: (context) => const WidgetInput(
                    title: "Title List",
                    hint: "Hint description",
                    value: "value",
                  ),
                ),
              ],
            ),
          ],
        )
      ],
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: ThemeData.light(),
        ),
        WidgetbookTheme(
          name: 'Dark',
          data: ThemeData.dark(),
        ),
      ],
      appInfo: AppInfo(name: 'Monster Finances'),
    );
  }
}
