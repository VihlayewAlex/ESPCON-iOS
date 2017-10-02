//
//  AddDeviceViewController.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESPCON-Swift.h"
#import "LocalDatabaseService.h"
#import "CoreBluetoothService.h"
#import "NetworkingService.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface AddDeviceViewController : UIViewController <UITextFieldDelegate, CoreBluetoothServiceDelegate>

@end
