//
//  AWAREMqtt.h
//  AWARE
//
//  Created by Yuuki Nishiyama on 12/10/15.
//  Copyright © 2015 Yuuki NISHIYAMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWAREMqtt : NSObject

@property (nonatomic,strong) NSString * mqttServer;// = @"";
@property (nonatomic,strong) NSString * oldStudyId;// = @"";
@property (nonatomic,strong) NSString * mqttPassword;// = @"";
@property (nonatomic,strong) NSString * mqttUserName;// = @"";
@property (nonatomic,strong) NSString * studyId;// = @"";
@property (nonatomic,strong) NSNumber * mqttPort;// = @1883;
@property (nonatomic,strong) NSNumber * mqttKeepAlive;// = @600;
@property (nonatomic,strong) NSNumber * mqttQos;// = @2;


@end
