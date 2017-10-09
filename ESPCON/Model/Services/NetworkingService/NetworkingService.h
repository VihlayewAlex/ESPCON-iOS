//
//  NetworkingService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
#import "Device.h"

@interface NetworkingService : NSObject

+ (id _Nullable )shared;

- (void)signUpWithName:(NSString*_Nonnull)name
              password:(NSString*_Nonnull)password
                 email:(NSString*_Nonnull)email
 withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSNumber* _Nullable, NSString* _Nullable, NSString* _Nullable))handler;

- (void)logInWithEmail:(NSString* _Nonnull)email
              password:(NSString* _Nonnull)password
 withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSString* _Nullable, NSString* _Nullable, UserInfo* _Nullable))handler;

- (void)getDevicesForUserWithID:(NSString* _Nonnull)userID
          withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable, NSString * _Nullable status, NSArray * _Nullable))handler;

- (void)addNewDevice:(Device* _Nonnull)device
withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message, NSInteger deviceID))handler;

- (void)deleteDevice:(Device* _Nonnull)device
withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message))handler;

- (void)setDeviceStateON:(BOOL)state
               forDevice:(Device* _Nonnull)device
   withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message))handler;

@end
