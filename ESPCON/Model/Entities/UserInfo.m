//
//  UserInfo.m
//  ESPCON
//
//  Created by Alex Vihlayew on 29/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (instancetype)initWithUserID:(NSString*)userID userName:(NSString*)userName userEmail:(NSString*)userEmail password:(NSString*)password otpCode:(NSString*)otpCode access:(NSString*)access
{
    self = [super init];
    if (self) {
        [self setUserID:userID];
        [self setUserName:userName];
        [self setUserEmail:userEmail];
        [self setPassword:password];
        [self setOtpCode:otpCode];
        [self setAccess:access];
    }
    return self;
}

@end
