//
//  SettingsViewController.h
//  PhotoReminder
//
//  Created by User on 09.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSServiceProxy.h"

@interface SettingsViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate,Wsdl2CodeProxyDelegate>

- (IBAction)SyncSwitchAction:(id)sender;

- (IBAction)CategoriesEditAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *statuslabel;
@property (strong, nonatomic) IBOutlet UIButton *connectButon;
- (IBAction)connectButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *passwImput;
@property (nonatomic,retain) iOSServiceProxy* service;
@property (strong, nonatomic) IBOutlet UITextField *userImput;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollV;
@property (strong, nonatomic) IBOutlet UISwitch *timeformatSwitch;
- (IBAction)showNotificationOptionsAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *soundselectedLabel;
@property (strong, nonatomic) IBOutlet UISwitch *syncSwitch;
@end
