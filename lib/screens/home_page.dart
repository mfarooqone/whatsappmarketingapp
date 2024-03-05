import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsappmarketingapp/controllers/send_message_controller.dart';
import 'package:whatsappmarketingapp/widgets/loader_indicator.dart';

import 'view_all_contacts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SendMessageController sendMessageController =
      Get.put(SendMessageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desire Sol'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() {
        return sendMessageController.isLoading.value
            ? const Center(
                child: LoaderIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        Get.to(() => const ViewAllContacts());
                      },
                      title: Text(
                        sendMessageController.selectedContacts.isNotEmpty
                            ? "Selected Contacts: ${sendMessageController.selectedContacts.length}"
                            : 'Select Contacts',
                      ),
                      tileColor: Colors.grey[100],
                      leading: const Icon(Icons.person),
                      trailing: const Icon(Icons.arrow_right_sharp),
                    ),
                    const SizedBox(height: 20),
                    Text("sendingTo == ${sendMessageController.sendingTo}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (sendMessageController.stopLoop.value == false) {
                          sendMessageController.startLoop();
                        } else {
                          sendMessageController.stopTheLoop();
                        }
                      },
                      child: Text(
                        sendMessageController.stopLoop.value
                            ? 'Stop'
                            : 'Send Message',
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
