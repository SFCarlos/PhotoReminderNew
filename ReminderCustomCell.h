//
//  ReminderCustomCell.h
//  PhotoReminder
//
//  Created by User on 08.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface ReminderCustomCell : SWTableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *ReminderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *completedLabel;
@property (strong, nonatomic) IBOutlet UILabel *descritionLabel;
@property (strong, nonatomic) IBOutlet UIButton *framebuttom;
@property (strong, nonatomic) IBOutlet UILabel *recurringLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hasVoice;

@end
