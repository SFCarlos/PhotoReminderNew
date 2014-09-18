//
//  Globals.h
//  PhotoReminderNew
//
//  Created by User on 12.09.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Globals : NSObject{}

+(BOOL)hasConnectivity;
+(void )cancelAllNotificationsWhitItemID:(NSInteger*)id_item;
+(BOOL)ScheduleSharedNotificationwhitItemId:(NSInteger*)id_item ItemName:(NSString*)Itemname andAlarm:(NSString*)dateFire andRecurring:(NSString*)recurr andStatus:(NSInteger*)itemStatus;
+(void)saveSoundReminderToUserDefaults:(NSString*)SoundSelected;
+(NSString*)retrieveSoundReminderFromUserDefaults;
@end
