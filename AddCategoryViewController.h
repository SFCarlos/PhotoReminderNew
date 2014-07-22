//
//  AddCategoryViewController.h
//  PhotoReminder
//
//  Created by User on 08.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
#import "iOSServiceProxy.h"

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate,Wsdl2CodeProxyDelegate>
@property (strong, nonatomic) IBOutlet UITextField *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIView *Pickercontainer;

@property (nonatomic, strong) DatabaseHelper *dao;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typesegmentedControl;


//***** color picker******
@property (weak, nonatomic) IBOutlet UIButton *selectedButomcolor;

@property (weak, nonatomic) IBOutlet UIButton *color1;
- (IBAction)color1:(id)sender;
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

@end
