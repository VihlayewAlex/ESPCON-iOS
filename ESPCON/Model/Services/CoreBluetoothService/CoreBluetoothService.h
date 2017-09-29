//
//  CoreBluetoothService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CoreBluetoothService : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

+ (id)shared;

@end
