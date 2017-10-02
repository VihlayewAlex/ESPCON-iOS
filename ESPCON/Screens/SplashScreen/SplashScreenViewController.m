//
//  SplashScreenViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([[LocalDatabaseService shared] getUserInfo]) {
        [self performSegueWithIdentifier:@"mainSegue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"authSegue" sender:nil];
    }
}

@end
