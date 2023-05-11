import 'package:flutter/material.dart';

class Sensors extends StatefulWidget {
  final String sensor1;
  final String sensor2;
  final String sensor3;

  const Sensors(
      {required this.sensor1,
      required this.sensor2,
      required this.sensor3,
      super.key});

  @override
  State<Sensors> createState() => _SensorsState();
}

class _SensorsState extends State<Sensors> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 13, 59, 98),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('sensor: ${widget.sensor1}',
              style: TextStyle(color: Colors.white, fontSize: 12)),
          Text('sensor: ${widget.sensor2}',
              style: TextStyle(color: Colors.white, fontSize: 12)),
          Text('sensor: ${widget.sensor3}',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
