import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../controller/data_controller.dart';
import '../../model/event_media_model.dart';
import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';

class CreateReward extends StatefulWidget {
  CreateReward({Key? key}) : super(key: key);

  @override
  State<CreateReward> createState() => _CreateRewardState();
}

class _CreateRewardState extends State<CreateReward> {
  DateTime? date = DateTime.now();

  TextEditingController titleController = TextEditingController();
  TextEditingController pointController = TextEditingController();
  TextEditingController numRedeem = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  var selectedFrequency = -2;

  void resetControllers() {
    titleController.clear();
    pointController.clear();
    numRedeem.clear();
    descriptionController.clear();
    endDateController.clear();
    startDateController.clear();
    setState(() {});
  }

  var isCreatingReward = false.obs;

  _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      startDateController.text = '${date!.day}-${date!.month}-${date!.year}';
    }
    setState(() {});
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date = DateTime(picked.year, picked.month, picked.day, date!.hour,
          date!.minute, date!.second);
      endDateController.text = '${date!.day}-${date!.month}-${date!.year}';
    }
    setState(() {});
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> mediaUrls = [];

  List<EventMediaModel> media = [];

  @override
  void initState() {
    super.initState();
    startDateController.text = '${date!.day}-${date!.month}-${date!.year}';
    endDateController.text = '${date!.day}-${date!.month}-${date!.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Reward'),
        backgroundColor: AppColors.admincolor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  height: Get.width * 0.6,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                      color: AppColors.border.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: DottedBorder(
                    color: AppColors.border,
                    strokeWidth: 1.5,
                    dashPattern: [6, 6],
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height * 0.05,
                          ),
                          Container(
                            width: 76,
                            height: 59,
                            child: Image.asset('assets/uploadIcon.png'),
                          ),
                          myText(
                            text: 'Click and upload image/video',
                            style: TextStyle(
                              color: AppColors.blue,
                              fontSize: 19,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          elevatedButton(
                              onpress: () async {
                                mediaDialog(context);
                              },
                              text: 'Upload')
                        ],
                      ),
                    ),
                  ),
                ),
                media.length == 0
                    ? Container()
                    : SizedBox(
                        height: 20,
                      ),
                media.length == 0
                    ? Container()
                    : Container(
                        width: Get.width,
                        height: Get.width * 0.3,
                        child: ListView.builder(
                            itemBuilder: (ctx, i) {
                              return media[i].isVideo!
                                  ? Container(
                                      width: Get.width * 0.3,
                                      height: Get.width * 0.3,
                                      margin: EdgeInsets.only(
                                          right: 15, bottom: 10, top: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: MemoryImage(
                                                media[i].thumbnail!),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: CircleAvatar(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      media.removeAt(i);
                                                      setState(() {});
                                                    },
                                                    icon: Icon(Icons.close),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.slow_motion_video_rounded,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: Get.width * 0.3,
                                      height: Get.width * 0.3,
                                      margin: EdgeInsets.only(
                                          right: 15, bottom: 10, top: 10),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: FileImage(media[i].image!),
                                            fit: BoxFit.fill),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(5),
                                            child: CircleAvatar(
                                              child: IconButton(
                                                onPressed: () {
                                                  media.removeAt(i);
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.close),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            },
                            itemCount: media.length,
                            scrollDirection: Axis.horizontal),
                      ),
                SizedBox(
                  height: 20,
                ),
                myTextField(
                    bool: false,
                    icon: 'assets/4DotIcon.png',
                    text: 'Reward Name',
                    controller: titleController,
                    validator: (String input) {
                      if (input.isEmpty) {
                        Get.snackbar('Opps', "Reward name is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }

                      if (input.length < 3) {
                        Get.snackbar(
                            'Opps', "Reward name is should be 3+ characters.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                      isReadOnly: true,
                      path: 'assets/Frame1.png',
                      text: 'Start Date',
                      controller: startDateController,
                      validator: (input) {
                        if (date == null) {
                          Get.snackbar('Opps', "Start date is required.",
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                          return '';
                        }
                        return null;
                      },
                      onPress: () {
                        _selectStartDate(context);
                      },
                    ),
                    iconTitleContainer(
                      isReadOnly: true,
                      path: 'assets/Frame1.png',
                      text: 'End Date',
                      controller: endDateController,
                      validator: (input) {
                        if (date == null) {
                          Get.snackbar('Opps', "End date is required.",
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                          return '';
                        }
                        return null;
                      },
                      onPress: () {
                        _selectEndDate(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    myText(
                        text: 'Description/Instruction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 149,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(width: 1, color: AppColors.genderTextColor),
                  ),
                  child: TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    validator: (input) {
                      if (input!.isEmpty) {
                        Get.snackbar('Opps', "Description is required.",
                            colorText: Colors.white,
                            backgroundColor: Colors.blue);
                        return '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(top: 25, left: 15, right: 15),
                      hintStyle: TextStyle(
                        color: AppColors.genderTextColor,
                      ),
                      hintText: 'Write any conditions to redeem...',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    iconTitleContainer(
                        path: 'assets/dollarLogo.png',
                        text: 'points',
                        type: TextInputType.number,
                        height: 40,
                        controller: pointController,
                        onPress: () {},
                        validator: (String input) {
                          if (input.isEmpty) {
                            Get.snackbar('Opps', "Points is required.",
                                colorText: Colors.white,
                                backgroundColor: Colors.blue);
                            return '';
                          }
                        }),
                    iconTitleContainer(
                        path: 'assets/#.png',
                        text: 'Maximum number of times for redemption',
                        controller: numRedeem,
                        type: TextInputType.number,
                        onPress: () {},
                        validator: (String input) {
                          if (input.isEmpty) {
                            Get.snackbar(
                                'Opps', "Number of redeem is required.",
                                colorText: Colors.white,
                                backgroundColor: Colors.blue);
                            return '';
                          }
                          return null;
                        }),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Obx(() => isCreatingReward.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 42,
                        width: double.infinity,
                        child: elevatedButton(
                            onpress: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              if (media.isEmpty) {
                                Get.snackbar('Opps', "Media is required.",
                                    colorText: Colors.white,
                                    backgroundColor: Colors.blue);

                                return;
                              }

                              isCreatingReward(true);

                              DataController dataController = Get.find();

                              if (media.isNotEmpty) {
                                for (int i = 0; i < media.length; i++) {
                                  if (media[i].isVideo!) {
                                    /// if video then first upload video file and then upload thumbnail and
                                    /// store it in the map
                                    String thumbnailUrl = await dataController
                                        .uploadThumbnailToFirebase(
                                            media[i].thumbnail!);

                                    String videoUrl = await dataController
                                        .uploadImageToFirebase(media[i].video!);

                                    mediaUrls.add({
                                      'url': videoUrl,
                                      'thumbnail': thumbnailUrl,
                                      'isImage': false
                                    });
                                  } else {
                                    /// just upload image
                                    String imageUrl = await dataController
                                        .uploadImageToFirebase(media[i].image!);
                                    mediaUrls.add(
                                        {'url': imageUrl, 'isImage': true});
                                  }
                                }
                              }

                              Map<String, dynamic> rewardData = {
                                'reward_name': titleController.text,
                                'start_date': startDateController.text,
                                'end_date': endDateController.text,
                                'numRedeem': int.parse(numRedeem.text),
                                'description': descriptionController.text,
                                'redeemed': [],
                                'point': int.parse(pointController.text),
                                'media': mediaUrls,
                                'uid': FirebaseAuth.instance.currentUser!.uid,
                              };

                              await dataController
                                  .createReward(rewardData)
                                  .then((value) {
                                print("Reward is done");
                                isCreatingReward(false);
                                resetControllers();
                              });
                            },
                            text: 'Create Reward'),
                      )),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getImageDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
      source: source,
    );

    if (image != null) {
      media.add(EventMediaModel(
          image: File(image.path), video: null, isVideo: false));
    }

    setState(() {});
    Navigator.pop(context);
  }

  getVideoDialog(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? video = await _picker.pickVideo(
      source: source,
    );

    if (video != null) {
      // media.add(File(image.path));

      Uint8List? uint8list = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

      media.add(EventMediaModel(
          thumbnail: uint8list!, video: File(video.path), isVideo: true));
    }

    // print(thumbnail.first.path);
    setState(() {});

    Navigator.pop(context);
  }

  void mediaDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select Media Type"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, true);
                    },
                    icon: Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      imageDialog(context, false);
                    },
                    icon: Icon(Icons.slow_motion_video_outlined)),
              ],
            ),
          );
        },
        context: context);
  }

  void imageDialog(BuildContext context, bool image) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Media Source"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.gallery);
                      } else {
                        getVideoDialog(ImageSource.gallery);
                      }
                    },
                    icon: Icon(Icons.image)),
                IconButton(
                    onPressed: () {
                      if (image) {
                        getImageDialog(ImageSource.camera);
                      } else {
                        getVideoDialog(ImageSource.camera);
                      }
                    },
                    icon: Icon(Icons.camera_alt)),
              ],
            ),
          );
        },
        context: context);
  }
}
