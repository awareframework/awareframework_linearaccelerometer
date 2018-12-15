import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// The LinerAccelerometer measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = LinearAccelerometerSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  LinearAccelerometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = LinearAccelerometerSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<LinearAccelerometerData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = LinearAccelerometerCard(sensor: sensor);
/// ```
class LinearAccelerometerSensor extends AwareSensor {
  static const MethodChannel _linearAccelerometerMethod = const MethodChannel('awareframework_linearaccelerometer/method');
  // static const EventChannel  _linearAccelerometerStream  = const EventChannel('awareframework_linearaccelerometer/event');

  static const EventChannel _onDataChangedStream  = const EventChannel('awareframework_linearaccelerometer/event_on_data_changed');

  static StreamController<LinearAccelerometerData> onDataChangedStreamController = StreamController<LinearAccelerometerData>();

  LinearAccelerometerData data = LinearAccelerometerData();

  /// Init LinerAccelerometer Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = AccelerometerSensor.init(null);
  /// ```
  LinearAccelerometerSensor():this.init(null);

  /// Init LinerAccelerometer Sensor with AccelerometerSensorConfig
  ///
  /// ```dart
  /// var config =  AccelerometerSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = AccelerometerSensor.init(config);
  /// ```
  LinearAccelerometerSensor.init(LinearAccelerometerSensorConfig config) : super(config){
    super.setMethodChannel(_linearAccelerometerMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<LinearAccelerometerData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  /// [Creating Streams](https://www.dartlang.org/articles/libraries/creating-streams)
  Stream<LinearAccelerometerData> get onDataChanged {
    onDataChangedStreamController.close();
    onDataChangedStreamController = StreamController<LinearAccelerometerData>();
    return onDataChangedStreamController.stream;
  }

  @override
  Future<Null> start() {
    super.getBroadcastStream(_onDataChangedStream, "on_data_changed").map(
            (dynamic event) => LinearAccelerometerData.from(Map<String,dynamic>.from(event))
    ).listen((event){
      this.data = event;
      if(!onDataChangedStreamController.isClosed){
        onDataChangedStreamController.add(event);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
  }
}


/// A configuration class of LinearAccelerometerSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  LinearAccelerometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
class LinearAccelerometerSensorConfig extends AwareSensorConfig{
  int frequency    = 5;
  double period    = 1.0;
  double threshold = 0.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period']    = period;
    map['threshold'] = threshold;
    return map;
  }
}

/// A data model of LinearAccelerometerSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class LinearAccelerometerData extends AwareData {
  Map<String,dynamic> source;
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  int eventTimestamp = 0;
  LinearAccelerometerData():this.from(null);
  LinearAccelerometerData.from(Map<String,dynamic> data):super.from(data){
    if (data != null) {
      x = data["x"];
      y = data["y"];
      z = data["z"];
      eventTimestamp = data["eventTimestamp"];
      source = data;
    }
  }

  @override
  String toString() {
    if(source != null){
      return source.toString();
    }
    return super.toString();
  }
}



///
/// A Card Widget of LinerAccelerometer Sensor
///
/// You can generate a Cart Widget by following code.
/// ```dart
/// var card = LinearAccelerometerCard(sensor: sensor);
/// ```
class LinearAccelerometerCard extends StatefulWidget {
  LinearAccelerometerCard({Key key,
                          @required this.sensor,
                          this.height = 200.0,
                          this.bufferSize = 299}) : super(key: key);

  final LinearAccelerometerSensor sensor;
  final double height;
  final int bufferSize;
  final List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine3 = List<LineSeriesData>();

  @override
  LinearAccelerometerCardState createState() => new LinearAccelerometerCardState();
}

///
/// A Card State of LinerAccelerometer Sensor
///
class LinearAccelerometerCardState extends State<LinearAccelerometerCard> {


  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      if(event!=null){
        if(mounted){
          setState((){
            updateContent(event);
          });
        }else{
          updateContent(event);
        }
      }

    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  void updateContent(LinearAccelerometerData data){
    DateTime.fromMicrosecondsSinceEpoch(data.timestamp);
    StreamLineSeriesChart.add(data:data.x, into:widget.dataLine1, id:"x", buffer: widget.bufferSize);
    StreamLineSeriesChart.add(data:data.y, into:widget.dataLine2, id:"y", buffer: widget.bufferSize);
    StreamLineSeriesChart.add(data:data.z, into:widget.dataLine3, id:"z", buffer: widget.bufferSize);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          height:widget.height,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(widget.dataLine1, widget.dataLine2, widget.dataLine3)),
        ),
      title: "Linear Accelerometer",
      sensor: widget.sensor
    );
  }
}
