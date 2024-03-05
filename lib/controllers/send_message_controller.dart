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
  // List<String> allPhoneNumbers = [
  //   "923036991118",
  //   "923106778026",
  //   "923036991118",
  //   "923106778026",
  //   "923036991118",
  //   "923106778026",
  // ];
  List<String> allPhoneNumbers = [];

  List<Contact> allContacts = [];

  @override
  void onInit() {
    super.onInit();
    getPermission();
  }

  String sendingTo = "";
  RxBool stopLoop = false.obs;
  RxInt selectedGroupIndex = 0.obs;

  Future<void> getPermission() async {
    isLoading.value = true;
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      fetchContacts();
    } else if (status.isDenied) {
      status = await Permission.contacts.request();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    isLoading.value = false;
  }

  Future<void> startLoop({required String message}) async {
    Set<String> uniquePhoneNumbers = <String>{};
    allPhoneNumbers.clear();
    uniquePhoneNumbers.clear();

    for (int i = 0; i < selectedContacts.length; i++) {
      if (selectedContacts.isNotEmpty) {
        String cleanedPhone = selectedContacts[i];
        cleanedPhone = cleanedPhone.replaceAll(' ', '');
        if (cleanedPhone.startsWith('+')) {
          cleanedPhone = cleanedPhone.substring(1);
        }
        if (cleanedPhone.startsWith('0')) {
          cleanedPhone = '92${cleanedPhone.substring(1)}';
        }
        if (cleanedPhone.length == 12) {
          uniquePhoneNumbers.add(cleanedPhone);
        }
      }
    }
    allPhoneNumbers = uniquePhoneNumbers.toList();
    print("phonenumbers == $allPhoneNumbers ");

    ///
    ///
    ///
    ///

    log("start loop");
    if (!stopLoop.value) {
      stopLoop.value = true;

      int startIndex = 0;
      int endIndex = allPhoneNumbers.length > 4 ? 4 : allPhoneNumbers.length;

      while (startIndex < allPhoneNumbers.length) {
        for (int i = startIndex; i < endIndex; i++) {
          if (stopLoop.value) {
            log("Number: ${allPhoneNumbers[i]} Message: $message");
            sendMessage(phoneNumber: allPhoneNumbers[i], message: message);
          } else {
            return;
          }
        }
        await Future.delayed(Duration(seconds: 30));
        startIndex = endIndex;
        endIndex = startIndex + 4;
        if (endIndex > allPhoneNumbers.length) {
          endIndex = allPhoneNumbers.length;
        }
      }

      // If all messages sent
      stopTheLoop();
      log("All messages sent");
      update();
    }
    isLoading.value = false;
  }

  void stopTheLoop() {
    stopLoop.value = false;
    log("stop loop");
    isLoading.value = false;
  }

  // for (int i = 0; i < allPhoneNumbers.length; i++) {
  //   sendingTo = allPhoneNumbers[i];
  //   isLoading.value = true;
  //   isLoading.value = false;
  //   await Future.delayed(const Duration(seconds: 15));
  //   if (stopLoop.value) {
  //     ///
  //     log("Number: ${[allPhoneNumbers[i]]} Message: $message");

  //     ///
  //     sendMessage(
  //       phoneNumber: [allPhoneNumbers[i]],
  //       message: message,
  //     );

  //     ///
  //     if (i == allPhoneNumbers.length - 1) {
  //       stopTheLoop();
  //       log("stop loop because reached the last contact");
  //       update();
  //     }
  //   } else {
  //     break;
  //   }
  // }

  Future<void> fetchContacts() async {
    isLoading.value = true;
    print("fetchContacts");
    allContacts.clear();
    print("allContacts before= $allContacts");
    allContacts = await ContactsService.getContacts();
    print("allContacts after= $allContacts");
    isLoading.value = false;
  }

  ///
  ///
  ///
  Future<void> sendMessage({
    required String phoneNumber,
    required String message,
  }) async {
    final url = Uri.parse('http://66.42.49.235/send-message');
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'phoneNumbers': [phoneNumber],
          'message': message,
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
