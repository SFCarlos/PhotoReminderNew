//
//  NoteListViewController.h
//  PhotoReminderNew
//
//  Created by User on 02.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "SWTableViewCell.h"
@interface NoteListViewController : UIViewController <SWTableViewCellDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DatabaseHelper *dao;
@end
