import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoaderIndicator extends StatelessWidget {
  const LoaderIndicator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      height: 40,
      child: SpinKitFadingCircle(
        color: Colors.red,
      ),
    );
  }
}
