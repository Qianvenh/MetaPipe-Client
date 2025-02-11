import 'package:flutter/material.dart';

class CustomTabBarView extends StatefulWidget {
  final List<String> tabs;
  final double? tabBarHeight;
  final double? verticalPadding;
  final List<Widget> views;
  final TabController? diyTabController;
  const CustomTabBarView({
    super.key,
    this.tabBarHeight,
    this.verticalPadding,
    this.diyTabController,
    required this.tabs,
    required this.views,
  });

  @override
  State<CustomTabBarView> createState() => _CustomTabBarViewState();
}

class _CustomTabBarViewState extends State<CustomTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.diyTabController ??
        TabController(vsync: this, length: widget.tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: widget.tabBarHeight ?? 42,
        child: _buildTabBar(),
      ),
      Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 0),
            child: _buildTableBarView(),
          ),
        ),
      ),
    ]);
  }

  Widget _buildTabBar() => TabBar(
        onTap: (tab) => tab,
        labelStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        labelColor: ThemeData().colorScheme.primary,
        unselectedLabelStyle: const TextStyle(fontSize: 17),
        controller: _tabController,
        indicatorWeight: 3,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
        unselectedLabelColor: Colors.grey,
        indicatorColor: ThemeData().colorScheme.secondary,
        tabs: widget.tabs.map((e) => Tab(text: e)).toList(),
      );

  Widget _buildTableBarView() =>
      TabBarView(controller: _tabController, children: widget.views);
}
