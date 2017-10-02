//
//  DevicesService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 01/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
#import "LocalDatabaseService.h"

@interface DevicesService : NSObject

+ (id)shared;

- (NSArray*)getDevices;

@end
