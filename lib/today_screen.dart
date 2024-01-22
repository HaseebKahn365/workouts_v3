import 'package:flutter/material.dart';

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 400;

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    // Color selectedColor = Theme.of(context).primaryColor;
    // ThemeData lightTheme = ThemeData(colorSchemeSeed: selectedColor, brightness: Brightness.light);
    // ThemeData darkTheme = ThemeData(colorSchemeSeed: selectedColor, brightness: Brightness.dark);

    return Expanded(
        child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        Text('data'),
      ],
    ));
  }
}
