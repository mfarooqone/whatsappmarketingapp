import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsappmarketingapp/controllers/send_message_controller.dart';

class ViewAllContacts extends StatefulWidget {
  const ViewAllContacts({super.key});

  @override
  State<ViewAllContacts> createState() => _ViewAllContactsState();
}

class _ViewAllContactsState extends State<ViewAllContacts> {
  final SendMessageController sendMessageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "All Contacts",
          ),
          actions: [
            IconButton(
              icon: Text(sendMessageController.isAllSelected.value
                  ? "Deselect All"
                  : "Select All"),
              onPressed: () {
                if (sendMessageController.isAllSelected.value) {
                  sendMessageController.selectedContacts.clear();
                } else {
                  sendMessageController.selectedContacts.clear();
                  for (var contact in sendMessageController.allContacts) {
                    contact.phones?.forEach((phone) {
                      sendMessageController.selectedContacts
                          .add(phone.value ?? '');
                    });
                  }
                }

                sendMessageController.isAllSelected.value =
                    !sendMessageController.isAllSelected.value;
                sendMessageController.isLoading.value = true;
                sendMessageController.isLoading.value = false;
              },
            ),
          ],
        ),
        body: sendMessageController.isLoading.value
            ? const CircularProgressIndicator()
            : Scrollbar(
                thickness: 20,
                child: ListView.builder(
                  itemCount: sendMessageController.allContacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = sendMessageController.allContacts[index];
                    return ListTile(
                      title: Text(
                        contact.displayName ?? "",
                      ),
                      subtitle:
                          contact.phones != null && contact.phones!.isNotEmpty
                              ? Text(
                                  contact.phones!.first.value ?? "",
                                )
                              : const SizedBox(),
                      trailing: Checkbox(
                        value: sendMessageController.selectedContacts.contains(
                            contact.phones != null && contact.phones!.isNotEmpty
                                ? contact.phones?.first.value
                                : false),
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            final phoneValue = contact.phones != null &&
                                    contact.phones!.isNotEmpty
                                ? contact.phones!.first.value
                                : "";
                            if (newValue) {
                              if (!sendMessageController.selectedContacts
                                  .contains(phoneValue)) {
                                sendMessageController.selectedContacts
                                    .add(phoneValue!);
                              }
                            } else {
                              sendMessageController.selectedContacts
                                  .removeWhere(
                                      (element) => element == phoneValue);
                            }
                          }
                          sendMessageController.isLoading.value = true;
                          sendMessageController.isLoading.value = false;
                        },
                      ),
                    );
                  },
                ),
              ),
      );
    });
  }
}
