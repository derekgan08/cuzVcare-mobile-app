import 'package:flutter/material.dart';

import '../../widgets/rewards_feed_widget.dart';

class RedeemReward extends StatefulWidget {
  const RedeemReward({super.key});

  @override
  State<RedeemReward> createState() => _RedeemRewardState();
}

class _RedeemRewardState extends State<RedeemReward> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewRewardRedeemed(),
    );
  }
}
