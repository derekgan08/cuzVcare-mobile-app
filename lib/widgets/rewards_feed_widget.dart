import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/data_controller.dart';
import '../utils/app_color.dart';
import 'my_widgets.dart';

Widget RewardsFeed() {
  DataController dataController = Get.find<DataController>();

  // if loading, show progress indicator
  return Obx(() => dataController.isRewardsLoading.value
      ? Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          // Make it scrollable when list increasing
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            return RewardItem(dataController.allRewards[i]);
          },
          itemCount: dataController.allRewards.length,
        ));
}

Widget buildCard({String? image, text, DocumentSnapshot? rewardData}) {
  String startdate = rewardData!.get('start_date');

  String enddate = rewardData.get('end_date');

  String tnc = rewardData.get('description');

  int point = rewardData.get('point');

  List redeemed = [];

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 150,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image!),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$startdate until $enddate',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color(0xffADD8E6),
                      ),
                    ),
                    child: Text(
                      '$point points required',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      elevatedButton(
                        text: 'Redeem',
                        onpress: () {
                          if (!redeemed.contains(
                              FirebaseAuth.instance.currentUser!.uid)) {
                            FirebaseFirestore.instance
                                .collection('rewards')
                                .doc(rewardData.id)
                                .set({
                              'redeemed': FieldValue.arrayUnion(
                                  [FirebaseAuth.instance.currentUser!.uid]),
                              'numRedeem': FieldValue.increment(-1),
                            }, SetOptions(merge: true)).then(
                              (value) {
                                FirebaseFirestore.instance
                                    .collection('redemption')
                                    .doc(rewardData.id)
                                    .set({
                                  'redemption': FieldValue.arrayUnion([
                                    {
                                      'uid': FirebaseAuth
                                          .instance.currentUser!.uid,
                                      'tickets': 1
                                    }
                                  ])
                                });
                              },
                            );
                            Get.snackbar('Reward is redeemed successfully',
                                "View your redeemed rewards in the Redeemed tab.",
                                colorText: Colors.white,
                                backgroundColor: Colors.blue);
                          } else {
                            Get.snackbar('Sorry', "The reward was redeemed.",
                                colorText: Colors.white,
                                backgroundColor: Colors.blue);
                          }
                        },
                      ),
                      Builder(builder: (context) {
                        return TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Terms and Conditions'),
                              content: Text(tnc),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                          child: const Text('T&C'),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const Divider(
        color: Colors.grey,
      ),
    ],
  );
}

RewardItem(DocumentSnapshot reward) {
  String rewardImage = '';
  try {
    List media = reward.get('media') as List;
    Map mediaItem =
        media.firstWhere((element) => element['isImage'] == true) as Map;
    rewardImage = mediaItem['url'];
  } catch (e) {
    rewardImage = '';
  }

  return Column(
    children: [
      buildCard(
        image: rewardImage,
        text: reward.get('reward_name'),
        rewardData: reward,
      ),
      const SizedBox(
        height: 15,
      ),
    ],
  );
}

ViewRewardRedeemed() {
  DataController dataController = Get.find<DataController>();

  DocumentSnapshot myUser = dataController.allUsers
      .firstWhere((e) => e.id == FirebaseAuth.instance.currentUser!.uid);

  String userImage = '';
  String userName = '';

  try {
    userImage = myUser.get('image');
  } catch (e) {
    userImage = '';
  }

  try {
    userName = '${myUser.get('first')} ${myUser.get('last')}';
  } catch (e) {
    userName = '';
  }

  return Column(
    children: [
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Divider(
              color: Color(0xff918F8F).withOpacity(0.2),
            ),
            Obx(
              () => dataController.isRewardsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: dataController.redempRewards.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        String name =
                            dataController.redempRewards[i].get('reward_name');

                        int point =
                            dataController.redempRewards[i].get('point');

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Color(0xffADD8E6),
                                      ),
                                    ),
                                    child: Text(
                                      '$point points',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.06,
                                  ),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}
