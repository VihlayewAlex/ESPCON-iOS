//
//  UserInfo.h
//  ESPCON
//
//  Created by Alex Vihlayew on 29/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* userEmail;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* otpCode;
@property (strong, nonatomic) NSString* access;

- (instancetype)initWithUserID:(NSString*)userID userName:(NSString*)userName userEmail:(NSString*)userEmail password:(NSString*)password otpCode:(NSString*)otpCode access:(NSString*)access;

@end
