//
//  POVoiceHUDDelegate.h
//  PhotoReminder
//
//  Created by User on 11.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class POVoiceHUD;

@protocol POVoiceHUDDelegate <NSObject>

@optional

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength;
- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD;

@end

