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

@end

@implementation DevicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureEmptyDataSet];
}

- (void)configureEmptyDataSet {
    [_devicesTableView setEmptyDataSetSource:self];
    [_devicesTableView setEmptyDataSetDelegate:self];
    [[self devicesTableView] setTableFooterView:[[UIView alloc] init]];
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

@end
