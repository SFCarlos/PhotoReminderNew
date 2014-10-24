//
//  NotificationScreenController.h
//  PhotoReminder
//
//  Created by User on 14.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "POVoiceHUD.h"
#import "LocalNotificationCore.h"
#import "UILabel+dynamicSize.h"

@interface NotificationScreenController : UIViewController<POVoiceHUDDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *snooze;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollV;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic)  NSInteger* reminderId;
@property (weak, nonatomic) IBOutlet UIButton *DoneButto;
@property (nonatomic)  UILocalNotification* recivedNotificaion;
- (IBAction)DoneReminder:(id)sender;
- (IBAction)showNoteAction:(id)sender;
- (IBAction)Play:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *showNoteButton;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *eventName;
@property (nonatomic, retain) POVoiceHUD *voiceHud;
@property (strong, nonatomic) IBOutlet UIImageView *ImagenShowNotification;
- (IBAction)snooze:(id)sender;
@property (nonatomic, strong) DatabaseHelper *dao;
@property (nonatomic, strong)  ReminderObject* reminderObj;

@end
