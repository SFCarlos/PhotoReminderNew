//
//  EditReminderViewController.h
//  PhotoReminder
//
//  Created by User on 25.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "POVoiceHUD.h"
#import "HTAutocompleteTextField.h";
@interface EditReminderViewController : UIViewController <UITextFieldDelegate,POVoiceHUDDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *myScroll;
@property (strong, nonatomic) IBOutlet UILabel *colorband1;
- (IBAction)showcalendatButton:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectRepeat;
@property (strong, nonatomic) IBOutlet UIButton *calendarbutom;
@property (strong, nonatomic) IBOutlet UILabel *colorband2;
@property (strong, nonatomic) IBOutlet UILabel *colorband3;
@property (strong, nonatomic) IBOutlet UIView *datePickerContainer;
@property (nonatomic, strong) DatabaseHelper *dao;
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewSelected;
//@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *frameButton;
@property (nonatomic, retain) POVoiceHUD *voiceHud;
@property (strong, nonatomic) ReminderObject * ReminderToEdit;
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *EventNametextField;

@property (nonatomic, strong) NSDate *dateSelectedFromCalendar;
@end

