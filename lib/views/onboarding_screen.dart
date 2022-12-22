import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_color.dart';
import 'auth/login_signup.dart';

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SafeArea filling all the unusable space
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          // double.infinity taking full screen
          width: double.infinity,

          child: Column(
            // main -> vertical
            // cross -> horizontal
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            // List of widgets for Column using children
            children: [
              // Add space between widget
              const SizedBox(
                height: 30,
              ),

              const Text(
                "Welcome to cuzVcare!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 5,
              ),

              const Text(
                "Volunteer Recruitment Application",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/logo/Logo.png'),
              ),

              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 50,
                  color: AppColors.maincolor,
                  elevation: 2,
                  onPressed: () {
                    Get.to(() => const LoginView());
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
