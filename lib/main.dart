import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_tank_control/widgets/html_view.dart';
import 'package:mini_tank_control/widgets/sensors.dart';
import 'package:mini_tank_control/widgets/state_bar.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Tank Control'),
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

  void _movingYHandle(double value) {
    setState(() {
      _movingY = value;
    });
  }

  void _movingXHandle(double value) {
    setState(() {
      _movingX = value;
    });
  }

  SliderThemeData _getThemeSlider() {
    return SliderTheme.of(context).copyWith(
      trackHeight: 50.0,
      trackShape: const RoundedRectSliderTrackShape(),
      activeTrackColor: const Color(0xffBCBCBC),
      inactiveTrackColor: const Color(0xffBCBCBC),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 30.0,
        pressedElevation: 8.0,
      ),
      thumbColor: const Color(0xff2196F3),
      tickMarkShape: const RoundSliderTickMarkShape(),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actionsIconTheme: IconThemeData(color: Colors.black, size: SizedBox(height: 100,)),
        actions: [
          SizedBox(
            height: 100,
            width: 70,
            child: IconButton(
              icon: const Icon(
                Icons.power_settings_new,
                size: 35,
                color: Colors.red,
                weight: 5,
              ),
              onPressed: () {
                print("Conectando a BTL");
              },
            ),
          )
        ],
        title: Text(widget.title),
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
                      const Expanded(
                        flex: 1,
                        child: Sensors(),
                      ),
                      Expanded(
                          flex: 1,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: SliderTheme(
                              data: _getThemeSlider(),
                              child: Slider(
                                  max: 3,
                                  min: 1,
                                  value: _movingY,
                                  divisions: 2,
                                  onChanged: _movingYHandle),
                            ),
                          ))
                    ],
                  ),
                )),
            const Expanded(flex: 5, child: HtmlView()),
            Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: StatusBar(),
                      ),
                      Expanded(
                          flex: 1,
                          child: SliderTheme(
                            data: _getThemeSlider(),
                            child: Slider(
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
