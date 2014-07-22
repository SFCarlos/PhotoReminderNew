//
//  CategoryCustomCell.h
//  PhotoReminderNew
//
//  Created by User on 27.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface CategoryCustomCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *colorlabel;
@property (strong, nonatomic) IBOutlet UIButton *reminderListButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryNameButon;

@property (strong, nonatomic) IBOutlet UIButton *iconbutonType;


@end
