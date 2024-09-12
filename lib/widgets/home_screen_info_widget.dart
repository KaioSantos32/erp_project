import 'package:erp/designPatterns/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WidgetInfo extends StatefulWidget {
  WidgetInfo({
    super.key,
    required this.label,
    required this.total,
  });

  String label;
  String total;

  @override
  State<WidgetInfo> createState() => _WidgetInfoState();
}

class _WidgetInfoState extends State<WidgetInfo>{
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(
        right: 8.0,
        left: 8.0,
        bottom: 20.0,
        top: 20.0,
      ),
      child: Container(
        width: 300,
        height: 150,
        decoration: BoxDecoration(
            color: dullGreen, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                  color: Colors.white, fontFamily: "Righteous", fontSize: 36),
            ),
            Text("R\$ ${widget.total}",
                style: const TextStyle(
                    color: Colors.white, fontFamily: "Righteous", fontSize: 32))
          ],
        ),
      ),
    );
  }
}
