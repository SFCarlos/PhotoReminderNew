//
//  FullScreemPageItemViewController.h
//  PhotoReminderNew
//
//  Created by User on 01.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"
@interface FullScreemPageItemViewController : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *pageTitles;
@property (strong, nonatomic) NSMutableArray *pageImages;
@property NSUInteger indexPhotoToShowFirt;


@property (nonatomic, strong) DatabaseHelper *dao;
@end
