//
//  Globals.m
//  PhotoReminderNew
//
//  Created by User on 12.09.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "Globals.h"
#import "LocalNotificationCore.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation Globals

+ (BOOL)hasConnectivity{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;


}
+(void)cancelAllNotificationsWhitItemID:(NSInteger *)id_item{
    //cancel the notification
    NSString *idtem =[NSString stringWithFormat:@"%d",(int)id_item];
    UIApplication*app =[UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++) {
        UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
        NSDictionary *userInfoIDremin = oneEvent.userInfo;
        NSString*uid=[NSString stringWithFormat:@"%@",[userInfoIDremin valueForKey:@"ID_NOT_PASS"]];
        if ([uid isEqualToString:idtem]) {
            [app cancelLocalNotification:oneEvent];
            NSLog(@"CANCELADA LA NOTIFICACION %@",uid);
            
            
        }
    }




}
+(BOOL)ScheduleSharedNotificationwhitItemId:(NSInteger *)id_item ItemName:(NSString *)Itemname andAlarm:(NSString *)dateFire andRecurring:(NSString *)recurr andStatus:(NSInteger *)itemStatus
{
    if (!([dateFire isEqualToString:@"0000-00-00 00:00"])&& (itemStatus != 1)&& !([recurr isEqualToString:@"finished" ])) {
        //shedule notification
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date3 = [dateFormat dateFromString:dateFire];
        NSString *idtem =[NSString stringWithFormat:@"%d",(int)id_item];
        NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:idtem,@"ID_NOT_PASS" ,recurr,@"RECURRING",  nil];
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSString *sound = nil;
        if (standardUserDefaults)
            sound = [standardUserDefaults objectForKey:@"REMINDER_SOUND"];

        
        //Set notification for firt time to select fire date and repeatin 1 min
        [[LocalNotificationCore sharedInstance]scheduleNotificationOn:date3 text:Itemname action:@"Show" sound: sound launchImage:@"null" andInfo:data];
        return YES;
        
        
    }
    return NO;
}
+(void)saveSoundReminderToUserDefaults:(NSString*)SoundSelected
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:SoundSelected forKey:@"REMINDER_SOUND"];
        [standardUserDefaults synchronize];
    }
    
}


+(NSString*)retrieveSoundReminderFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"REMINDER_SOUND"];
    
    return val;
}


@end
