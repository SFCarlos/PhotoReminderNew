//
//  SelectedItemFotoFullViewController.h
//  PhotoReminderNew
//
//  Created by User on 03.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
@interface SelectedItemFotoFullViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *FullPhoto;
@property (nonatomic, strong) DatabaseHelper *dao;
@property NSUInteger IdNote;
@property NSString* ShoppTile;
@end
