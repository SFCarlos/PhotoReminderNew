//
//  ContentFullView.m
//  PhotoReminderNew
//
//  Created by User on 01.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "ContentFullView.h"

@interface ContentFullView ()

@end

@implementation ContentFullView

@synthesize ItemNameLabel;
@synthesize FullImageView;
@synthesize imageFile;
@synthesize titleText;


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    if ([self.imageFile length] > 10) {// the is fileimage
        self.FullImageView.image = [UIImage imageWithContentsOfFile:self.imageFile];

    }else
    self.FullImageView.image = [UIImage imageNamed:self.imageFile];
    self.ItemNameLabel.text = self.titleText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
