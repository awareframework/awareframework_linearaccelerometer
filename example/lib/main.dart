import 'package:flutter/material.dart';

import 'package:awareframework_linearaccelerometer/awareframework_linearaccelerometer.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  LinearAccelerometerSensor sensor;
  LinearAccelerometerSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = LinearAccelerometerSensorConfig()
      ..frequency = 100
      ..dbType = DatabaseType.DEFAULT
      ..debug = true;

    sensor = new LinearAccelerometerSensor.init(config);

    sensor.start();

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new LinearAccelerometerCard(sensor: sensor,)
      ),
    );
  }
}
