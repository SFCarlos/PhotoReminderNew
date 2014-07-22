//
//  EditShoopingItemViewController.h
//  PhotoReminderNew
//
//  Created by User on 03.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAutocompleteTextField.h"
#import "DatabaseHelper.h"
@interface EditShoopingItemViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet HTAutocompleteTextField *nameitemTextField;
@property NSInteger* IdShoopingItemToEdit;
@property (weak, nonatomic) IBOutlet UIButton *camerabutton;
@property (weak, nonatomic) IBOutlet UIButton *gallerybuton;
- (IBAction)cameraButonAction:(id)sender forEvent:(UIEvent *)event;
- (IBAction)galleryButonAction:(id)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *frameButon;
@property (weak, nonatomic) IBOutlet UIImageView *fotoselectedImageview;


@property (nonatomic, strong) DatabaseHelper *dao;

@end
