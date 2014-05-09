//
//  ObjectHolder.h
//  PhotoReminder
//
//  Created by User on 07.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectHolder : NSObject

//Using to sharedInstance singelton to datepiker
@property (strong,nonatomic) UIDatePicker *datePicker;
+ (ObjectHolder*) sharedInstance;
-(UIDatePicker *)datePicker;
@end
