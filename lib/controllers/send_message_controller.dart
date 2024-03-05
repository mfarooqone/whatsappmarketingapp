import 'dart:convert';
import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SendMessageController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAllSelected = false.obs;
  List<String> selectedContacts = [];

  ///
  List<String> allPhoneNumbers = [
    "923036991118",
    "923106778026",
  ];
  // List<String> allPhoneNumbers = [];

  List<Contact> allContacts = [];

  @override
  void onInit() {
    super.onInit();
    getPermission();
  }

  String sendingTo = "";
  RxBool stopLoop = false.obs;

  Future<void> getPermission() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      fetchContacts();
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> startLoop() async {
    // Set<String> uniquePhoneNumbers = <String>{};
    // allPhoneNumbers.clear();
    // uniquePhoneNumbers.clear();

    // for (int i = 0; i < selectedContacts.length; i++) {
    //   if (selectedContacts.isNotEmpty) {
    //     String cleanedPhone = selectedContacts[i];
    //     cleanedPhone = cleanedPhone.replaceAll(' ', '');
    //     if (cleanedPhone.startsWith('+')) {
    //       cleanedPhone = cleanedPhone.substring(1);
    //     }
    //     if (cleanedPhone.startsWith('0')) {
    //       cleanedPhone = '92${cleanedPhone.substring(1)}';
    //     }
    //     if (cleanedPhone.length == 12) {
    //       uniquePhoneNumbers.add(cleanedPhone);
    //     }
    //   }
    // }
    // allPhoneNumbers = uniquePhoneNumbers.toList();
    // print("phonenumbers == $allPhoneNumbers ");

    ///
    ///
    ///
    ///

    log("start loop");
    if (!stopLoop.value) {
      stopLoop.value = true;

      for (int i = 0; i < allPhoneNumbers.length; i++) {
        await Future.delayed(const Duration(seconds: 5));

        if (stopLoop.value) {
          log("message to == ${[allPhoneNumbers[i]]}");
          sendingTo = allPhoneNumbers[i];
          sendMessage(phoneNumber: [allPhoneNumbers[i]]);
          if (i == allPhoneNumbers.length - 1) {
            stopTheLoop();
            log("stop loop because reached the last contact");
            update();
          }
        } else {
          break;
        }
      }
    }
    isLoading.value = false;
  }

  void stopTheLoop() {
    stopLoop.value = false;
    log("stop loop");
    isLoading.value = false;
  }

  Future<void> fetchContacts() async {
    isLoading.value = true;
    allContacts.clear();
    allContacts = await ContactsService.getContacts();
    isLoading.value = false;
  }

  ///
  ///
  ///
  Future<void> sendMessage({required List<String> phoneNumber}) async {
    final url = Uri.parse('http://66.42.49.235/send-message');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'phoneNumbers': phoneNumber,
          'message':
              "Whoever believes in Allah and the Last Day should speak a good word or remain silent. - Sahih Al-Bukhari"
        }),
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending message: $error');
    }
  }
}
