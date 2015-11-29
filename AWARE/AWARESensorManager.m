//
//  AWARESensorManager.m
//  AWARE
//
//  Created by Yuuki Nishiyama on 11/19/15.
//  Copyright © 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import "AWARESensorManager.h"
#import "AWAREStudyManager.h"
#import "Accelerometer.h"
#import "Gyroscope.h"
#import "Magnetometer.h"
#import "Battery.h"
#import "Barometer.h"
#import "Locations.h"
#import "Network.h"
#import "Wifi.h"
#import "Processor.h"
#import "Gravity.h"
#import "LinearAccelerometer.h"
#import "Bluetooth.h"
#import "AmbientNoise.h"
#import "ActivityRecognition.h"

@implementation AWARESensorManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        awareSensors = [[NSMutableArray alloc] init];
    }
    return self;
}

-(bool)addNewSensorWithSensorName:(NSString *)key
                         settings:(NSArray*)settings
                          plugins:(NSArray*)plugins
                   uploadInterval:(double) uploadTime{
//    double uploadTime = 10.0f;
    NSLog(@"upload interval is %f.", uploadTime);
    AWARESensor* awareSensor = nil;
    for (int i=0; i<settings.count; i++) {
        NSString *setting = [[settings objectAtIndex:i] objectForKey:@"setting"];
        NSString *settingKey = [NSString stringWithFormat:@"status_%@",key];
        if ([setting isEqualToString:settingKey]) {
            NSString * value = [[settings objectAtIndex:i] objectForKey:@"value"];
            if ([value isEqualToString:@"true"]) {
//                [_sensorManager addNewSensorWithSensorName:key settings:(NSArray*)sensors];
                if ([key isEqualToString:SENSOR_ACCELEROMETER]) {
                    awareSensor= [[Accelerometer alloc] initWithSensorName:SENSOR_ACCELEROMETER];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_BAROMETER]){
                    awareSensor = [[Barometer alloc] initWithSensorName:SENSOR_BAROMETER];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_GYROSCOPE]){
                    awareSensor = [[Gyroscope alloc] initWithSensorName:SENSOR_GYROSCOPE];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_MAGNETOMETER]){
                    awareSensor = [[Magnetometer alloc] initWithSensorName:SENSOR_MAGNETOMETER];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_BATTERY]){
                    awareSensor = [[Battery alloc] initWithSensorName:SENSOR_BATTERY];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_LOCATIONS]){
                    awareSensor = [[Locations alloc] initWithSensorName:SENSOR_LOCATIONS];
                    [awareSensor startSensor:uploadTime withSettings:settings];//0=>auto
                }else if([key isEqualToString:SENSOR_NETWORK]){
                    awareSensor = [[Network alloc] initWithSensorName:SENSOR_NETWORK];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_WIFI]){
                    awareSensor = [[Wifi alloc] initWithSensorName:SENSOR_WIFI];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if ([key isEqualToString:SENSOR_PROCESSOR]){
                    awareSensor = [[Processor alloc] initWithSensorName:SENSOR_PROCESSOR];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if ([key isEqualToString:SENSOR_GRAVITY]){
                    awareSensor = [[Gravity alloc] initWithSensorName:SENSOR_GRAVITY];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_LINEAR_ACCELEROMETER]){
                    awareSensor = [[LinearAccelerometer alloc] initWithSensorName:SENSOR_LINEAR_ACCELEROMETER];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }else if([key isEqualToString:SENSOR_BLUETOOTH]){
                    awareSensor = [[Bluetooth alloc] initWithSensorName:SENSOR_BLUETOOTH];
                    [awareSensor startSensor:uploadTime withSettings:settings];
                }
                
//                if (awareSensor != NULL) {
//                    [self addNewSensor:awareSensor];
////                    return YES;
//                }
            }
        }
    }
    
    // add plugin
//    awareSensor = nil;
    for (int i=0; i<plugins.count; i++) {
        NSDictionary *plugin = [plugins objectAtIndex:i];
        NSLog(@"%@", plugin);
//        NSString *pluginUri = [plugin objectForKey:@"plugin"];
        NSArray *pluginSettings = [plugin objectForKey:@"settings"];
//        NSLog(@"%@",pluginSettings);
        for (NSDictionary* pluginSetting in pluginSettings) {
            NSString *pluginStateKey = [NSString stringWithFormat:@"status_%@",key];
            NSString *pluginStateName = [pluginSetting objectForKey:@"setting"];
            if ([pluginStateKey isEqualToString:pluginStateName]) {
                bool pluginState = [pluginSetting objectForKey:@"value"];
                if (pluginState) {
                    if ([key isEqualToString:SENSOR_PLUGIING_GOOGLE_ACTIVITY_RECOGNITION]) {
//                        NSLog(@"goole");
                        awareSensor = [[ActivityRecognition alloc] initWithSensorName:SENSOR_PLUGIING_GOOGLE_ACTIVITY_RECOGNITION];
                        [awareSensor startSensor:uploadTime withSettings:settings];
                    }else if([key isEqualToString:SENSOR_AMBIENT_NOISE]){
//                        NSLog(@"noize");
                        awareSensor = [[AmbientNoise alloc] initWithSensorName:SENSOR_AMBIENT_NOISE];
                        [awareSensor startSensor:uploadTime withSettings:settings];
                    }
                }
            }
        }
    }
    
    if (awareSensor != NULL) {
        [self addNewSensor:awareSensor];
        return YES;
    }

    return NO;
}


- (void)addNewSensor:(AWARESensor *)sensor{
    [awareSensors addObject:sensor];
}

- (void)stopAllSensors{
    for (AWARESensor* sensor in awareSensors) {
        [sensor stopSensor];
    }
    awareSensors = [[NSMutableArray alloc] init];
}


- (void)stopASensor:(NSString *)sensorName{
    for (AWARESensor* sensor in awareSensors) {
        if ([sensor.getSensorName isEqualToString:sensorName]) {
            [sensor stopSensor];
        }
        [sensor stopSensor];
    }
}

- (NSString*)getLatestSensorData:(NSString *)sensorName{
    for (AWARESensor* sensor in awareSensors) {
//        NSLog(@"%@ <---> %@", sensor.getSensorName, sensorName);
        if ([sensor.getSensorName isEqualToString:sensorName]) {
            NSString *sensorValue = [sensor getLatestValue];
            return sensorValue;
        }
    }
    return @"";
}

@end
