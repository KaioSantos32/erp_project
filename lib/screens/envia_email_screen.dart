import 'package:flutter/material.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        child: Center(
          child: Text("Envio de email"),
        )
    );
  }
}
