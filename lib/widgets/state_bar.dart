import 'package:flutter/material.dart';

class StatusBar extends StatefulWidget {
  final Color colorBtl;
  final Color colorNetwork;

  StatusBar({required this.colorBtl, required this.colorNetwork, super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: Colors.red,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          height: 40,
          // color: Color(0xff20201E),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xffffffff),
                Color(0xff0D3B62),
                // Color.fromARGB(255, 3, 16, 30),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          padding: const EdgeInsets.all(3.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  Icons.battery_full,
                  size: 35,
                  color: Color(0xff72D838),
                ),
              ),
              Icon(Icons.bluetooth, size: 35, color: widget.colorBtl),
              Icon(Icons.wifi, size: 35, color: widget.colorNetwork),
            ],
          ),
        ),
      ),
    );
  }
}


// Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: const [
//             Text("B"),
//             Text("B"),
//             Text("W"),
//           ],
//         )