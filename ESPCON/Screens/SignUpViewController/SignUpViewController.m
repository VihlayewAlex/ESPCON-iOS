//
//  SignUpViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 9/28/17.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *contentStackView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_nameTextField setDelegate:self];
    [_emailTextField setDelegate:self];
    [_passwordTextField setDelegate:self];
    [_confirmPasswordTextField setDelegate:self];
    
    [KeyboardAvoiding setAvoidingView:_contentStackView];
}

#pragma mark Actions

- (IBAction)signUp:(UIButton *)sender {
    NSString* name = [_nameTextField text];
    NSString* email = [_emailTextField text];
    NSString* password = [_passwordTextField text];
    NSString* passwordConfirmation = [_confirmPasswordTextField text];
    
    // Validation
    if (![password isEqualToString:passwordConfirmation]) {
        return;
    }
    
    [[NetworkingService shared] signUpWithName:name password:password email:email withCompletionHandler:^(NSError* error, NSNumber* deviceID, NSString* status, NSString* message) {
        UIAlertController* alertController;
        if (error) {
            alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        } else {
            alertController = [UIAlertController alertControllerWithTitle:status message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}

@end
