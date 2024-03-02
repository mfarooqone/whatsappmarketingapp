import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class SendMessageController extends GetxController {
  RxBool isLoading = false.obs;
  List<String> allContacts = [
    "923036991118",
    "923106778026",
  ];

  String sendingTo = "";
  RxBool stopLoop = false.obs;

  void getPermission() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      // fetchContacts();
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> startLoop() async {
    log("start loop");
    if (!stopLoop.value) {
      stopLoop.value = true;

      for (int i = 0; i < allContacts.length; i++) {
        await Future.delayed(const Duration(seconds: 5));

        if (stopLoop.value) {
          log("message to == ${[allContacts[i]]}");
          sendingTo = allContacts[i];
          sendMessage(phoneNumber: [allContacts[i]]);
          if (i == allContacts.length - 1) {
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

  // Future<void> fetchContacts() async {
  //   allContacts.clear(); // Clear the list before populating it again
  //   Iterable<Contact> contacts = await ContactsService.getContacts();
  //   for (var contact in contacts) {
  //     for (var phone in contact.phones ?? []) {
  //       // Use the null-aware operator to avoid null checks
  //       if (phone.value != null && phone.value!.isNotEmpty) {
  //         String cleanedPhone = phone.value!;
  //         // Remove spaces
  //         cleanedPhone = cleanedPhone.replaceAll(' ', '');
  //         // Remove leading '+' if present
  //         if (cleanedPhone.startsWith('+')) {
  //           cleanedPhone = cleanedPhone.substring(1); // Remove '+'
  //         }
  //         // Remove leading '0' and prepend '92' if necessary
  //         if (cleanedPhone.startsWith('0')) {
  //           cleanedPhone =
  //               '92${cleanedPhone.substring(1)}'; // Remove '0' and prepend '92'
  //         }
  //         // Check length before adding to list
  //         if (cleanedPhone.length == 12) {
  //           allContacts.add(cleanedPhone);
  //           print('Phone: $cleanedPhone');
  //         }
  //       }
  //     }
  //   }
  // }

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
        // Handle success
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
        // Handle failure
      }
    } catch (error) {
      print('Error sending message: $error');
      // Handle failure
    }
  }
}
