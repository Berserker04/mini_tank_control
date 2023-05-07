import 'package:flutter/material.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

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
                Color.fromARGB(255, 3, 16, 30),
                // Color(0xff870160),
                // Color(0xffac255e),
                // Color(0xffca485c),
                // Color(0xffe16b5c),
                // Color(0xfff39060),
                // Color(0xffffb56b),
              ], // Gradient from https://learnui.design/tools/gradient-generator.html
              tileMode: TileMode.mirror,
            ),
          ),
          padding: const EdgeInsets.all(3.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  Icons.battery_full,
                  size: 35,
                  color: Color(0xff72D838),
                ),
              ),
              Icon(Icons.bluetooth, size: 35, color: Color(0xff72D838)),
              Icon(Icons.wifi, size: 35, color: Color(0xff72D838)),
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