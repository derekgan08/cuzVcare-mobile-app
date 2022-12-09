import 'package:flutter/material.dart';

import '../../widgets/events_feed_widget.dart';

class MyActivityJoined extends StatefulWidget {
  const MyActivityJoined({super.key});

  @override
  State<MyActivityJoined> createState() => _MyActivityJoinedState();
}

class _MyActivityJoinedState extends State<MyActivityJoined> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventsIJoined(),
    );
  }
}
