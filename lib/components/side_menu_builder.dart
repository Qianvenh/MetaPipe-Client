import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';

class SideMenuBuilder extends StatelessWidget {
  final SideMenuController sideMenu;

  SideMenuBuilder({super.key, required this.sideMenu});

  void changePage(index, _) {
    sideMenu.changePage(index);
  }

  late final List<SideMenuItem> items = [
    SideMenuItem(
      title: 'Context',
      onTap: changePage,
      icon: const Icon(Icons.contrast),
    ),
    SideMenuItem(
      title: 'Relation',
      onTap: changePage,
      icon: const Icon(Icons.join_right),
    ),
    SideMenuItem(
      title: 'Source',
      onTap: changePage,
      icon: const Icon(Icons.join_inner),
    ),
  ];

  double getFitableFontSize(double screenWidth) {
    return screenWidth > 905 ? 15 : 10;
  }

  Widget buildTitleTxt(double screenWidth) {
    final double fitableFontSize = getFitableFontSize(screenWidth);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Wrap(children: [
          Text('Generate ', style: TextStyle(fontSize: fitableFontSize)),
          Transform.translate(
            offset: const Offset(0, 1),
            child: Icon(RpgAwesome.burning_meteor, size: fitableFontSize + 2),
          ),
        ]),
        Text(
          ' with:',
          style: TextStyle(fontSize: fitableFontSize),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      items: items,
      controller: sideMenu,
      title: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: buildTitleTxt(MediaQuery.of(context).size.width),
        ),
        const Divider(
          indent: 8.0,
          endIndent: 8.0,
        ),
        const Padding(padding: EdgeInsets.only(bottom: 4)),
      ]),
      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Text(
            'by HFUTer A901',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ),
      ),
      style: SideMenuStyle(
        displayMode: SideMenuDisplayMode.auto,
        selectedColor: ThemeData().primaryColor,
        selectedTitleTextStyle:
            TextStyle(color: ThemeData().colorScheme.onPrimary),
        selectedIconColor: Colors.white,
        openSideMenuWidth: 135,
        compactSideMenuWidth: 60,
        itemInnerSpacing: 6.0,
        backgroundColor: ThemeData().colorScheme.surfaceContainer,
      ),
    );
  }
}
