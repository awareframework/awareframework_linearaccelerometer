import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class LinearAccelerometerSensor extends AwareSensorCore {
  static const MethodChannel _linearAccelerometerMethod = const MethodChannel('awareframework_linearaccelerometer/method');
  static const EventChannel  _linearAccelerometerStream  = const EventChannel('awareframework_linearaccelerometer/event');

  /// Init Linearaccelerometer Sensor with LinearaccelerometerSensorConfig
  LinearAccelerometerSensor(LinearaccelerometerSensorConfig config):this.convenience(config);
  LinearAccelerometerSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setMethodChannel(_linearAccelerometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> onDataChanged(String id) {
     return super.getBroadcastStream(_linearAccelerometerStream, "on_data_changed", id).map((dynamic event) => Map<String,dynamic>.from(event));
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
class LinearAccelerometerCard extends StatefulWidget {
  LinearAccelerometerCard({Key key,
                          @required this.sensor,
                          this.cardId = "linear_accelerometer_card",
                          this.height = 250.0,
                          this.bufferSize = 299}) : super(key: key);

  LinearAccelerometerSensor sensor;
  String cardId;
  double height;
  int bufferSize;

  @override
  LinearAccelerometerCardState createState() => new LinearAccelerometerCardState();
}


class LinearAccelerometerCardState extends State<LinearAccelerometerCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged(widget.cardId).listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(data:event['x'], into:dataLine1, id:"x", buffer: widget.bufferSize);
          StreamLineSeriesChart.add(data:event['y'], into:dataLine2, id:"y", buffer: widget.bufferSize);
          StreamLineSeriesChart.add(data:event['z'], into:dataLine3, id:"z", buffer: widget.bufferSize);
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
          height:widget.height,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3)),
        ),
      title: "Linear Accelerometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    widget.sensor.cancelBroadcastStream(widget.cardId);
    super.dispose();
  }

}
