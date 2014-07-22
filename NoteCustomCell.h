//
//  NoteCustomCell.h
//  PhotoReminderNew
//
//  Created by User on 02.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWTableViewCell.h"
@interface NoteCustomCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *hasRecorButton;
@property (strong, nonatomic) IBOutlet UILabel *shoopingItemDescrip;
@end
