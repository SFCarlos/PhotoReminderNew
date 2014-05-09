//
//  POVoiceHUD.h
//  PhotoReminder
//
//  Created by User on 11.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "POVoiceHUDDelegate.h"

#define HUD_SIZE 270
#define CANCEL_BUTTON_HEIGHT 50
#define SOUND_METER_COUNT 40
#define WAVE_UPDATE_FREQUENCY 0.05

@interface POVoiceHUD : UIView <AVAudioRecorderDelegate> {
    UIButton *btnCancel;
    UIImage *imgMicrophone;
    int soundMeters[40];
    CGRect hudRect;
    
    NSMutableDictionary *recordSetting;
    NSString *recorderFilePath;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    SystemSoundID soundID;
    NSTimer *timer;
    
    float recordTime;
}

- (id)initWithParentView:(UIView *)view;

- (void)startForFilePath:(NSString *)filePath;
- (void)cancelRecording;
-(AVAudioPlayer*)playSound:(NSString*)filePath;
- (void)setCancelButtonTitle:(NSString *)title;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, assign) id<POVoiceHUDDelegate> delegate;

@end
