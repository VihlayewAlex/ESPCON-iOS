//
//  SignInViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 9/28/17.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UIStackView *contentStackView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_emailTextField setDelegate:self];
    [_passwordTextField setDelegate:self];
    
    [KeyboardAvoiding setAvoidingView:_contentStackView];
}

#pragma mark Actions

- (IBAction)signIn:(UIButton *)sender {
    NSString* email = [_emailTextField text];
    NSString* password = [_passwordTextField text];
    
    [[NetworkingService shared] logInWithEmail:email password:password withCompletionHandler:^(NSError * error, NSString * status, NSString * message) {
        if (error) {
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            // Log in
        }
    }];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}

@end
