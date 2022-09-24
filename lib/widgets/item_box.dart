import 'package:flutter/material.dart';
import 'package:gorlaeus_bookings/theme/styles.dart';

class ItemBox extends StatelessWidget {
  const ItemBox({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  build(BuildContext context) {
    return ConstrainedBox(
      constraints: Styles.defaultWidthConstraint,
      child: Container(
        margin: Styles.padding8,
        padding: Styles.padding16,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: Styles.borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: Styles.topPadding16,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
