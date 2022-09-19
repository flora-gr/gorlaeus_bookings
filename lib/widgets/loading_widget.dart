import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}

class ButtonLoadingWidget extends StatelessWidget {
  const ButtonLoadingWidget({
    required this.showLoading,
    super.key,
  });

  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Styles.leftPadding12,
      child: SizedBox(
        height: 20,
        width: 20,
        child: showLoading
            ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 2,
              )
            : null,
      ),
    );
  }
}
