//
//  DevicesViewController.h
//  ESPCON
//
//  Created by Alex Vihlayew on 26/09/2017.
//  Copyright © 2017 Alex Vihlayew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "DevicesService.h"
#import "NetworkingService.h"
#import "LocalDatabaseService.h"
#import "DeviceTableViewCell.h"

@interface DevicesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, DeviceTableViewCellDelegate>

@end
