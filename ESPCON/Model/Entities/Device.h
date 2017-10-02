//
//  Device.h
//  ESPCON
//
//  Created by Alex Vihlayew on 01/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (strong, nonatomic) NSString* SSID;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* deviceID;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* MACaddress;
@property (strong, nonatomic) NSString* state;

- (instancetype)initWithSSID:(NSString*)SSID
                    password:(NSString*)password
                        name:(NSString*)name
                    deviceID:(NSString*)deviceID
                      userID:(NSString*)userID
                  MACaddress:(NSString*)MACaddress
                       state:(NSString*)state;

@end
