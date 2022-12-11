import 'package:catevent/views/my_activity/my_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class CheckOutView extends StatefulWidget {
  DocumentSnapshot? eventDoc;

  CheckOutView(this.eventDoc);

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  int selectedRadio = 0;

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
  }

  String eventImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      List media = widget.eventDoc!.get('media') as List;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Event'),
        backgroundColor: AppColors.maincolor,
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: Color(0xff393939).withOpacity(0.15),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(eventImage),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText(
                                  text: widget.eventDoc!.get('event_name'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          myText(
                            text: widget.eventDoc!.get('date'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 11.67,
                                height: 15,
                                child: Image.asset(
                                  'assets/location.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              myText(
                                text: widget.eventDoc!.get('location'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          myText(
                            text: widget.eventDoc!.get('start_time') +
                                ' - ' +
                                widget.eventDoc!.get('end_time'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Row(
                children: [
                  myText(
                    text: 'Points Given: ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  myText(
                    text: '\$${widget.eventDoc!.get('point')}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  myText(
                    text: 'Total Ticket',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  myText(
                    text: '1',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: elevatedButton(
                  onpress: () {
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(widget.eventDoc!.id)
                        .set({
                      'joined': FieldValue.arrayUnion(
                          [FirebaseAuth.instance.currentUser!.uid]),
                      'max_entries': FieldValue.increment(-1),
                    }, SetOptions(merge: true)).then(
                      (value) {
                        FirebaseFirestore.instance
                            .collection('booking')
                            .doc(widget.eventDoc!.id)
                            .set({
                          'booking': FieldValue.arrayUnion([
                            {
                              'uid': FirebaseAuth.instance.currentUser!.uid,
                              'tickets': 1
                            }
                          ])
                        });
                      },
                    );
                    Get.to(const MyActivity());
                  },
                  text: 'Join Now',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
