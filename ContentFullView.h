//
//  ContentFullView.h
//  PhotoReminderNew
//
//  Created by User on 01.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentFullView : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *FullImageView;

@property (weak, nonatomic) IBOutlet UILabel *ItemNameLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@end
