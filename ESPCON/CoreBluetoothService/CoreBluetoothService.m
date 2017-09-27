//
//  CoreBluetoothService.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "CoreBluetoothService.h"

@interface CoreBluetoothService ()

@property (strong, nonatomic) CBCentralManager* bluetoothManager;

@end

@implementation CoreBluetoothService

#pragma mark Initialization

+ (id)shared {
    static CoreBluetoothService* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark Start/Stop

- (void)start {
    [_bluetoothManager setDelegate:self];
    [_bluetoothManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stop {
    [_bluetoothManager stopScan];
}

#pragma mark CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService* service in [peripheral services]) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {
    NSLog(@"Discovered characteristics: %@", [service characteristics]);
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch ([central state]) {
        case CBManagerStatePoweredOn:
            NSLog(@"CBManager powered on");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"CBManager powered off");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBManager is unauthorized");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBManager is unsupported");
            break;
        case CBManagerStateResetting:
            NSLog(@"CBManager is resettings");
            break;
        case CBManagerStateUnknown:
            NSLog(@"CBManager state unknown");
            break;
    }
}


@end
