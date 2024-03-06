import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsappmarketingapp/controllers/send_message_controller.dart';
import 'package:whatsappmarketingapp/screens/home_page.dart';
import 'package:whatsappmarketingapp/widgets/loader_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SendMessageController sendMessageController =
      Get.put(SendMessageController());

  @override
  void initState() {
    super.initState();
    if (!sendMessageController.contactsLoaded.value &&
        !sendMessageController.contactsChecked.value) {
      checkContactsLocally();
    }
  }

  void fetchAllContacts() async {
    print("fetchAllContacts");
    await sendMessageController.getPermission();
  }

  Future<void> checkContactsLocally() async {
    sendMessageController.isLoading.value = true;
    print("checkContactsLocally");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool contactsExist = prefs.containsKey('contacts');
    if (!contactsExist) {
      print("if fetchAllContacts");
      fetchAllContacts();
    } else {
      print("else loadContactsLocally");
      sendMessageController.loadContactsLocally();
      sendMessageController.contactsLoaded.value = true;
    }
    sendMessageController.contactsChecked.value = true;

    sendMessageController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                  child: sendMessageController.isLoading.value
                      ? const LoaderIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            Get.offAll(() => const HomePage());
                          },
                          child: const Text("Continue"),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
