//
//  AppDelegate.h
//  ESPCON
//
//  Created by Alex Vihlayew on 25/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

