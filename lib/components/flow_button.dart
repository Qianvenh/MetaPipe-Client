import 'package:flutter/material.dart';

class FlowButton extends StatelessWidget {
  final void Function()? handlePress;
  final Icon displayIcon;
  final EdgeInsetsGeometry padding;
  final double? height;
  final double? btnSize;
  final Color btnColor;
  const FlowButton({
    super.key,
    this.handlePress,
    this.height,
    this.btnSize = 50,
    this.padding = EdgeInsets.zero,
    required this.btnColor,
    required this.displayIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: padding,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraits) =>
              Container(
            alignment: Alignment.center,
            child: IconButton(
              color: btnColor,
              iconSize: btnSize,
              icon: displayIcon,
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (handlePress != null) {
                  handlePress!();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
