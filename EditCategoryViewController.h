//
//  EditCategoryViewController.h
//  PhotoReminderNew
//
//  Created by User on 15.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"

@interface EditCategoryViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIView *Pickercontainer;
@property (nonatomic) NSInteger * IdCategoryToEdit ;
@property (nonatomic, strong) DatabaseHelper *dao;

@end
