//
//  Barometer.m
//  AWARE
//
//  Created by Yuuki Nishiyama on 11/20/15.
//  Copyright © 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import "Barometer.h"

@implementation Barometer{
    NSTimer *uploadTimer;
    CMAltimeter* altitude;
}


- (instancetype)initWithSensorName:(NSString *)sensorName withAwareStudy:(AWAREStudy *)study{
    self = [super initWithSensorName:sensorName withAwareStudy:study];
    if (self) {
    }
    return self;
}


- (void) createTable{
    NSString *query = [[NSString alloc] init];
    query = @"_id integer primary key autoincrement,"
    "timestamp real default 0,"
    "device_id text default '',"
    "double_values_0 real default 0,"
    "accuracy integer default 0,"
    "label text default '',"
    "UNIQUE (timestamp,device_id)";
    [super createTable:query];
}

- (BOOL)startSensor:(double)upInterval withSettings:(NSArray *)settings{
    // Send a table create query
    NSLog(@"[%@] Create Table", [self getSensorName]);
    [self createTable];
    
    
    // Get a sensing frequency
    double frequency = [self getSensorSetting:settings withKey:@"frequency_barometer"];
    if(frequency != -1){
        // NOTE: The frequency value is a microsecond
        frequency = frequency/100000;
    }else{
        // default value = 200000(microseconds) = 0.2(second)
        frequency = 0.2;
    }
    
    
    // Set a buffer size for reducing file access
    [self setBufferSize:100];
    
    
    // Set and start a data uploader with an interval
    uploadTimer = [NSTimer scheduledTimerWithTimeInterval:upInterval
                                                   target:self
                                                 selector:@selector(syncAwareDB)
                                                 userInfo:nil
                                                  repeats:YES];
    
    // Set and start a sensor
    NSLog(@"[%@] Start Barometer Sensor", [self getSensorName]);
    if (![CMAltimeter isRelativeAltitudeAvailable]) {
        NSLog(@"This device doesen't support CMAltimeter.");
    } else {
        altitude = [[CMAltimeter alloc] init];
        [altitude startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMAltitudeData *altitudeData, NSError *error) {
                                               NSNumber *pressure_value = altitudeData.pressure;
                                               double pressure_f = [pressure_value doubleValue];
                                               NSNumber * unixtime = [AWAREUtils getUnixTimestamp:[NSDate new]];
                                               NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                                               [dic setObject:unixtime forKey:@"timestamp"];
                                               [dic setObject:[self getDeviceId] forKey:@"device_id"];
                                               [dic setObject:[NSNumber numberWithDouble:pressure_f*10.0f] forKey:@"double_values_0"];
                                               [dic setObject:@0 forKey:@"accuracy"];
                                               [dic setObject:@"" forKey:@"label"];
                                               [self setLatestValue:[NSString stringWithFormat:@"%f", pressure_f*10.0f]];
                                               [self saveData:dic];
                                           }];
    }

    return YES;
}

- (BOOL)stopSensor{
    [altitude stopRelativeAltitudeUpdates];
    if (uploadTimer != nil) {
        [uploadTimer invalidate];
        uploadTimer = nil;
    }
    return YES;
}


@end
