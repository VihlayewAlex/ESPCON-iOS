//
//  LocalDatabaseService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 29/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "UserInfo.h"
#import "UserInfoData+CoreDataClass.h"
#import "UserInfoData+CoreDataProperties.h"
#import "Device.h"
#import "DeviceData+CoreDataClass.h"
#import "DeviceData+CoreDataProperties.h"

@interface LocalDatabaseService : NSObject

+ (id _Nullable )shared;

- (void)saveUserInfo:(UserInfo* _Nullable)userInfo;

- (UserInfo* _Nullable)getUserInfo;

@end
