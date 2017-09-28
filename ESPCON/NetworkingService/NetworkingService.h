//
//  NetworkingService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingService : NSObject

+ (id)shared;
- (void)signUpWithName:(NSString*)name password:(NSString*)password email:(NSString*)email;

@end
