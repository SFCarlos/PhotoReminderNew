//
//  NotificationScreenController.m
//  PhotoReminder
//
//  Created by User on 14.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "NotificationScreenController.h"
#import "YIPopupTextView.h"
#import "LocalNotificationCore.h"
#import <QuartzCore/QuartzCore.h>
#import "Globals.h"
#import "UILabel+dynamicSize.h"

@interface NotificationScreenController ()

@end

@implementation NotificationScreenController{
DatabaseHelper *dao;
    AVAudioPlayer * payl;
    int IntervalSnooze;
    NSString* audioPath;
}
@synthesize recivedNotificaion;
@synthesize playButton;
@synthesize showNoteButton;
@synthesize DoneButto;
@synthesize ScrollV;
@synthesize snooze;
@synthesize reminderId;
@synthesize dao;
@synthesize reminderObj;
@synthesize ImagenShowNotification;
@synthesize eventName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    [ScrollV setContentSize:CGSizeMake(320, 400)];
}
- (void)viewDidLoad
{
    
    [ScrollV setScrollEnabled:YES];
    dao = [[DatabaseHelper alloc] init];
    NSLog(@"%d Este es el Id en Screen ",(int)reminderId);
    ReminderObject *reminder=[dao getItemwhitServerID:reminderId usingServerId:NO];
   
    NSMutableArray * photoPathsCopy =[dao get_items_PhotoPaths:reminder.reminderID];
    NSMutableArray * audioPathsCopy =[dao get_items_RecordPaths:reminder.reminderID];
    //get photo in array reminder only one
    
    //NSLog(@"SCREM photo path: %@",(NSString*)[photoPathsCopy firstObject]);
    ImagenShowNotification.image =[UIImage imageWithContentsOfFile:(NSString*)[photoPathsCopy firstObject]];
    
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
   
   
    if(ImagenShowNotification.image == nil){
        
        ImagenShowNotification.image = [UIImage imageNamed:@"noimage.jpg"];
    }
    
    
    NSString * note = reminder.note;
    eventName.text= reminder.reminderName;
    
    
    if (audioPathsCopy.count ==0 ) {
        playButton.hidden = YES;
    }else
        audioPath = (NSString*)[audioPathsCopy firstObject];
    
    
    
    if ( note == nil ||[note isEqualToString:@""]||[note isEqualToString:@"(null)"]) {
        showNoteButton.hidden = YES;
    }
   
    showNoteButton.layer.borderWidth=1.0f;
    showNoteButton.layer.borderColor=[[UIColor colorWithRed:0.04 green:0.54 blue:0.82 alpha:1.0] CGColor];
    playButton.layer.borderWidth=1.0f;
    playButton.layer.borderColor=[[UIColor colorWithRed:0.04 green:0.54 blue:0.82 alpha:1.0] CGColor]; showNoteButton.layer.borderWidth=1.0f;
    snooze.layer.borderColor=[[UIColor colorWithRed:0.04 green:0.54 blue:0.82 alpha:1.0] CGColor] ;
    snooze.layer.borderWidth=1.0f;
    DoneButto.layer.borderColor=[[UIColor colorWithRed:0.04 green:0.54 blue:0.82 alpha:1.0] CGColor];
    DoneButto.layer.borderWidth=1.0f;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text
{
    CGSize maximumLabelSize     = CGSizeMake(290, FLT_MAX);
    
    CGSize expectedLabelSize    = [text sizeWithFont:label.font
                                   constrainedToSize:maximumLabelSize
                                       lineBreakMode:label.lineBreakMode];
    
    return expectedLabelSize.height;
}

-(void)resizeHeightToFitForLabel:(UILabel *)label
{
    CGRect newFrame         = label.frame;
    newFrame.size.height    = [self heightForLabel:label withText:label.text];
    label.frame             = newFrame;
}
-(void)resizeHeightToFitForLabel:(UILabel *)label withText:(NSString *)text
{
    label.text              = text;
    [self resizeHeightToFitForLabel:label];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)snooze:(id)sender{

    UIActionSheet* snoozePopup =[[UIActionSheet alloc]initWithTitle:@"in.." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"5 min",@"10 min",@"15 min" ,nil];
    [snoozePopup showInView:[UIApplication sharedApplication].keyWindow];
    
    
}
-(NSString*)retrieveSoundReminderFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"REMINDER_SOUND"];
    
    return val;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    
     ReminderObject *reminder=[dao getItemwhitServerID:reminderId usingServerId:NO];
    NSString *idtem =[NSString stringWithFormat:@"%d",(int)reminderId];
    NSDictionary*userinfo=recivedNotificaion.userInfo;
    UIApplication *app = [UIApplication sharedApplication];
    
    NSString*SoundSelectedUserReminder =[self retrieveSoundReminderFromUserDefaults];
    
    
    switch (buttonIndex) {
        case (0):
            //primero tengo que cancelar esta notificacion pasada a traves del app delegate y la creo otra ves para snooze
             [Globals cancelAllNotificationsWhitItemID:(int)reminderId];
           [[LocalNotificationCore sharedInstance] handleReceivedNotification:recivedNotificaion];

            
           //just 5 min
            [[LocalNotificationCore sharedInstance]scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:300]text:reminder.reminderName action:@"Show" sound:SoundSelectedUserReminder launchImage:reminder.photoPath andInfo:userinfo ];
            NSLog(@"SNOZZE 5 MIN....IdReminder Creado: %@",idtem);
          
            
            
            [app performSelector:@selector(suspend)];
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:1.0];
            
            //exit app when app is in background
            exit(0);

           
            break;
            case (1):
            //primero tengo que cancelar esta notificacion pasada a traves del app delegate y la creo otra ves para snooze
            [Globals cancelAllNotificationsWhitItemID:(int)reminderId];
            [[LocalNotificationCore sharedInstance] handleReceivedNotification:recivedNotificaion];
            
            [[LocalNotificationCore sharedInstance]scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:600]text:reminder.reminderName action:@"Show" sound:SoundSelectedUserReminder launchImage:reminder.photoPath andInfo:userinfo];
            
          
            [app performSelector:@selector(suspend)];
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:1.0];
            
            //exit app when app is in background
            exit(0);

            case 2:
            //primero tengo que cancelar esta notificacion pasada a traves del app delegate y la creo otra ves para snooze
            [Globals cancelAllNotificationsWhitItemID:(int)reminderId];
            [[LocalNotificationCore sharedInstance] handleReceivedNotification:recivedNotificaion];
            
            [[LocalNotificationCore sharedInstance]scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:900]text:reminder.reminderName action:@"Show" sound:SoundSelectedUserReminder launchImage:reminder.photoPath andInfo:userinfo];
            
           
            [app performSelector:@selector(suspend)];
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:1.0];
            
            //exit app when app is in background
            exit(0);

        default:
            break;
    }


}

- (IBAction)DoneReminder:(id)sender {
    
    NSDictionary*userinfo=recivedNotificaion.userInfo;
    NSString*isRecurringValue= [userinfo objectForKey:@"RECURRING"];
    NSString*IdreminderRecivedNotification= [userinfo objectForKey:@"ID_NOT_PASS"];
    
    NSLog(@"is isRecurringValue recivida en Done: %@ ",isRecurringValue);
    if ([isRecurringValue isEqualToString:@"day"]||[isRecurringValue isEqualToString:@"week"]||[isRecurringValue isEqualToString:@"month"]||[isRecurringValue isEqualToString:@"year"] ) {
        //primero tengo que cancelar esta notificacion pasada a traves del app delegate
        [Globals cancelAllNotificationsWhitItemID:(int)reminderId];
        [[LocalNotificationCore sharedInstance] handleReceivedNotification:recivedNotificaion];
        //la notificacion es repetitiva asi que la tengo que programar de nuevo..
        [[LocalNotificationCore sharedInstance] scheduleNotificationRecurring:recivedNotificaion onRecurrinValue:isRecurringValue];
        
    }else{
        [dao InvalidateReminder:[IdreminderRecivedNotification intValue ]recurring:@"finished"];
//cancel not
        UIApplication*app =[UIApplication sharedApplication];
        [app cancelLocalNotification:recivedNotificaion];
        [[LocalNotificationCore sharedInstance]handleReceivedNotification:recivedNotificaion];
      
        

   }
    //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    
    //wait 2 seconds while app is going background
    [NSThread sleepForTimeInterval:1.0];
    
    //exit app when app is in background
    exit(0);

}

- (IBAction)showNoteAction:(id)sender {
    
     ReminderObject *reminder=[dao getItemwhitServerID:reminderId usingServerId:NO];
    
    // NOTE: maxCount = 0 to hide count
    // self.navigationController.navigationBarHidden=YES;
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc]  initWithPlaceHolder:@"Reminder Note" maxCount:0 buttonStyle:YIPopupTextViewButtonStyleRightCancel ];
    popupTextView.delegate = self;
    // popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    popupTextView.keyboardAppearance=UIKeyboardAppearanceDefault;
    popupTextView.text = reminder.note;
    popupTextView.textAlignment = NSTextAlignmentJustified;
    
    popupTextView.editable = NO;                  // set editable=NO to show without keyboard
    
    //[popupTextView showInView:self.view];
    [popupTextView showInViewController:self]; // recommended, especially for iOS7
}

- (IBAction)Play:(id)sender {
    
    payl = [self.voiceHud playSound:audioPath];
}
@end
