//
//  ReminderObject.h
//  ReminderAplication
//
//  Created by User on 04.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReminderObject : NSObject
@property (nonatomic, assign) NSInteger reminderID;
@property (nonatomic, strong) NSString *reminderName;
@property (nonatomic, strong) NSString *photoPath;
@property (nonatomic, strong) NSString *audioPath;
@property(nonatomic,strong) NSDate * alarm;

@property(nonatomic,assign)NSInteger *cat_id;
@property(nonatomic,assign)NSInteger *cat_id_server;
@property(nonatomic,strong)NSString *client_status;

@property (nonatomic, assign) NSInteger *categoryType;
@property(nonatomic,strong) NSString * categoryName;
@property(nonatomic,strong) NSString * categoryImagenPic;
@property(nonatomic,strong) NSString * categoryColorPic;
@property(nonatomic,strong) NSString * note;
@property(nonatomic,strong) NSString * recurring;
@end
