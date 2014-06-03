//
//  AddCategoryViewController.h
//  PhotoReminder
//
//  Created by User on 08.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIView *Pickercontainer;

@property (nonatomic, strong) DatabaseHelper *dao;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typesegmentedControl;

@end
