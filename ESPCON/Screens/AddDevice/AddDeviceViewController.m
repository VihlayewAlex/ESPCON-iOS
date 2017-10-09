//
//  AddDeviceViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *contentStackView;
@property (weak, nonatomic) IBOutlet UITextField *ssidNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameField;
@property (weak, nonatomic) IBOutlet UITextField *deviceIDField;
@property (weak, nonatomic) IBOutlet UIView *connectedStatusView;
@property (weak, nonatomic) IBOutlet UILabel *connectedStatusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectedStatusViewHeightConstraint;

@property (weak, nonatomic) UITextField* lastActiveField;
@property (strong, nonatomic) NSTimer* timer;

@property (assign, nonatomic) BOOL isDeviceConnected;

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_ssidNameField setDelegate:self];
    [_passwordField setDelegate:self];
    [_confirmPasswordField setDelegate:self];
    [_deviceNameField setDelegate:self];
    [_deviceIDField setDelegate:self];
    
    [[EspTouchService shared] setDelegate:self];
    
    [self configureSSIDfield];
}

- (void)configureSSIDfield {
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"]) {
            wifiName = info[@"SSID"];
        }
    }
    [_ssidNameField setText:wifiName];
}

#pragma mark Actions

- (IBAction)getDeviceID:(UIButton *)sender {
    if (_isDeviceConnected) {
        NSString* SSID = [_ssidNameField text];
        NSString* password = [_passwordField text];
        NSString* userID = [[[LocalDatabaseService shared] getUserInfo] userID];
        NSString* name = [_deviceNameField text];
        NSString* UUID = @"SOME_UUID"; // Device identifier
        
        if (!(SSID && password && userID && name && UUID)) {
            NSLog(@"Need more data");
            return;
        }
        
        Device* device = [[Device alloc] initWithSSID:SSID
                                             password:password name:name
                                             deviceID:nil
                                               userID:userID
                                           MACaddress:UUID
                                                state:nil];
        [[NetworkingService shared] addNewDevice:device withCompletionHandler:^(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message, NSInteger deviceID) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"ERROR: %@", [error localizedDescription]);
                } else {
                    [_deviceIDField setText:[NSString stringWithFormat:@"%ld", (long)deviceID]];
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:status message:message preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            });
        }];
    } else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"No device" message:@"Connect to any device first" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (IBAction)saveToBoard:(UIButton *)sender {
    NSString* SSID = [_ssidNameField text];
    NSString* password = [_passwordField text];
    
    
}

- (IBAction)signOut:(UIButton *)sender {
    [[LocalDatabaseService shared] saveUserInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}

#pragma mark EspTouchServiceDelegate



@end
