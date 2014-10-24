//
//  UILabel+dynamicSize.m
//  PhotoReminderNew
//
//  Created by User on 24.10.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "UILabel+dynamicSize.h"

@implementation UILabel (dynamicSize)

- (void) autosizeForWidth: (int) width {
    self.lineBreakMode = UILineBreakModeWordWrap;
    self.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    CGSize expectedLabelSize = [self.text sizeWithFont:self.font constrainedToSize:maximumLabelSize lineBreakMode:self.lineBreakMode];
    CGRect newFrame = self.frame;
    newFrame.size.height = expectedLabelSize.height;
    self.frame = newFrame;
   
}
@end
