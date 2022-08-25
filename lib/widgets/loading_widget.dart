import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/resources/styles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      color: Styles.secondaryColorSwatch,
    );
  }
}
