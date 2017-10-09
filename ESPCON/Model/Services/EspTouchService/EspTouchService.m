//
//  CoreBluetoothService.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "CoreBluetoothService.h"

@interface EspTouchService ()

@property (weak, nonatomic) id<EspTouchServiceDelegate> delegate;

@end

@implementation EspTouchService

#pragma mark Initialization

+ (id)shared {
    static EspTouchService* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Start/Stop





@end
