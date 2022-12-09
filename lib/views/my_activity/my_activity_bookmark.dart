import 'package:flutter/material.dart';

import '../../widgets/events_feed_widget.dart';

class MyActivityBookmark extends StatefulWidget {
  const MyActivityBookmark({super.key});

  @override
  State<MyActivityBookmark> createState() => _MyActivityBookmarkState();
}

class _MyActivityBookmarkState extends State<MyActivityBookmark> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventsISaves(),
    );
  }
}
