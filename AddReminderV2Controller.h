//
//  AddReminderV2Controller.h
//  PhotoReminder
//
//  Created by User on 28.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "HTAutocompleteTextField.h"
#import "POVoiceHUD.h"

@interface AddReminderV2Controller : UIViewController <UITextFieldDelegate,POVoiceHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *colorband1;
- (IBAction)showcalendatButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *MyScroll;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectRepeat;
@property (strong, nonatomic) IBOutlet UIButton *calendarbutom;
@property (strong, nonatomic) IBOutlet UILabel *colorband2;
@property (strong, nonatomic) IBOutlet UILabel *colorband3;
@property (strong, nonatomic) IBOutlet UIView *DatePickerContainer;
@property (nonatomic, strong) DatabaseHelper *dao;
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewSelected;
//@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *frameButton;
@property (nonatomic, retain) POVoiceHUD *voiceHud;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *EventNametextField;

@property (nonatomic, strong) NSDate *dateSelectedFromCalendar;
@end
