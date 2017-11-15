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
@property (strong, nonatomic) NSMutableDictionary* UIDdict;

@end

static NSString* SERVER_ID = @"kdxb.000webhostapp.com";

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _UIDdict = [[NSMutableDictionary alloc] init];
    
    [_ssidNameField setDelegate:self];
    [_passwordField setDelegate:self];
    [_confirmPasswordField setDelegate:self];
    [_deviceNameField setDelegate:self];
    [_deviceIDField setDelegate:self];
    
    [self configureSSIDfield];
}

- (void)configureSSIDfield
{
    NSString* SSID = [self fetchSsid];
    if (![SSID isEqualToString:@"ESP32DEV"]) {
        [_ssidNameField setText:SSID];
    }
}

- (NSString *)fetchSsid
{
    NSDictionary *ssidInfo = [self fetchNetInfo];
    
    return [ssidInfo objectForKey:@"SSID"];
}

- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

#pragma mark Actions

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *)randomStringWithLength:(int)len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (IBAction)getDeviceID:(UIButton *)sender {
        NSString* SSID = [_ssidNameField text];
        NSString* password = [_passwordField text];
        NSString* userID = [[[LocalDatabaseService shared] getUserInfo] userID];
        NSString* name = [_deviceNameField text];
        NSString* UUID = [self randomStringWithLength:10];
        
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
                    [_UIDdict setObject:UUID forKey:[NSString stringWithFormat:@"%li", (long)deviceID]];
                    
                    [_deviceIDField setText:[NSString stringWithFormat:@"%ld", (long)deviceID]];
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:status message:message preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            });
        }];
}

- (IBAction)saveToBoard:(UIButton *)sender {
    NSString* SSID = [_ssidNameField text];
    NSString* password = [_passwordField text];
    NSString* ID = [[[LocalDatabaseService shared] getUserInfo] userID];
    NSString* deviceID = [_deviceIDField text];
    
    if (!(SSID) || [SSID isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"SSID fields can't be empty" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (!(password)) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password field can't be empty" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (![password isEqualToString:[_confirmPasswordField text]]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Passwords must match" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (!(ID) || [ID isEqualToString:@""]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"ID fields can't be empty" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
    
        NEHotspotConfiguration *configuration = [[NEHotspotConfiguration
                                              alloc] initWithSSID:@"ESP32DEV" passphrase:@"12345678" isWEP:NO];
        configuration.joinOnce = YES;
    
        [[NEHotspotConfigurationManager sharedManager] applyConfiguration:configuration completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            expirationDate = [NSDate dateWithTimeIntervalSinceNow:5];
            [self startConfigurationWithSSID:SSID password:password ID:ID deviceID:deviceID];
        }];
    }
}

NSDate* expirationDate;
- (void)startConfigurationWithSSID:(NSString*)SSID password:(NSString*)password ID:(NSString*)ID deviceID:(NSString*)deviceID {
    NSLog(@"Started configuration...");
    
    NSTimer* timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1] interval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if ([expirationDate timeIntervalSinceNow] > 0) {
            NSLog(@"Will perform request");
            NSString* randomUID = [_UIDdict objectForKey:deviceID];
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[[[[[[[[[[[@"http://192.168.4.1/ssid_name:" stringByAppendingString:SSID]
                                                                                                    stringByAppendingString:@";ssid_pass:"]
                                                                                                       stringByAppendingString:password]
                                                                                                      stringByAppendingString:@";user_id:"]
                                                                                                            stringByAppendingString:ID] stringByAppendingString:@";device_id:"] stringByAppendingString:deviceID] stringByAppendingString:@";server:"] stringByAppendingString:SERVER_ID] stringByAppendingString:@";mac:"] stringByAppendingString:randomUID] stringByAppendingString:@";"]]];
            [request setHTTPMethod:@"GET"];
            [request setTimeoutInterval:3];
            NSLog(@"Will execute local request: %@", [[request URL] absoluteString]);
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Local request error: %@", [error localizedDescription]);
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self startConfigurationWithSSID:SSID password:password ID:ID deviceID:deviceID];
                    });
                } else {
                    NSLog(@"Get response");
                    [self completeConfigurationWithSuccess:YES];
                }
            }] resume];
            
        } else {
            [timer invalidate];
            NSLog(@"Timer invalidated");
        }
        
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)completeConfigurationWithSuccess:(BOOL)success {
    [[NEHotspotConfigurationManager sharedManager] removeConfigurationForSSID:@"ESP32DEV"];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:(success ? @"Success" : @"Error") message:(success ? @"Configuration completed!" : @"ID fields can't be empty") preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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

@end
