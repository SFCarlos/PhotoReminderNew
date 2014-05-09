//
//  SettingsViewController.h
//  PhotoReminder
//
//  Created by User on 09.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *timeformatSwitch;

@end
