//
//  NetworkingService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingService : NSObject

+ (id _Nullable )shared;

- (void)signUpWithName:(NSString*_Nonnull)name
              password:(NSString*_Nonnull)password
                 email:(NSString*_Nonnull)email
 withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSNumber* _Nullable, NSString* _Nullable, NSString* _Nullable))handler;

- (void)logInWithEmail:(NSString* _Nonnull)email
              password:(NSString* _Nonnull)password
 withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSString* _Nullable, NSString* _Nullable))handler;

@end
