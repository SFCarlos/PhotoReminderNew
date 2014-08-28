//
//  EditCategoryViewController.h
//  PhotoReminderNew
//
//  Created by User on 15.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "iOSServiceProxy.h"
#import "ColorPickerImageView.h"



@interface EditCategoryViewController : UIViewController<Wsdl2CodeProxyDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet ColorPickerImageView *Pickercontainer;
@property (strong, nonatomic) IBOutlet UIImageView *imagenPICKER;
@property (nonatomic) NSInteger * IdCategoryToEdit ;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typeSegmentedContlos;
@property (nonatomic, strong) DatabaseHelper *dao;
@property (weak, nonatomic) IBOutlet UIButton *selectedButomcolor;

/////*********ColorPicker*********
@property (weak, nonatomic) IBOutlet UIButton *color1;

- (IBAction)color1Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color2;
- (IBAction)color2Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color3;
- (IBAction)color3Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color4;
- (IBAction)color4Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color5;
- (IBAction)color5Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color6;
- (IBAction)color6Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color7;
- (IBAction)color7Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color8;
- (IBAction)color8Action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *color9;
- (IBAction)color9Action:(id)sender;

/////*********ColorPicker*********

@end
