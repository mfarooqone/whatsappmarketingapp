import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:whatsappmarketingapp/screens/send_message.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool splashLoading = true;
  @override
  void initState() {
    updateLoading();
    super.initState();
  }

  void updateLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          splashLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Image.asset(
                    "assets/app_icon.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: splashLoading
                    ? const SizedBox(
                        width: 120,
                        height: 40,
                        child: SpinKitFadingCircle(
                          color: Colors.red,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Get.offAll(() => const SendMessageScreen());
                        },
                        child: const Text("Continue"),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
