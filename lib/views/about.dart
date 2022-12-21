import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../utils/app_color.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: AppColors.maincolor,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              "We Can’t Help Everyone",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 200),
                    const Offset(250, 20),
                    <Color>[
                      const Color(0xff1f005c),
                      const Color(0xffffb56b),
                    ],
                  ),
              ),
            ),
            Text(
              "but Everyone Can Help Someone",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 50),
                    const Offset(250, 20),
                    <Color>[
                      const Color(0xff1f005c),
                      const Color(0xffffb56b),
                    ],
                  ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Turn your compassion into action and volunteer",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                foreground: Paint()
                  ..shader = ui.Gradient.linear(
                    const Offset(0, 50),
                    const Offset(250, 20),
                    <Color>[
                      const Color(0xffac255e),
                      const Color(0xffffb56b),
                    ],
                  ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/logo/USM+APEX-h.png",
              height: 90,
              width: 350,
            ),
            const Text(
              "Developed by: ",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                // main -> vertical
                // cross -> horizontal
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Chong"),
                      Text("Yi Yin"),
                      Text("--------"),
                      Text("152684"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Chuah"),
                      Text("Tiong Guan"),
                      Text("--------"),
                      Text("152686"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Derek Gan"),
                      Text("Kaa Kheng"),
                      Text("--------"),
                      Text("154738"),
                    ],
                  ),
                  Column(
                    children: const [
                      Text("Koh"),
                      Text("Yung Kwang"),
                      Text("--------"),
                      Text("153396"),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              "assets/logo/Logo.png",
              height: 300,
              width: 300,
            ),
          ],
        ),
      ),
    );
  }
}
