//
//  CoreBluetoothService.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol CoreBluetoothServiceDelegate

- (void)didConnectToPeripheral:(CBPeripheral*)peripheral;

@end

@interface CoreBluetoothService : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) NSMutableArray* discoveredDevices;

+ (id)shared;

- (void)startScan;
- (void)stopScan;
- (void)connectToPeripheral:(CBPeripheral*)device;

@end
