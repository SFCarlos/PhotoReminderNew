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
@interface NotificationScreenController ()

@end

@implementation NotificationScreenController{
DatabaseHelper *dao;
    AVAudioPlayer * payl;
    int IntervalSnooze;
   
}
@synthesize recivedNotificaion;
@synthesize playButton;
@synthesize showNoteButton;
@synthesize reminderId;
@synthesize dao;
@synthesize reminderObj;
@synthesize ImagenShowNotification;
@synthesize eventName;
@synthesize categoryName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    dao = [[DatabaseHelper alloc] init];
    NSLog(@"%d Este es el Id en Screen ",(int)reminderId);
    ReminderObject *reminder=[dao getReminder:reminderId];
   
    ImagenShowNotification.image =[UIImage imageWithContentsOfFile:reminder.photoPath];
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    eventName.text=reminder.reminderName;
    NSLog(@"ESTE ES la categoria %d",reminder.cat_id);
    NSString* category_name = [dao getCategoryName:reminder.cat_id];
    categoryName.text = category_name;
    if(ImagenShowNotification.image == nil){
        categoryName.textColor = [UIColor blackColor];
        ImagenShowNotification.image = [UIImage imageNamed:@"noimage.jpg"];
    }
    
    
    NSString * audioPath = reminder.audioPath;
    NSString * note = reminder.note;
    NSLog(@"ESTE ES EL .caf para reproducir: %@",audioPath);
    
    
    if (audioPath == nil || audioPath.length < 10 ) {
        playButton.hidden = YES;
    }
    if ( note == nil ||[note isEqualToString:@""]||[note isEqualToString:@"(null)"]) {
        showNoteButton.hidden = YES;
    }

    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    
    
     ReminderObject *reminder=[dao getReminder:reminderId];
    NSString *idtem =[NSString stringWithFormat:@"%d",(int)reminderId];
    NSDictionary*userinfo=recivedNotificaion.userInfo;
   NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:idtem,@"ID_NOT_PASS" ,reminder.recurring,@"RECURRING",  nil];    UIApplication *app = [UIApplication sharedApplication];
    
    NSString*SoundSelectedUserReminder =[self retrieveSoundReminderFromUserDefaults];
    
    
    switch (buttonIndex) {
        case (0):
           //just 5 min
            [[LocalNotificationCore sharedInstance]scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:300]text:reminder.reminderName action:@"Show" sound:SoundSelectedUserReminder launchImage:reminder.photoPath andInfo:data ];
            NSLog(@"SNOZZE 5 MIN....IdReminder Creado: %@",idtem);
          
            
            
            [app performSelector:@selector(suspend)];
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:1.0];
            
            //exit app when app is in background
            exit(0);

           
            break;
            case (1):
            [[LocalNotificationCore sharedInstance]scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:600]text:reminder.reminderName action:@"Show" sound:SoundSelectedUserReminder launchImage:reminder.photoPath andInfo:data];
            
          
            [app performSelector:@selector(suspend)];
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:1.0];
            
            //exit app when app is in background
            exit(0);

            case 2:
            [[LocalNotificationCore sharedInstance]scheduleNotificationOn:[NSDate dateWithTimeIntervalSinceNow:900]text:reminder.reminderName action:@"Show" sound:SoundSelectedUserReminder launchImage:reminder.photoPath andInfo:data];
            
           
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
    //en appdelegate siempre cancelo las ntifiaciones
    NSDictionary*userinfo=recivedNotificaion.userInfo;
    NSString*isRecurringValue= [userinfo objectForKey:@"RECURRING"];
    NSString*IdreminderRecivedNotification= [userinfo objectForKey:@"ID_NOT_PASS"];
    
    if (![isRecurringValue isEqualToString:@"none"]) {
        
        [[LocalNotificationCore sharedInstance] scheduleNotificationRecurring:recivedNotificaion onRecurrinValue:isRecurringValue];
        
    }else{
        [dao InvalidateReminder:[IdreminderRecivedNotification intValue ]recurring:@"finished"];
//cancel not
        UIApplication*app =[UIApplication sharedApplication];
       
                [app cancelLocalNotification:recivedNotificaion];
      
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++) {
            UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
            NSDictionary *userInfoIDremin = oneEvent.userInfo;
            NSInteger*uid=(NSInteger*)[[userInfoIDremin objectForKey:@"ID_NOT_PASS"] integerValue];
            if (uid == [IdreminderRecivedNotification intValue]) {
                [app cancelLocalNotification:oneEvent];
                NSLog(@"DONE REMINDER...Id del reminder cancelado %d",uid);
            }
        }
        

   }
    
    
    
    //case exit elimino de la database
    //[dao deleteReminder:reminderId];
        //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    
    //wait 2 seconds while app is going background
    [NSThread sleepForTimeInterval:1.0];
    
    //exit app when app is in background
    exit(0);

}

- (IBAction)showNoteAction:(id)sender {
    
     ReminderObject *reminder=[dao getReminder:reminderId];
    
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
    ReminderObject *reminder=[dao getReminder:reminderId];
    payl = [self.voiceHud playSound:reminder.audioPath];
}
@end
