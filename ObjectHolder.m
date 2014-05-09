//
//  ObjectHolder.m
//  PhotoReminder
//
//  Created by User on 07.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "ObjectHolder.h"
static ObjectHolder *_instance;


@implementation ObjectHolder
@synthesize datePicker =_datePicker;
+ (ObjectHolder*)sharedInstance
{
    @synchronized(self) {
        
        if (_instance == nil) {
            
       _instance = [[super allocWithZone:NULL] init];
        }
        
    }
    return _instance;
}
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
    }
    return _datePicker;
}
@end
