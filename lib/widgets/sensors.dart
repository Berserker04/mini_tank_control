import 'package:flutter/material.dart';

class Sensors extends StatefulWidget {
  const Sensors({super.key});

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
        children: const [
          Text('sensor ${'1'}',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Text('sensor ${'2'}',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Text('sensor ${'3'}',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}
