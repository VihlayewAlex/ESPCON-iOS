//
//  ScanningTableViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 02/10/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "ScanningTableViewController.h"

@interface ScanningTableViewController ()

@end

@implementation ScanningTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CoreBluetoothService shared] startScan];
    
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [[self tableView] reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[[CoreBluetoothService shared] discoveredDevices] count];
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    CBPeripheral* device = [[[CoreBluetoothService shared] discoveredDevices] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[device name]];
    [[cell detailTextLabel] setText:[[device identifier] UUIDString]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral* device = [[[CoreBluetoothService shared] discoveredDevices] objectAtIndex:0];
    [[CoreBluetoothService shared] connectToPeripheral:device];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self navigationController] popViewControllerAnimated:YES];
    });
}

@end
