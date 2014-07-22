//
//  ShoppingItemCustomCell.h
//  PhotoReminderNew
//
//  Created by User on 26.06.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface ShoppingItemCustomCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *shoopingItemDescrip;
@end
