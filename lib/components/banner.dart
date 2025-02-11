import 'package:flutter/material.dart';

class GenerationBanner extends StatelessWidget {
  final String functionText;
  const GenerationBanner({super.key, required this.functionText});

  double getFitalbeFontSize(double screenWidth) {
    return screenWidth > 905 ? 32 : 20;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(children: [
        Text(
          "Generate Visual Metaphor by ",
          style: TextStyle(
              fontSize: getFitalbeFontSize(screenWidth), color: Colors.black45),
        ),
        Text(
          "Target Objects ",
          style: TextStyle(
            fontSize: getFitalbeFontSize(screenWidth),
            color: Colors.black45,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "& ",
          style: TextStyle(
              fontSize: getFitalbeFontSize(screenWidth), color: Colors.black45),
        ),
        Text(
          functionText,
          style: TextStyle(
            fontSize: getFitalbeFontSize(screenWidth),
            color: ThemeData().colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
    );
  }
}
