//
//  GirdShoopingViewController.h
//  PhotoReminderNew
//
//  Created by User on 27.06.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
@interface GirdShoopingViewController : UICollectionViewController
@property (nonatomic, strong) DatabaseHelper *dao;
@end
