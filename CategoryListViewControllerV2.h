//
//  CategoryListViewControllerV2.h
//  PhotoReminderNew
//
//  Created by User on 27.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//
#import "CMPopTipView.h"
#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "iOSServiceProxy.h"
#import "SWTableViewCell.h"
@interface CategoryListViewControllerV2 : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, SWTableViewCellDelegate,Wsdl2CodeProxyDelegate, CMPopTipViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DatabaseHelper *dao;

@end
