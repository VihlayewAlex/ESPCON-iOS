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

- (void)logInWithEmail:(NSString* _Nonnull)email password:(NSString* _Nonnull)password withCompletionHandler:(void(^_Nonnull)(NSError* _Nullable, NSString* _Nullable, NSString* _Nullable))handler {
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
            handler(error, nil);
        } else {
            NSError* _Nullable __autoreleasing error;
            NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                NSLog(@"ERROR: %@", [error localizedDescription]);
            } else {
                //NSLog(@"DATA: %@", dataDictionary);
                NSString* message = (NSString*)[dataDictionary valueForKey:@"msg"];
                NSString* status = (NSString*)[dataDictionary valueForKey:@"status"];
                NSLog(@"msg: %@, status: %@", message, status);
                handler(nil, message);
            }
        }
    }] resume];
}

@end
