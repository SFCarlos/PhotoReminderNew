//
//  AppDelegate.h
//  PhotoReminderNew
//
//  Created by User on 09.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;
@end
