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
@property (weak, nonatomic) id<CoreBluetoothServiceDelegate> delegate;

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

- (void)startScan {
    _discoveredDevices = [[NSMutableArray alloc] init];
    _bluetoothManager = [[CBCentralManager alloc] init];
    [_bluetoothManager setDelegate:self];
    NSLog(@"Starting..");
}

- (void)stopScan {
    [_bluetoothManager stopScan];
}

- (void)connectToPeripheral:(CBPeripheral*)device {
    [_bluetoothManager connectPeripheral:device options:nil];
}

#pragma mark CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [_discoveredDevices addObject:peripheral];
    NSLog(@"Discovered peripheral: %@", [peripheral name]);
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    [_delegate didConnectToPeripheral:peripheral];
    NSLog(@"Connected to peripheral: %@", [peripheral name]);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService* service in [peripheral services]) {
        [peripheral discoverCharacteristics:nil forService:service];
        NSLog(@"Discovered service with UUID: %@", [[service UUID] UUIDString]);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error {
    for (CBCharacteristic* characteristic in [service characteristics]) {
        NSLog(@"Discovered characteristic: %@", [[characteristic UUID] UUIDString]);
    }
}

- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch ([central state]) {
        case CBManagerStatePoweredOn:
            NSLog(@"CBManager powered on");
            [_bluetoothManager scanForPeripheralsWithServices:nil options:nil];
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
        default:
            NSLog(@"Undefined case");
            break;
    }
}


@end
