//
//  NetworkingService.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "NetworkingService.h"

@implementation NetworkingService

#pragma mark Initialization

+ (id)shared {
    static NetworkingService* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Auth

- (void)signUpWithName:(NSString*_Nonnull)name password:(NSString*_Nonnull)password email:(NSString*_Nonnull)email withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSNumber* _Nullable, NSString* _Nullable, NSString* _Nullable))handler {
    NSURL* url = [[NSURL alloc] initWithString:@"http://gold2star.kjbsoft.com/espcon/signup.php"];
    NSString* parameters = [[[[[@"name=" stringByAppendingString:name] stringByAppendingString:@"&email="] stringByAppendingString:email] stringByAppendingString:@"&password="] stringByAppendingString:password];
    NSData* body = [parameters dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    NSLog(@"%@", request);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
        } else {
            NSError* _Nullable __autoreleasing error;
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                NSLog(@"ERROR: %@", [error localizedDescription]);
                handler(error, nil, nil, nil);
            } else {
                //NSLog(@"DATA: %@", dataDictionary);
                NSNumber* deviceID = (NSNumber*)[dataDictionary valueForKey:@"id"];
                NSString* message = (NSString*)[dataDictionary valueForKey:@"msg"];
                NSString* status = (NSString*)[dataDictionary valueForKey:@"status"];
                NSLog(@"id: %@, msg: %@, status: %@", deviceID, message, status);
                handler(nil, deviceID, status, message);
            }
        }
    }] resume];
}

- (void)logInWithEmail:(NSString* _Nonnull)email password:(NSString* _Nonnull)password withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSString* _Nullable, NSString* _Nullable, UserInfo* _Nullable))handler {
    NSURL* url = [[NSURL alloc] initWithString:@"http://gold2star.kjbsoft.com/espcon/login.php"];
    NSString* parameters = [[[@"username=" stringByAppendingString:email] stringByAppendingString:@"&password="] stringByAppendingString:password];
    NSData* body = [parameters dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    NSLog(@"%@", request);
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            handler(error, nil, nil, nil);
        } else {
            NSError* _Nullable __autoreleasing error;
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                NSLog(@"ERROR: %@", [error localizedDescription]);
            } else {
                //NSLog(@"DATA: %@", dataDictionary);
                NSString* message = (NSString*)[dataDictionary valueForKey:@"msg"];
                NSString* status = (NSString*)[dataDictionary valueForKey:@"status"];
                NSDictionary* userInfoDict = [dataDictionary valueForKey:@"user_info"];
                    NSString* userID = [userInfoDict valueForKey:@"user_id"];
                    NSString* userName = [userInfoDict valueForKey:@"user_name"];
                    NSString* userEmail = [userInfoDict valueForKey:@"user_email"];
                    NSString* password = [userInfoDict valueForKey:@"password"];
                    NSString* otpCode = [userInfoDict valueForKey:@"otp_code"];
                    NSString* access = [userInfoDict valueForKey:@"access"];
                UserInfo* userInfo = [[UserInfo alloc] initWithUserID:userID
                                                         userName:userName
                                                        userEmail:userEmail
                                                         password:password
                                                          otpCode:otpCode
                                                           access:access];
                NSLog(@"msg: %@, status: %@, userInfo: %@", message, status, userInfo);
                handler(nil, status, message, userInfo);
            }
        }
    }] resume];
}

- (void)getDevicesForUserWithID:(NSString* _Nonnull)userID withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable, NSString * _Nullable, NSArray * _Nullable))handler {
    NSURL* url = [[NSURL alloc] initWithString:[@"http://gold2star.kjbsoft.com/espcon/get_devices.php?user_id=" stringByAppendingString:userID]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            handler(error, nil, nil);
        } else {
            NSError* _Nullable __autoreleasing error;
                // Fixes to serialize a bullshit that backend developers made
                NSString* dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                NSString* fixedString = [dataString substringToIndex:[dataString length] - 1];
                NSData* fixedData = [fixedString dataUsingEncoding:NSASCIIStringEncoding];
                // Must be deleted after a backend fix
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:fixedData options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                NSLog(@"ERROR: %@", [error localizedDescription]);
                handler(error, nil, nil);
            } else {
                //NSLog(@"%@", dataDictionary);
                NSMutableArray* devicesDictArray = [dataDictionary valueForKey:@"result"];
                NSString* status = [dataDictionary valueForKey:@"status"];
                NSMutableArray* devicesArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < devicesDictArray.count; i++) {
                    NSDictionary* object = [devicesDictArray objectAtIndex:i];
                    Device* device = [[Device alloc] initWithSSID:[object valueForKey:@"wifi_ssid"]
                                                         password:[object valueForKey:@"wifi_password"]
                                                             name:[object valueForKey:@"device_name"]
                                                         deviceID:[object valueForKey:@"device_id"]
                                                           userID:[object valueForKey:@"user_id"]
                                                       MACaddress:[object valueForKey:@"mac_address"]
                                                            state:[object valueForKey:@"device_state"]];
                    NSLog(@"%@", [object valueForKey:@"device_name"]);
                    [devicesArray addObject:device];
                    NSLog(@"Object: %@", [device state]);
                }
                handler(nil, status, devicesArray);
            }
        }
    }] resume];
}

- (void)addNewDevice:(Device* _Nonnull)device withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message, NSInteger deviceID))handler {
    NSURL* url = [[NSURL alloc] initWithString:@"http://gold2star.kjbsoft.com/espcon/get_newDevId.php"];
    NSString* parameters = [[[[[[[[[@"user_id=" stringByAppendingString:[device userID]] stringByAppendingString:@"&device_name="] stringByAppendingString:[device name]] stringByAppendingString:@"&ssid="] stringByAppendingString:@"ESP32DEV"] stringByAppendingString:@"&password="] stringByAppendingString:@"12345678"] stringByAppendingString:@"&mac_address="] stringByAppendingString:[device MACaddress]];
    NSData* body = [parameters dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            handler(error, nil, nil, 0);
        } else {
            NSError* _Nullable __autoreleasing error;
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"%@", dataDictionary);
            NSString* status = [dataDictionary valueForKey:@"status"];
            NSString* message = [dataDictionary valueForKey:@"msg"];
            NSInteger deviceID = [[dataDictionary valueForKey:@"id"] integerValue];
            handler(nil, status, message, deviceID);
        }
    }] resume];
}

- (void)deleteDevice:(Device* _Nonnull)device withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message))handler {
    NSURL* url = [[NSURL alloc] initWithString:[@"http://gold2star.kjbsoft.com/espcon/remove_device.php?device_id=" stringByAppendingString:[device deviceID]]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            handler(error, nil, nil);
        } else {
            NSError* _Nullable __autoreleasing error;
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSString* status = [dataDictionary valueForKey:@"status"];
            NSString* message = [dataDictionary valueForKey:@"msg"];
            handler(nil, status, message);
        }
    }] resume];
}

- (void)setDeviceStateON:(BOOL)state forDevice:(Device* _Nonnull)device withCompletionHandler:(void(^_Nonnull)(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message))handler {
    NSURL* url = [NSURL URLWithString:[[[@"http://gold2star.kjbsoft.com/espcon/set_led_state.php?device_id=" stringByAppendingString:[device deviceID]] stringByAppendingString:@"&on_off="] stringByAppendingString:( state ? @"on" : @"off" )]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR: %@", [error localizedDescription]);
            handler(error, nil, nil);
        } else {
            NSError* _Nullable __autoreleasing error;
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSString* status = [dataDictionary valueForKey:@"status"];
            NSString* message = [dataDictionary valueForKey:@"msg"];
            handler(nil, status, message);
        }
    }] resume];
}

@end
