//
//  DeviceTableViewCell.h
//  ESPCON
//
//  Created by Alex Vihlayew on 02/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "NetworkingService.h"

@protocol DeviceTableViewCellDelegate

- (void)didDeleteDevice:(Device*)device;

@end

@interface DeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *deviceStateSwitch;

@property (weak, nonatomic) id<DeviceTableViewCellDelegate> delegate;

@property (strong, nonatomic) Device* device;

@end
