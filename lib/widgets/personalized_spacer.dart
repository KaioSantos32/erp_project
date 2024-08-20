import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PersonalizedSpacer extends StatelessWidget {

  double amountSpaceHorizontal;
  double? amountSpaceVertical;

  PersonalizedSpacer({
    super.key, 
    required this.amountSpaceHorizontal,
    this.amountSpaceVertical,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: amountSpaceHorizontal,
      height: amountSpaceVertical ?? amountSpaceHorizontal,
    );
  }
}
