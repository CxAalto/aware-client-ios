//
//  AWAREPlugin.m
//  AWARE
//
//  Created by Yuuki Nishiyama on 12/19/15.
//  Copyright © 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import "AWAREPlugin.h"
#import "AWARESensor.h"
#import "AWAREKeys.h"

@implementation AWAREPlugin {
    NSMutableArray* awareSensors;
}

/**
 * Initialization of AWARE Plugin
 */
- (instancetype) initWithPluginName:(NSString *)pluginName awareStudy:(AWAREStudy *) study {
    self = [super initWithAwareStudy:study
                          sensorName:pluginName
                        dbEntityName:nil
                              dbType:AwareDBTypeTextFile];
    if (self) {
        _pluginName = pluginName;
        _deviceId = [study getDeviceId];
        awareSensors = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 * Get a device Id
 */
- (NSString*) getDeviceId {
    return _deviceId;
}

/**
 * Add new AWARE Sensor
 */
- (void) addAnAwareSensor:(AWARESensor *) sensor {
    if (sensor != nil) {
        [awareSensors addObject:sensor];
    }
}
//
//
///**
// * Stop and Remove an AWARE sensor
// */
//- (void) stopAndRemoveAnAwareSensor:(NSString *) sensorName {
//    for ( AWARESensor *sensor in awareSensors ) {
//        if ([sensorName isEqualToString:[sensor getSensorName]]) {
//            [awareSensors removeObject:sensor];
//            
//        }
//    }
//}

- (BOOL) startSensorWithSettings:(NSArray *)settings{
    [self startAllSensorsWithSettings:settings];
    return YES;
}

/**
 * Start All sensors
 */
- (BOOL)startAllSensorsWithSettings:(NSArray *)settings{
    for (AWARESensor* sensor in awareSensors) {
        [sensor startSensorWithSettings:settings];
    }
    return YES;
}

- (void)syncAwareDB {
     for (AWARESensor* sensor in awareSensors) {
         [sensor syncAwareDB];
     }
}

- (BOOL)syncAwareDBInForeground {
    bool result = YES;
    for (AWARESensor* sensor in awareSensors) {
        if(![sensor syncAwareDBInForeground]){
            result = NO;
        }
    }
    return result;
}

/**
 * Stop and remove all sensors
 */
- (BOOL)stopAndRemoveAllSensors {
//    if (timer != nil) {
//        [timer invalidate];
//        timer = nil;
//    }
    for (AWARESensor* sensor in awareSensors) {
        [sensor stopSensor];
    }
    [awareSensors removeAllObjects];
    return NO;
}


- (BOOL) stopSensor{
    [self stopAndRemoveAllSensors];
    return YES;
}

- (bool)isUploading{
    for (AWARESensor * sensor in awareSensors) {
        if( [sensor isUploading] ){
            return YES;
        }
    }
    return NO;
}

@end