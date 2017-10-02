//
//  DevicesService.m
//  ESPCON
//
//  Created by Alex Vihlayew on 01/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "DevicesService.h"

@implementation DevicesService

#pragma mark Initialization

+ (id)shared {
    static DevicesService* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSArray*)getDevices {
    return [[LocalDatabaseService shared] getDevices];
}

- (void)addDevice:(Device* _Nonnull)device {
    [[LocalDatabaseService shared] addDevice:device];
}

@end
