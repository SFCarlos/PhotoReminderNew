//
//  RemindersListViewController.h
//  PhotoReminder
//
//  Created by User on 08.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderObject.h"
#import "DatabaseHelper.h"
#import "SWTableViewCell.h"
@interface RemindersListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate>
@property (nonatomic, strong)  ReminderObject* reminderObj;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) DatabaseHelper *dao;
@property (nonatomic, strong) NSMutableArray *reminderArray;
@end
