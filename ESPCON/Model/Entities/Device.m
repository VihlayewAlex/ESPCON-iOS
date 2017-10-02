//
//  Device.m
//  ESPCON
//
//  Created by Alex Vihlayew on 01/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize name;

- (instancetype)initWithSSID:(NSString*)SSID password:(NSString*)password name:(NSString*)name deviceID:(NSString*)deviceID userID:(NSString*)userID MACaddress:(NSString*)MACaddress state:(NSString*)state
{
    self = [super init];
    if (self) {
        [self setSSID:SSID];
        [self setPassword:password];
        [self setName:name];
        [self setDeviceID:deviceID];
        [self setUserID:userID];
        [self setMACaddress:MACaddress];
        [self setState:state];
    }
    return self;
}

@end
