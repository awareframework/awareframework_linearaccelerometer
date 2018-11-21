import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class LinearaccelerometerSensor extends AwareSensorCore {
  static const MethodChannel _linearaccelerometerMethod = const MethodChannel('awareframework_linearaccelerometer/method');
  static const EventChannel  _linearaccelerometerStream  = const EventChannel('awareframework_linearaccelerometer/event');

  /// Init Linearaccelerometer Sensor with LinearaccelerometerSensorConfig
  LinearaccelerometerSensor(LinearaccelerometerSensorConfig config):this.convenience(config);
  LinearaccelerometerSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_linearaccelerometerMethod, _linearaccelerometerStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class LinearaccelerometerSensorConfig extends AwareSensorConfig{
  LinearaccelerometerSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class LinearaccelerometerCard extends StatefulWidget {
  LinearaccelerometerCard({Key key, @required this.sensor}) : super(key: key);

  LinearaccelerometerSensor sensor;

  @override
  LinearaccelerometerCardState createState() => new LinearaccelerometerCardState();
}


class LinearaccelerometerCardState extends State<LinearaccelerometerCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();
  int bufferSize = 299;

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(data:event['x'], into:dataLine1, id:"x", buffer: bufferSize);
          StreamLineSeriesChart.add(data:event['y'], into:dataLine2, id:"y", buffer: bufferSize);
          StreamLineSeriesChart.add(data:event['z'], into:dataLine3, id:"z", buffer: bufferSize);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          height:250.0,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3)),
        ),
      title: "Linearaccelerometer",
      sensor: widget.sensor
    );
  }

}
