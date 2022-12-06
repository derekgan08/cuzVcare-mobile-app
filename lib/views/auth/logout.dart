import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_color.dart';
import '../../widgets/my_widgets.dart';
import 'login_signup.dart';

class LogoutView extends StatefulWidget {
  const LogoutView({super.key});

  @override
  State<LogoutView> createState() => _LogoutViewState();
}

class _LogoutViewState extends State<LogoutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log out'),
        backgroundColor: AppColors.maincolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Are you sure you want to log out?\n"),
            Container(
              height: 40,
              width: 200,
              child: elevatedButton(
                onpress: () {
                  logout(context);
                },
                text: 'Log out',
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut().then((value) => Get.snackbar(
        'Successful log out.', "Redirecting to login page...",
        colorText: Colors.white, backgroundColor: Colors.blue));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginView(),
      ),
    );
  }
}
