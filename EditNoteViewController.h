//
//  EditNoteViewController.h
//  PhotoReminderNew
//
//  Created by User on 04.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "POVoiceHUD.h"
#import "DatabaseHelper.h"
@interface EditNoteViewController : UIViewController<UITextViewDelegate,POVoiceHUDDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITextView *NotetextArea;
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewSelected;
@property (nonatomic, retain) POVoiceHUD *voiceHud;
@property (weak, nonatomic) IBOutlet UIImageView *marco;
@property (nonatomic, strong) DatabaseHelper *dao;
@property NSInteger* idNoteToedit;
- (IBAction)cameraAction:(id)sender;
- (IBAction)recordAction:(id)sender;

@end
