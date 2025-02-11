import 'package:flutter/material.dart';

class DropdownMenuNode extends StatelessWidget {
  final String label;
  final Icon? leadingIcon;
  final Icon? outterIcon;
  final List<String> data;
  final void Function(String?)? handleSelected;
  final String? initialSelection;

  final double outterIconRightPadding;

  const DropdownMenuNode({
    super.key,
    this.label = "",
    this.leadingIcon,
    this.outterIcon,
    this.handleSelected,
    this.initialSelection,
    required this.data,
    required this.outterIconRightPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (outterIcon != null)
        Padding(
          padding: EdgeInsets.only(right: outterIconRightPadding),
          child: outterIcon,
        ),
      Expanded(
        child: DropdownMenu<String>(
          requestFocusOnTap: false,
          expandedInsets: EdgeInsets.zero,
          menuHeight: 256,
          initialSelection: initialSelection ?? data.first,
          onSelected: (str) {
            FocusScope.of(context).requestFocus(FocusNode());
            if (handleSelected != null) {
              handleSelected!(str);
            }
          },
          dropdownMenuEntries: _buildMenuList(data),
          label: Text(label),
          leadingIcon: leadingIcon,
          textStyle: const TextStyle(fontSize: 12),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
          ),
          menuStyle: const MenuStyle(
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            ),
            backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
          ),
        ),
      )
    ]);
  }

  List<DropdownMenuEntry<String>> _buildMenuList(List<String> data) {
    return data.map((String value) {
      return DropdownMenuEntry<String>(
        value: value,
        label: value,
      );
    }).toList();
  }
}
