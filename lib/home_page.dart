import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:meta_pipe/components/side_menu_builder.dart';
import 'package:meta_pipe/views/generating_with_context.dart';
import 'package:meta_pipe/views/generating_with_relation.dart';
import 'package:meta_pipe/views/generating_with_source.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenuController = SideMenuController();

  @override
  void initState() {
    sideMenuController.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  PreferredSize bottomShadowOfAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        height: 1,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> logoComposition() {
    return [
      Transform.translate(
        offset: const Offset(-10, -1),
        child: Transform(
          transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
          alignment: Alignment.center,
          child: Icon(
            Icons.bubble_chart,
            color: ThemeData().colorScheme.secondary,
            size: 30,
          ),
        ),
      ),
      Transform.translate(
        offset: const Offset(-16, 0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 32,
            color: ThemeData().colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: ThemeData().colorScheme.surfaceContainer,
          title: SizedBox(
            width: 175,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: logoComposition(),
            ),
          ),
          // bottom: bottomShadowOfAppBar(),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenuBuilder(sideMenu: sideMenuController),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeData().colorScheme.surfaceContainer,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: ThemeData().colorScheme.surface,
                  ),
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      ViewOfGenerationWithContext(),
                      ViewOfGenerationWithRelation(),
                      ViewOfGenerationWithSource(),
                    ],
                  ),
                ),
              ),
              // child:
            ),
          ],
        ),
      ),
    );
  }
}
