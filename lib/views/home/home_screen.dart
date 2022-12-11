import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/data_controller.dart';
import '../../services/notification_service.dart';
import '../../utils/app_color.dart';
import '../../widgets/events_feed_widget.dart';
import '../nav_bar/nav_drawer.dart';
import '../notification_screen/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(DataController(), permanent: true);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    LocalNotificationService.storeToken();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    DataController dataController = Get.find<DataController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('cuzVcare - Home'),
        backgroundColor: AppColors.maincolor,
        actions: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(32.0),
              ),
              // GPS Function:
              onTap: () async {
                bool servicestatus =
                    await Geolocator.isLocationServiceEnabled();
                if (servicestatus) {
                  print("GPS service is enabled");
                  // https://www.fluttercampus.com/guide/212/get-gps-location/#how-to-check-location-permission-or-request-location-permission
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      print('Location permissions are denied');
                    } else if (permission == LocationPermission.deniedForever) {
                      print("Location permissions are permanently denied");
                    } else {
                      print("GPS Location service is granted");
                    }
                  } else {
                    print("GPS Location permission granted.");
                    Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.best)
                        .timeout(Duration(seconds: 5));
                    print(position.latitude);
                    print(position.longitude);

                    try {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        position.latitude,
                        position.longitude,
                      );
                      print(placemarks[0]);
                      Placemark placemark = placemarks[0];
                      String? subAdministrativeArea =
                          placemark.subAdministrativeArea;
                      String? country = placemark.country;
                      String? administrativeArea = placemark.administrativeArea;
                      print(subAdministrativeArea);
                      print(country);
                      print(administrativeArea);

                      if (subAdministrativeArea == "" &&
                          country == "" &&
                          administrativeArea == "") {
                        dataController.filteredEvents
                            .assignAll(dataController.allEvents);
                      } else {
                        List<DocumentSnapshot> data =
                            dataController.allEvents.value.where((element) {
                          List tags = [];

                          bool isTagContain = false;

                          try {
                            tags = element.get('tags');
                            for (int i = 0; i < tags.length; i++) {
                              tags[i] = tags[i].toString().toLowerCase();
                              if (tags[i].toString().contains(
                                  searchController.text.toLowerCase())) {
                                isTagContain = true;
                              }
                            }
                          } catch (e) {
                            tags = [];
                          }

                          return (element
                                  .get('location')
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      subAdministrativeArea!.toLowerCase()) ||
                              element
                                  .get('location')
                                  .toString()
                                  .toLowerCase()
                                  .contains(country!.toLowerCase()) ||
                              element
                                  .get('location')
                                  .toString()
                                  .toLowerCase()
                                  .contains(administrativeArea!.toLowerCase()));
                        }).toList();
                        dataController.filteredEvents.assignAll(data);
                      }
                    } catch (err) {}
                    // Position position =
                    //     await Geolocator.getCurrentPosition(
                    //         desiredAccuracy: LocationAccuracy.high);
                    // print(position.longitude); //Output: 80.24599079
                    // print(position.latitude); //Output: 29.6593457
                    // String long = position.longitude.toString();
                    // String lat = position.latitude.toString();
                  }
                } else {
                  print("GPS service is disabled.");
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.locationDot),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Get.to(() => UserNotificationScreen());
            },
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Text(
                  "What's Going on Right Now",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Search Box Function
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (String input) {
                      if (input.isEmpty) {
                        dataController.filteredEvents
                            .assignAll(dataController.allEvents);
                      } else {
                        List<DocumentSnapshot> data =
                            dataController.allEvents.value.where((element) {
                          List tags = [];

                          bool isTagContain = false;

                          try {
                            tags = element.get('tags');
                            for (int i = 0; i < tags.length; i++) {
                              tags[i] = tags[i].toString().toLowerCase();
                              if (tags[i].toString().contains(
                                  searchController.text.toLowerCase())) {
                                isTagContain = true;
                              }
                            }
                          } catch (e) {
                            tags = [];
                          }

                          return (element
                                  .get('location')
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()) ||
                              // element
                              //     .get('location')
                              //     .toString()
                              //     .toLowerCase()
                              //     .contains(
                              //         subAdministrativeArea!.toLowerCase()) ||
                              // element
                              //     .get('location')
                              //     .toString()
                              //     .toLowerCase()
                              //     .contains(country!.toLowerCase()) ||
                              // element
                              //     .get('location')
                              //     .toString()
                              //     .toLowerCase()
                              //     .contains(administrativeArea!.toLowerCase()) ||
                              isTagContain ||
                              element
                                  .get('event_name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchController.text.toLowerCase()));
                        }).toList();
                        dataController.filteredEvents.assignAll(data);
                      }
                    },
                    // UI: Search Box
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Container(
                        width: 15,
                        height: 15,
                        padding: const EdgeInsets.all(15),
                        child: Image.asset(
                          'assets/search.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      hintText: "Search",
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          dataController.filteredEvents
                              .assignAll(dataController.allEvents);
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        icon: Icon(Icons.clear),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // height: 10,
                  height: Get.height * 0.02,
                ),
                EventsFeed(),
                Obx(
                  () => dataController.isUsersLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/doneCircle.png',
                                fit: BoxFit.cover,
                                color: AppColors.blue,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Text(
                              'You\'re all caught up!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
