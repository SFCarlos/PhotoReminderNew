//
//  LocalNotificationCore.m
//  PhotoReminder
//
//  Created by User on 14.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "LocalNotificationCore.h"
#import "AppDelegate.h"

static LocalNotificationCore *_instance;
@implementation LocalNotificationCore

@synthesize badgeCount =_badgeCount;
+ (LocalNotificationCore*)sharedInstance
{
    @synchronized(self) {
        
        if (_instance == nil) {
            
            // iOS 4 compatibility check
            Class notificationClass = NSClassFromString(@"UILocalNotification");
            
            if(notificationClass == nil)
            {
                _instance = nil;
            }
            else
            {	
                _instance = [[super allocWithZone:NULL] init];	
                _instance.badgeCount = 0;
            }
        }
    }
    return _instance;
}
-(void)scheduleNotificationOn:(NSDate *)fireDate text:(NSString *)alertText action:(NSString *)alertAction sound:(NSString *)soundfileName launchImage:(NSString *)launchImage  andInfo:(NSDictionary *)userInfo{
 
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSLog(@"scheduleNotificationOn: %@", [dateFormat stringFromDate:fireDate]);
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertText;
    localNotification.alertAction = alertAction;
    //it will repeat every minute:(
    localNotification.repeatInterval=NSMinuteCalendarUnit;
    
    if(soundfileName == nil)
    {
        localNotification.soundName = UILocalNotificationDefaultSoundName;
    }
    else
    {
        NSString* SoundWhitCaf = [NSString stringWithFormat:@"%@.m4r",soundfileName];

        localNotification.soundName = SoundWhitCaf;
    }
    
    localNotification.alertLaunchImage = launchImage;
    
    self.badgeCount ++;
    localNotification.applicationIconBadgeNumber = self.badgeCount;
    localNotification.userInfo = userInfo;
    
    // Schedule it with the app
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];


}
-(void)scheduleNotificationRecurring:(UILocalNotification *)thisNotificationRecurring onRecurrinValue:(NSString *)recurringvalue{
    NSDateComponents *datecomponenets = [[NSDateComponents alloc]init];
    NSCalendar*cal = [NSCalendar currentCalendar];
    
    NSDate * firedateTemp;
    //copi not values
    UILocalNotification* notirecurring = thisNotificationRecurring;
    //acces to original date
    NSDictionary *data =notirecurring.userInfo;
    NSDate * originaldate = [data objectForKey:@"ORIGINALDATE"];
     if ([recurringvalue isEqualToString:@"day"]){
        [datecomponenets setDay:1];
        
    }else if ([recurringvalue isEqualToString:@"week"]){
        [datecomponenets setWeek:1];
    }else if ([recurringvalue isEqualToString:@"month"]){
        [datecomponenets setMonth:1];
    }else if ([recurringvalue isEqualToString:@"year"]){
        [datecomponenets setYear:1];
    }
    
    firedateTemp= [cal dateByAddingComponents:datecomponenets toDate:originaldate options:0];
    notirecurring.fireDate = firedateTemp;
    notirecurring.applicationIconBadgeNumber = self.badgeCount;

    // la reprogramo
    [[UIApplication sharedApplication] scheduleLocalNotification:notirecurring];


}
- (void) clearBadgeCount
{
    self.badgeCount = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) decreaseBadgeCountBy:(int) count
{
    self.badgeCount -= count;
    if(self.badgeCount < 0) self.badgeCount = 0;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.badgeCount;
}

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification
{
    NSLog(@"Received: %@",[thisNotification description]);
   
        
    [self decreaseBadgeCountBy:1];
}
@end
