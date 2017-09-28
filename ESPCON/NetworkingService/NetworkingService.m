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

- (void)signUpWithName:(NSString*)name password:(NSString*)password email:(NSString*)email {
    NSURL* url = [[NSURL alloc] initWithString:@"http://gold2star.kjbsoft.com/espcon/signup.php"];
    NSString* parameters = [[[[[@"name=" stringByAppendingString:name] stringByAppendingString:@"&email="] stringByAppendingString:email] stringByAppendingString:@"&password="] stringByAppendingString:password];
    NSData* body = [parameters dataUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
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
            } else {
                //NSLog(@"DATA: %@", dataDictionary);
                NSNumber* deviceID = (NSNumber*)[dataDictionary valueForKey:@"id"];
                NSString* message = (NSString*)[dataDictionary valueForKey:@"msg"];
                NSString* status = (NSString*)[dataDictionary valueForKey:@"status"];
                NSLog(@"id: %@, msg: %@, status: %@", deviceID, message, status);
            }
        }
    }] resume];
}

@end
