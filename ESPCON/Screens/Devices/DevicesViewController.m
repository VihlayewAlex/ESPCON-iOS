//
//  DevicesViewController.m
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import "DevicesViewController.h"

@interface DevicesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *devicesTableView;

@property (strong, nonatomic) NSMutableArray* devices;

@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _devices = [[NSMutableArray alloc] init];
    
    [self configureTableView];
    [self configureEmptyDataSet];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadDevices];
}

- (void)configureTableView {
    [_devicesTableView setDelegate:self];
    [_devicesTableView setDataSource:self];
}

- (void)configureEmptyDataSet {
    [_devicesTableView setEmptyDataSetSource:self];
    [_devicesTableView setEmptyDataSetDelegate:self];
    [[self devicesTableView] setTableFooterView:[[UIView alloc] init]];
}

- (void)loadDevices {
    NSString* userID = [[[LocalDatabaseService shared] getUserInfo] userID];
    if (!userID) {
        return;
    }
    [[NetworkingService shared] getDevicesForUserWithID:userID withCompletionHandler:^(NSError * error, NSString * status, NSArray * devices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"ERROR: %@", error);
            } else {
                [_devices removeAllObjects];
                for (Device* device in devices) {
                    if (![[device state] isEqualToString:@"del"]) {
                        [_devices addObject:device];
                    }
                }
                [[self devicesTableView] reloadData];
            }
        });
    }];
}

#pragma mark EmptyDataSet

- (NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"No devices"];
}

- (NSAttributedString*)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"You can add new devices on ‘Add device’ tab"];
}

- (UIColor*)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_devices count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell* cell = (DeviceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    Device* device = [_devices objectAtIndex:[indexPath row]];
    [[cell deviceNameLabel] setText:[device name]];
    [[cell deviceStateSwitch] setOn:([[device state] isEqualToString:@"on"])];
    [cell setDevice:device];
    [cell setDelegate:self];
    
    return cell;
}

#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark DeviceTableViewCellDelegate

- (void)didDeleteDevice:(Device *)device {
    [self loadDevices];
}

@end
