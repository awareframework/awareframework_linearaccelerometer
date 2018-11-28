import Flutter
import UIKit
import com_awareframework_ios_sensor_linearaccelerometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkLinearaccelerometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, LinearAccelerometerObserver{

    var linearAccelerometerSensor:LinearAccelerometerSensor?
    
    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.linearAccelerometerSensor = LinearAccelerometerSensor.init(LinearAccelerometerSensor.Config(config))
            }else{
                self.linearAccelerometerSensor = LinearAccelerometerSensor.init(LinearAccelerometerSensor.Config())
            }
            self.linearAccelerometerSensor?.CONFIG.sensorObserver = self
            return self.linearAccelerometerSensor
        }else{
            return nil
        }
    }

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftAwareframeworkLinearaccelerometerPlugin()

        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_linearaccelerometer/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames: ["awareframework_linearaccelerometer/event"])
        
    }

    public func onDataChanged(data: LinearAccelerometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
