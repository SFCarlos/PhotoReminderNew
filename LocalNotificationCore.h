//
//  LocalNotificationCore.h
//  PhotoReminder
//
//  Created by User on 14.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationScreenController.h"
@interface LocalNotificationCore : NSObject{
    int _badgeCount;
    
}
+ (LocalNotificationCore*) sharedInstance;
@property int badgeCount;

- (void) scheduleNotificationOn:(NSDate*) fireDate
                           text:(NSString*) alertText
                         action:(NSString*) alertAction
                          sound:(NSString*) soundfileName
                    launchImage:(NSString*) launchImage
                      
                        andInfo:(NSDictionary*) userInfo;

- (void) handleReceivedNotification:(UILocalNotification*) thisNotification;
-(void)scheduleNotificationRecurring:(UILocalNotification*) thisNotificationRecurring onRecurrinValue:(NSString*) recurringvalue;
- (void) decreaseBadgeCountBy:(int) count;
- (void) clearBadgeCount;
@end
