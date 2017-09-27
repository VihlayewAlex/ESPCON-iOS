//
//  AddDeviceViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ssidNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameField;
@property (weak, nonatomic) IBOutlet UITextField *deviceIDField;

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark Actions

- (IBAction)scanNewDevice:(UIButton *)sender {
    
}

- (IBAction)saveToBoard:(UIButton *)sender {
    
}

- (IBAction)signOut:(UIButton *)sender {
    
}

@end
