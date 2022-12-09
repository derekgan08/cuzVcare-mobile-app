import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import 'my_activity_bookmark.dart';
import 'my_activity_joined.dart';

class MyActivity extends StatelessWidget {
  const MyActivity({super.key});

  TabBar get _tabBar => const TabBar(
        indicatorWeight: 5,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.blueGrey,
        labelColor: Colors.blueGrey,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: 'Joined'),
          Tab(text: 'Bookmark'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('My Activity'),
          backgroundColor: AppColors.maincolor,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            MyActivityJoined(),
            MyActivityBookmark(),
          ],
        ),
      ),
    );
  }
}
