import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/data_controller.dart';
import '../utils/app_color.dart';
import '../views/event_page/event_page_view.dart';
import '../views/profile/profile.dart';
import 'my_widgets.dart';

Widget EventsFeed() {
  DataController dataController = Get.find<DataController>();

  // if loading, show progress indicator
  return Obx(() => dataController.isEventsLoading.value
      ? Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          // Make it scrollable when list increasing
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, i) {
            return EventItem(dataController.filteredEvents[i]);
          },
          itemCount: dataController.filteredEvents.length,
        ));
}

Widget buildCard(
    {String? image, text, Function? func, DocumentSnapshot? eventData}) {
  DataController dataController = Get.find<DataController>();

  List joinedUsers = [];

  try {
    joinedUsers = eventData!.get('joined');
  } catch (e) {
    joinedUsers = [];
  }

  List dateInformation = [];
  try {
    dateInformation = eventData!.get('date').toString().split('-');
  } catch (e) {
    dateInformation = [];
  }

  int comments = 0;

  List userLikes = [];

  try {
    userLikes = eventData!.get('likes');
  } catch (e) {
    userLikes = [];
  }

  try {
    comments = eventData!.get('comments').length;
  } catch (e) {
    comments = 0;
  }

  List eventSavedByUsers = [];
  try {
    eventSavedByUsers = eventData!.get('saves');
  } catch (e) {
    eventSavedByUsers = [];
  }

  List tags = [];
  try {
    tags = eventData!.get('tags');
  } catch (e) {
    tags = [];
  }

  String tagsCollectively = '';

  tags.forEach((e) {
    tagsCollectively += '#$e ';
  });

  String location = '';
  try {
    location = eventData!.get('location');
  } catch (e) {
    location = '';
  }

  return Container(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(17),
      boxShadow: [
        BoxShadow(
          color: Color(393939).withOpacity(0.15),
          spreadRadius: 0.1,
          blurRadius: 2,
          offset: Offset(0, 0), // changes position of shadow
        ),
      ],
    ),
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            func!();
          },
          child: Container(
            // child: Image.network(image!,fit: BoxFit.fill,),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(image!), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(10),
            ),

            width: double.infinity,
            height: Get.width * 0.5,
            //color: Colors.red,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 41,
                height: 24,
                // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Color(0xffADD8E6))),
                child: Text(
                  '${dateInformation[0]}-${dateInformation[1]}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                width: 18,
              ),
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  if (eventSavedByUsers
                      .contains(FirebaseAuth.instance.currentUser!.uid)) {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventData!.id)
                        .set({
                      'saves': FieldValue.arrayRemove(
                          [FirebaseAuth.instance.currentUser!.uid])
                    }, SetOptions(merge: true));
                  } else {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(eventData!.id)
                        .set({
                      'saves': FieldValue.arrayUnion(
                          [FirebaseAuth.instance.currentUser!.uid])
                    }, SetOptions(merge: true));
                  }
                },
                child: Container(
                  width: 16,
                  height: 19,
                  child: Image.asset(
                    'assets/boomMark.png',
                    fit: BoxFit.contain,
                    color: eventSavedByUsers
                            .contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.red
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset('assets/location.png'),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: myText(
                text: location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff303030),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
                width: Get.width * 0.6,
                height: 50,
                child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    DocumentSnapshot user = dataController.allUsers
                        .firstWhere((e) => e.id == joinedUsers[index]);

                    String image = '';

                    try {
                      image = user.get('image');
                    } catch (e) {
                      image = '';
                    }

                    return Container(
                      margin: EdgeInsets.only(left: 10),
                      child: CircleAvatar(
                        minRadius: 13,
                        backgroundImage: NetworkImage(image),
                      ),
                    );
                  },
                  itemCount: joinedUsers.length,
                  scrollDirection: Axis.horizontal,
                )),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                tagsCollectively,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Get.height * 0.03,
        ),
        Row(
          children: [
            const SizedBox(
              width: 68,
            ),
            InkWell(
              onTap: () {
                if (userLikes
                    .contains(FirebaseAuth.instance.currentUser!.uid)) {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData!.id)
                      .set({
                    'likes': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                } else {
                  FirebaseFirestore.instance
                      .collection('events')
                      .doc(eventData!.id)
                      .set({
                    'likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  }, SetOptions(merge: true));
                }
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffD24698).withOpacity(0.02),
                    )
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  size: 14,
                  color:
                      userLikes.contains(FirebaseAuth.instance.currentUser!.uid)
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              '${userLikes.length}',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              padding: EdgeInsets.all(0.5),
              width: 17,
              height: 17,
              child: Image.asset(
                'assets/message.png',
                color: AppColors.black,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$comments',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              padding: EdgeInsets.all(0.5),
              width: 16,
              height: 16,
              child: Image.asset(
                'assets/send.png',
                fit: BoxFit.contain,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

EventItem(DocumentSnapshot event) {
  DataController dataController = Get.find<DataController>();

  DocumentSnapshot user =
      dataController.allUsers.firstWhere((e) => event.get('uid') == e.id);

  String image = '';

  // Give empty string if not found
  try {
    image = user.get('image');
  } catch (e) {
    image = '';
  }

  String eventImage = '';
  try {
    List media = event.get('media') as List;
    Map mediaItem =
        media.firstWhere((element) => element['isImage'] == true) as Map;
    eventImage = mediaItem['url'];
  } catch (e) {
    eventImage = '';
  }

  return Column(
    children: [
      Row(
        children: [
          InkWell(
            onTap: () {},
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(image),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            '${user.get('first')} ${user.get('last')}',
            style:
                GoogleFonts.raleway(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ],
      ),
      SizedBox(
        height: Get.height * 0.01,
      ),
      buildCard(
          image: eventImage,
          text: event.get('event_name'),
          eventData: event,
          func: () {
            Get.to(() => EventPageView(event, user));
          }),
      SizedBox(
        height: 15,
      ),
    ],
  );
}

EventsIJoined() {
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
              () => dataController.isEventsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: dataController.joinedEvents.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        String name =
                            dataController.joinedEvents[i].get('event_name');

                        String date =
                            dataController.joinedEvents[i].get('date');

                        date = date.split('-')[0] + '-' + date.split('-')[1];

                        List joinedUsers = [];

                        try {
                          joinedUsers =
                              dataController.joinedEvents[i].get('joined');
                        } catch (e) {
                          joinedUsers = [];
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 41, height: 24,
                                    alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Color(0xffADD8E6),
                                      ),
                                    ),
                                    child: Text(
                                      date,
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
                            Container(
                                width: Get.width * 0.6,
                                height: 50,
                                child: ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    DocumentSnapshot user =
                                        dataController.allUsers.firstWhere(
                                            (e) => e.id == joinedUsers[index]);

                                    String image = '';

                                    try {
                                      image = user.get('image');
                                    } catch (e) {
                                      image = '';
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        minRadius: 13,
                                        backgroundImage: NetworkImage(image),
                                      ),
                                    );
                                  },
                                  itemCount: joinedUsers.length,
                                  scrollDirection: Axis.horizontal,
                                )),
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

EventsISaves() {
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
              () => dataController.isEventsLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: dataController.savesEvents.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        String name =
                            dataController.savesEvents[i].get('event_name');

                        String date = dataController.savesEvents[i].get('date');

                        date = date.split('-')[0] + '-' + date.split('-')[1];

                        List joinedUsers = [];

                        try {
                          joinedUsers =
                              dataController.savesEvents[i].get('joined');
                        } catch (e) {
                          joinedUsers = [];
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 41, height: 24,
                                    alignment: Alignment.center,
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Color(0xffADD8E6),
                                      ),
                                    ),
                                    child: Text(
                                      date,
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
                            Container(
                                width: Get.width * 0.6,
                                height: 50,
                                child: ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    DocumentSnapshot user =
                                        dataController.allUsers.firstWhere(
                                            (e) => e.id == joinedUsers[index]);

                                    String image = '';

                                    try {
                                      image = user.get('image');
                                    } catch (e) {
                                      image = '';
                                    }

                                    return Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: CircleAvatar(
                                        minRadius: 13,
                                        backgroundImage: NetworkImage(image),
                                      ),
                                    );
                                  },
                                  itemCount: joinedUsers.length,
                                  scrollDirection: Axis.horizontal,
                                )),
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
