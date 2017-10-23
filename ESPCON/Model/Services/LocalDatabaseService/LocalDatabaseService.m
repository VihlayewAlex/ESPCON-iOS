//
//  LocalDatabaseService.m
//  ESPCON
//
//  Created by Alex Vihlayew on 29/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "LocalDatabaseService.h"

@implementation LocalDatabaseService

#pragma mark Initialization

+ (id)shared {
    static LocalDatabaseService* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark UserInfo saving

- (void)saveUserInfo:(UserInfo* _Nullable)userInfo {
    NSManagedObjectContext* context = [(AppDelegate*)([[UIApplication sharedApplication] delegate]) managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfoData" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSBatchDeleteRequest* deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
    
    NSError* error;
    [context executeRequest:deleteRequest error:&error];
    
    if (userInfo) {
        UserInfoData* infoData = [[UserInfoData alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        [infoData setUserID:[userInfo userID]];
        [infoData setName:[userInfo userName]];
        [infoData setEmail:[userInfo userEmail]];
        [infoData setPassword:[userInfo password]];
        [infoData setOtpCode:[userInfo otpCode]];
        [infoData setAccess:[userInfo access]];
    }
   
    [context save:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

- (UserInfo* _Nullable)getUserInfo {
    NSManagedObjectContext* context = [(AppDelegate*)([[UIApplication sharedApplication] delegate]) managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserInfoData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    UserInfoData* infoData = [fetchedObjects firstObject];
    if (infoData) {
        UserInfo* info = [[UserInfo alloc] initWithUserID:[infoData userID]
                                                 userName:[infoData name]
                                                userEmail:[infoData email]
                                                 password:[infoData password]
                                                  otpCode:[infoData otpCode]
                                                   access:[infoData access]];
        return info;
    } else {
        return nil;
    }
}

#pragma mark Device saving

- (void)saveDevice:(Device* _Nonnull)device {
    NSManagedObjectContext* context = [(AppDelegate*)([[UIApplication sharedApplication] delegate]) managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceData" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSError* error;

    DeviceData* deviceData = [[DeviceData alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    [deviceData setSsid:[device SSID]];
    [deviceData setName:[device name]];
    [deviceData setDeviceID:[device deviceID]];
    [deviceData setPassword:[device password]];
    
    [context save:&error];
    if (error) {
        NSLog(@"%@", error);
    }
}

- (NSArray* _Nonnull)getDevices {
    NSManagedObjectContext* context = [(AppDelegate*)([[UIApplication sharedApplication] delegate]) managedObjectContext];
        
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceData" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
        
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

@end
