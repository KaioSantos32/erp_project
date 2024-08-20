import 'package:erp/designPatterns/colors.dart';
import 'package:flutter/material.dart';

class MadeAppBar extends StatelessWidget {
  const MadeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: defaultGreen,
    title: const Text("[Screen Title]"),
    );
  }
}
