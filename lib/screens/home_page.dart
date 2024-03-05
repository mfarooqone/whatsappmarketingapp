import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsappmarketingapp/controllers/send_message_controller.dart';
import 'package:whatsappmarketingapp/widgets/loader_indicator.dart';
import 'package:whatsappmarketingapp/widgets/primary_text_field.dart';
import 'package:whatsappmarketingapp/widgets/show_messages.dart';

import 'view_all_contacts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SendMessageController sendMessageController =
      Get.put(SendMessageController());
  final TextEditingController textController = Get.put(TextEditingController());

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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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

                      ////
                      ///
                      ///
                      PrimaryTextField(
                        controller: textController,
                        label: "Message",
                        hintText: "Write a message here",
                        mandatory: true,
                        maxLines: 6,
                        inputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                      ),

                      ///
                      ///
                      ///
                      if (sendMessageController.stopLoop.value)
                        Text("Sending To: ${sendMessageController.sendingTo}"),

                      ///
                      ///
                      ///
                      const SizedBox(height: 10),

                      ///
                      ///
                      ///

                      ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();

                          if (validate()) {
                            if (sendMessageController.stopLoop.value == false) {
                              sendMessageController.startLoop(
                                  message: textController.text);
                            } else {
                              sendMessageController.stopTheLoop();
                            }
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
                ),
              );
      }),
    );
  }

  ///
  ///
  ///
  bool validate() {
    if (sendMessageController.selectedContacts.isEmpty) {
      showErrorMessage(context, "Please select atleast one contact");
      return false;
    } else if (textController.text.isEmpty) {
      showErrorMessage(context, "Please write a message");

      return false;
    } else {
      return true;
    }
  }
}
