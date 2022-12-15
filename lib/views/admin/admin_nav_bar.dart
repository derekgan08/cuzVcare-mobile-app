import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/data_controller.dart';
import '../../utils/app_color.dart';
import '../auth/logout.dart';
import '../reward/create_reward.dart';
import 'admin_view_reward.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
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
    return Material(
        color: AppColors.admincolor,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
              top: 25 + MediaQuery.of(context).padding.top,
              bottom: 25,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                  radius: 50,
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildMenu(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.playlist_add_outlined),
          title: const Text('Create Reward'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreateReward(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.card_giftcard_outlined),
          title: const Text('View Reward'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AdminViewReward(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text('Log out'),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LogoutView(),
              ),
            );
          },
        ),
      ],
    );
  }
}
