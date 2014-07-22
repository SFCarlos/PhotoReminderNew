//
//  ShoopingListViewController.h
//  PhotoReminderNew
//
//  Created by User on 26.06.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "DatabaseHelper.h"
@interface ShoopingListViewController : UIViewController <SWTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DatabaseHelper *dao;
@end
