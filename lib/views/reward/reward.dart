import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import 'redeem_reward.dart';
import 'view_reward.dart';

class Reward extends StatefulWidget {
  const Reward({super.key});

  @override
  State<Reward> createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  TabBar get _tabBar => const TabBar(
        indicatorWeight: 5,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.blueGrey,
        labelColor: Colors.blueGrey,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: 'View'),
          Tab(text: 'Redeemed'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text('Rewards'),
          backgroundColor: AppColors.maincolor,
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            ViewReward(),
            RedeemReward(),
          ],
        ),
      ),
    );
  }
}
