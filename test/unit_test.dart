import 'package:test/test.dart';
import 'package:awareframework_linearaccelerometer/awareframework_linearaccelerometer.dart';

void main(){
  test("test sensor config", (){
    var config = LinearAccelerometerSensorConfig();
    expect(config.debug, false);
  });
}
