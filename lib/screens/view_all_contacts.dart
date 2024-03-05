import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsappmarketingapp/controllers/send_message_controller.dart';
import 'package:whatsappmarketingapp/widgets/loader_indicator.dart';

class ViewAllContacts extends StatefulWidget {
  const ViewAllContacts({super.key});

  @override
  State<ViewAllContacts> createState() => _ViewAllContactsState();
}

class _ViewAllContactsState extends State<ViewAllContacts> {
  final SendMessageController sendMessageController = Get.find();
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   allContacts();
    // });
    super.initState();
  }

  void allContacts() async {
    await sendMessageController.fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("All Contacts"),
          // actions: [
          //   IconButton(
          //     icon: Text(sendMessageController.isAllSelected.value
          //         ? "Deselect All"
          //         : "Select All"),
          //     onPressed: () {
          //       if (sendMessageController.isAllSelected.value) {
          //         sendMessageController.selectedContacts.clear();
          //       } else {
          //         sendMessageController.selectedContacts.clear();
          //         for (var contact in sendMessageController.allContacts) {
          //           contact.phones?.forEach((phone) {
          //             sendMessageController.selectedContacts
          //                 .add(phone.value ?? '');
          //           });
          //         }
          //       }

          //       sendMessageController.isAllSelected.value =
          //           !sendMessageController.isAllSelected.value;
          //       sendMessageController.isLoading.value = true;
          //       sendMessageController.isLoading.value = false;
          //     },
          //   ),
          // ],
        ),
        body: sendMessageController.isLoading.value
            ? Center(child: const LoaderIndicator())
            : Scrollbar(
                thickness: 20,
                child: ListView.builder(
                  itemCount:
                      (sendMessageController.allContacts.length / 200).ceil(),
                  itemBuilder: (context, groupIndex) {
                    List<Contact> contacts = sendMessageController.allContacts
                        .sublist(
                            groupIndex * 200,
                            (groupIndex * 200 + 200).clamp(
                                0, sendMessageController.allContacts.length));

                    bool isSelected =
                        sendMessageController.selectedGroupIndex == groupIndex;

                    return ExpansionTile(
                      title: Text("Group ${groupIndex + 1}"),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? newValue) {
                          if (newValue != null && newValue) {
                            sendMessageController.selectedGroupIndex.value =
                                groupIndex;
                            sendMessageController.selectedContacts.clear();
                            sendMessageController.selectedContacts
                                .addAll(contacts.map(
                              (contact) {
                                if (contact.phones != null &&
                                    contact.phones!.isNotEmpty) {
                                  return contact.phones!.first.value ?? "";
                                } else {
                                  return "";
                                }
                              },
                            ));

                            sendMessageController.isLoading.value = true;
                            sendMessageController.isLoading.value = false;
                          }
                        },
                      ),
                      children: contacts.map((contact) {
                        return ListTile(
                          title: Text(contact.displayName ?? ""),
                          subtitle: contact.phones != null &&
                                  contact.phones!.isNotEmpty
                              ? Text(contact.phones!.first.value ?? "")
                              : const SizedBox(),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
      );
    });
  }
}
