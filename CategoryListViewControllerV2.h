//
//  CategoryListViewControllerV2.h
//  PhotoReminderNew
//
//  Created by User on 27.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "SWTableViewCell.h"
@interface CategoryListViewControllerV2 : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, SWTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DatabaseHelper *dao;
@end
