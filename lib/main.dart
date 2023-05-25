import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mini_tank_control/widgets/html_view.dart';
import 'package:mini_tank_control/widgets/sensors.dart';
import 'package:mini_tank_control/widgets/state_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

const bluetoothDevice = BluetoothDevice(name: 'Seleccionar', address: "xxx");

List<BluetoothDevice> list = <BluetoothDevice>[bluetoothDevice];

const ascii = AsciiDecoder();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: MyHomePage(title: 'Tank Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _movingY = 2;
  double _movingX = 2;
  double _movingSpeed = 250 / 2;
  bool _connectedToNetwork = false;
  String _sensor1 = "0";
  String _sensor2 = "---";
  String _sensor3 = "---";

  // _MyHomePageState() {
  //   checkNetwork();
  // }

  void _movingYHandle(double value) {
    setState(() {
      _movingY = value;
    });

    if (value == 3) {
      _forward();
    } else if (value == 1) {
      _backward();
    } else {
      _stopTankY();
    }
  }

  void _movingXHandle(double value) {
    setState(() {
      _movingX = value;
    });

    if (value == 1) {
      _toTheLeft();
    } else if (value == 3) {
      _toTheRight();
    } else {
      _stopTankX();
    }
  }

  void _movingSpeedHandle(double value) {
    setState(() {
      _movingSpeed = value;
    });
    sendCommand("motorSpeed/$value");
  }

  // _forward
// _backward
// _toTheLeft
// _toTheRight

  SliderThemeData _getThemeSlider() {
    return SliderTheme.of(context).copyWith(
        trackHeight: 40.0,
        trackShape: const RoundedRectSliderTrackShape(),
        activeTrackColor: const Color(0xffBCBCBC),
        inactiveTrackColor: const Color(0xffBCBCBC),
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 25.0,
          pressedElevation: 8.0,
        ),
        thumbColor: const Color(0xff2196F3),
        tickMarkShape: const RoundSliderTickMarkShape(),
        disabledThumbColor: Colors.red,
        activeTickMarkColor: const Color(0xffBCBCBC),
        inactiveTickMarkColor: const Color(0xffBCBCBC));
  }

  Future _getModal() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Conectar con el tanque'),
                ElevatedButton(
                  child: const Text('Conectar'),
                  onPressed: () => print("conectando al tanque ..."),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // NUEEEEEEEEEEEEEEEE CODE
  final _bluetooth = FlutterBluetoothSerial.instance;
  late BluetoothConnection connection;

  List<BluetoothDevice> _devicesList = [];
  bool _connected = false;
  bool _connecting = false;
  bool isDisconnecting = false;
  bool _stateLed = false;
  bool _toggleKeyY = true;
  final bool _stateBlink = false;

  double power = 250;
  double blinkIntensity = 500;

  final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20, backgroundColor: Colors.white));

  void connectRequest(context) async {
    setState(() {
      _connecting = true;
    });
    await FlutterBluetoothSerial.instance.requestEnable();

    try {
      if (await Permission.bluetoothConnect.request().isGranted &&
          await Permission.bluetoothScan.request().isGranted) {}

      _devicesList = await _bluetooth.getBondedDevices();
      BluetoothDevice hc_05 = _devicesList.firstWhere(
          (device) => device.name == "HC-05",
          orElse: () => const BluetoothDevice(address: "0", name: "not found"));

      if (hc_05.address == "0") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡conectar primero al dispositivo HC-05!'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );
      }

      connection = await BluetoothConnection.toAddress(hc_05.address);

      connection.input?.listen((Uint8List data) {
        // print('Data 4 incoming: ${ascii.convert(data)}');

        String newData = ascii.convert(data);

        List<String> toArray = newData.split("/");

        if (toArray.length == 2) {
          String key = toArray[0];
          String value = toArray[1];

          if (key == "sensorFront") {
            if (int.parse(value) <= 30) {
              _movingYHandle(2);
            }
            setState(() {
              _sensor1 = value;
            });
          } else if (key == "sensor2") {
            setState(() {
              _sensor2 = value;
            });
          } else if (key == "sensor3") {
            setState(() {
              _sensor3 = value;
            });
          }
        }

        // connection.output.add(data); // Sending data

        // if (ascii.decode(data).contains('!')) {
        //     connection.finish(); // Closing connection
        //     print('Disconnecting by local host');
        // }
      }).onDone(() {
        print('Disconnected by remote request');
      });

      _connected = true;
      _connecting = false;
      setState(() {});
    } catch (e) {
      _connecting = false;
      setState(() {});
    }
  }

  void disconnectRequest() async {
    try {
      // print('Disconecte');
      connection.close();
      // print('Disconecte to the device');
      _connected = false;
      setState(() {});
    } on PlatformException {
      // print("Error");
    }
  }

  void _forward() {
    _stateLed = true;
    sendCommand("forward/1");
  }

  void _backward() {
    _stateLed = true;
    sendCommand("backward/1");
  }

  void _toTheLeft() {
    _stateLed = true;
    sendCommand("toTheLeft/1");
  }

  void _toTheRight() {
    _stateLed = true;
    sendCommand("toTheRight/1");
  }

  void _stopTankY() {
    _stateLed = true;
    sendCommand("stopTankY/1");
  }

  void _stopTankX() {
    _stateLed = true;
    sendCommand("stopTankX/1");
  }

  void sendCommand(String command) async {
    if (_connected) {
      connection.output.add(Uint8List.fromList("$command\n".codeUnits));
      await connection.output.allSent;
      setState(() {});
    }
  }

  void checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        setState(() {
          _connectedToNetwork = true;
        });
      }
    } on SocketException catch (_) {
      // print('not connected');
      setState(() {
        _connectedToNetwork = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkNetwork();
    return Scaffold(
      appBar: AppBar(
        // actionsIconTheme: IconThemeData(color: Colors.black, size: SizedBox(height: 100,)),
        actions: [
          SizedBox(
            height: 100,
            width: 70,
            child: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: _connected ? Colors.green : Colors.red,
                ),
                child: const Icon(
                  Icons.power_settings_new,
                  size: 35,
                  color: Colors.white,
                  weight: 5,
                ),
              ),
              onPressed: () {
                if (_connected) {
                  disconnectRequest();
                } else {
                  connectRequest(context);
                }
              },
            ),
          )
        ],
        title: Text(_connecting ? 'Conectando...' : widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Sensors(
                          sensor1: _sensor1,
                          sensor2: _sensor2,
                          sensor3: _sensor3,
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Icon(
                                        _toggleKeyY
                                            ? Icons.lock
                                            : Icons.lock_open,
                                        size: 35,
                                        color: _toggleKeyY
                                            ? Colors.green
                                            : Colors.blueGrey,
                                        weight: 5,
                                      ),
                                      onPressed: () => setState(() {
                                        _toggleKeyY = !_toggleKeyY;
                                      }),
                                    ),
                                  )),
                              Expanded(
                                  flex: 8,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: SliderTheme(
                                      data: _getThemeSlider(),
                                      child: Slider(
                                        max: 3,
                                        min: 1,
                                        value: _movingY,
                                        divisions: 2,
                                        onChanged: _movingYHandle,
                                        onChangeEnd: (double n) {
                                          if (!_toggleKeyY) {
                                            _movingYHandle(2);
                                          }
                                        },
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                              child: Text(
                                            '${_movingSpeed.toInt()}\nkh',
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              margin: const EdgeInsets.all(0),
                                              padding: const EdgeInsets.all(0),
                                              // color: Colors.red,
                                              child: RotatedBox(
                                                quarterTurns: 3,
                                                child: Container(
                                                  // color: Colors.green,
                                                  child: Slider(
                                                      max: 250,
                                                      min: 1,
                                                      value: _movingSpeed,
                                                      // divisions: 2,
                                                      onChanged:
                                                          _movingSpeedHandle),
                                                ),
                                              ),
                                            )),
                                        const Expanded(
                                            flex: 1, child: Text("speed")),
                                      ],
                                    ),
                                  ))
                            ],
                          ))
                    ],
                  ),
                )),
            Expanded(
                flex: 5,
                child: _connectedToNetwork
                    ? const HtmlView()
                    : const Center(
                        child: Text("Sin conexión a internet",
                            style: TextStyle(color: Colors.red)),
                      )),
            Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: StatusBar(
                          colorBtl:
                              _connected ? const Color(0xff72D838) : Colors.red,
                          colorNetwork: _connectedToNetwork
                              ? const Color(0xff72D838)
                              : Colors.red,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: SliderTheme(
                            data: _getThemeSlider(),
                            child: Slider(
                                onChangeEnd: (double n) {
                                  _movingXHandle(2);
                                },
                                max: 3,
                                min: 1,
                                value: _movingX,
                                divisions: 2,
                                onChanged: _movingXHandle),
                          ))
                    ],
                  ),
                )),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
