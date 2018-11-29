import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class LinearAccelerometerSensor extends AwareSensorCore {
  static const MethodChannel _linearAccelerometerMethod = const MethodChannel('awareframework_linearaccelerometer/method');
  static const EventChannel  _linearAccelerometerStream  = const EventChannel('awareframework_linearaccelerometer/event');

  /// Init LinearAccelerometer Sensor with LinearAccelerometerSensorConfig
  LinearAccelerometerSensor(LinearAccelerometerSensorConfig config):this.convenience(config);
  LinearAccelerometerSensor.convenience(config) : super(config){
    super.setMethodChannel(_linearAccelerometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.getBroadcastStream(_linearAccelerometerStream, "on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }
}

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

/// Make an AwareWidget
class LinearAccelerometerCard extends StatefulWidget {
  LinearAccelerometerCard({Key key,
                          @required this.sensor,
                          this.height = 250.0,
                          this.bufferSize = 299}) : super(key: key);

  final LinearAccelerometerSensor sensor;
  final double height;
  final int bufferSize;
  var handler;
  final List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine3 = List<LineSeriesData>();

  @override
  LinearAccelerometerCardState createState() => new LinearAccelerometerCardState();
}


class LinearAccelerometerCardState extends State<LinearAccelerometerCard> {


  @override
  void initState() {

    super.initState();
    // set observer
    //if(widget.handler == null){
      widget.handler = widget.sensor.onDataChanged.listen((event) {
        if(mounted){
          setState((){
            if(event!=null){
              DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
              StreamLineSeriesChart.add(data:event['x'], into:widget.dataLine1, id:"x", buffer: widget.bufferSize);
              StreamLineSeriesChart.add(data:event['y'], into:widget.dataLine2, id:"y", buffer: widget.bufferSize);
              StreamLineSeriesChart.add(data:event['z'], into:widget.dataLine3, id:"z", buffer: widget.bufferSize);
            }
          });
        }
      }, onError: (dynamic error) {
        print('Received error: ${error.message}');
      });
      print(widget.sensor);
    //}
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

  @override
  void dispose() {
    // TODO: implement dispose
    // widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
