import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/send_message.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: SendMessageScreen(),
    );
  }
}
