#import "AwareframeworkLinearaccelerometerPlugin.h"
#import <awareframework_linearaccelerometer/awareframework_linearaccelerometer-Swift.h>

@implementation AwareframeworkLinearaccelerometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkLinearaccelerometerPlugin registerWithRegistrar:registrar];
}
@end
