import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsappmarketingapp/controllers/send_message_controller.dart';

class SendMessageScreen extends StatefulWidget {
  const SendMessageScreen({Key? key}) : super(key: key);

  @override
  State<SendMessageScreen> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final SendMessageController sendMessageController =
      Get.put(SendMessageController());

  @override
  void initState() {
    super.initState();

    sendMessageController.getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send WhatsApp Message'),
      ),
      body: Obx(() {
        return sendMessageController.isLoading.value
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ListTile(
                      title: Text('Title'),
                      subtitle: Text('Subitile'),
                      leading: Icon(Icons.person),
                      trailing: Icon(Icons.arrow_right_sharp),
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
