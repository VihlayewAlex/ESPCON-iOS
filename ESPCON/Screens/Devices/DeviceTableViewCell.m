//
//  DeviceTableViewCell.m
//  ESPCON
//
//  Created by Alex Vihlayew on 02/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "DeviceTableViewCell.h"

@interface DeviceTableViewCell ()

@end

@implementation DeviceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark Actions

- (IBAction)switchValueChanged:(UISwitch *)sender {
    [[NetworkingService shared] setDeviceStateON:[sender isOn] forDevice:_device withCompletionHandler:^(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message) {
        // TODO: Handle switching errors
        NSLog(@"%@", status);
        NSLog(@"%@", message);
    }];
}

- (IBAction)deleteButtonTapped:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Deleting" message:@"Device will be deleted from the list" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NetworkingService shared] deleteDevice:_device withCompletionHandler:^(NSError * _Nullable error, NSString * _Nullable status, NSString * _Nullable message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // TODO: Handle deletion errors
                NSLog(@"%@", status);
                NSLog(@"%@", message);
                [_delegate didDeleteDevice:_device];
            });
        }];
    }]];
    [(UIViewController*)_delegate presentViewController:alert animated:YES completion:nil];
}

@end
