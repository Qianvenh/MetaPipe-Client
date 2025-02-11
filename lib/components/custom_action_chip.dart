import 'package:flutter/material.dart';
// import 'package:widgets/utils/dialog_about.dart';

class CustomActionChip extends StatelessWidget {
  const CustomActionChip({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      padding: const EdgeInsets.all(5),
      labelPadding: const EdgeInsets.all(3),
      label: const Text("This is a ActionChip."),
      backgroundColor: Colors.grey.withAlpha(66),
      avatar: Image.asset("assets/images/icon_head.webp"),
      shadowColor: Colors.orangeAccent,
      elevation: 3,
      pressElevation: 5,
      // onPressed: () => DialogAbout.show(context),
    );
  }
}
