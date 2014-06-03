//
//  SettingsViewController.h
//  PhotoReminder
//
//  Created by User on 09.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reminderServiceProxy.h"

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,Wsdl2CodeProxyDelegate>
- (IBAction)registerAction:(id)sender;
- (IBAction)SyncSwitchAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UITextField *passwImput;
@property (nonatomic,retain) reminderServiceProxy* service;
@property (strong, nonatomic) IBOutlet UITextField *userImput;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UISwitch *timeformatSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *syncSwitch;
@end
