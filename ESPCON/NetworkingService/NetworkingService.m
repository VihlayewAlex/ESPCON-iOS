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
    NSURLComponents* requestComponents = [[NSURLComponents alloc] initWithString:@"http://gold2star.kjbsoft.com/espcon/signup.php"];
    [requestComponents setQuery:@"name="];
    [requestComponents setQuery:@"password="];
    [requestComponents setQuery:@"email="];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[requestComponents URL]];
    
    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR:, %@", [error localizedDescription]);
        } else {
            NSLog(@"%@", data);
        }
    }];
}

@end
