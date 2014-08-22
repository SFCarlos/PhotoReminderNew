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
@property(nonatomic,assign)NSInteger *client_status;
@property(nonatomic,assign)NSInteger *orden;
@property(nonatomic,assign)NSInteger *should_send_cat;
@property(nonatomic,assign)NSInteger *should_send_item;

@property(nonatomic,assign)NSInteger *server_file_id;
@property(nonatomic,assign)NSInteger *file_timestamp;
@property (nonatomic, strong)NSString *file_path;
@property(nonatomic,assign)NSInteger * file_type;
@property(nonatomic,assign)NSInteger * server_file_type;
@property(nonatomic,assign)NSInteger *id_file;
@property(nonatomic,assign)NSInteger *should_send_file;


@property(nonatomic,assign)NSInteger *id_server_item;
@property(nonatomic,assign)NSInteger *item_statuss;
@property (nonatomic, assign) NSInteger *categoryType;
@property (nonatomic, assign) NSInteger *cat_timestamp;
@property(nonatomic,strong) NSString * categoryName;
@property(nonatomic,strong) NSString * categoryImagenPic;
@property(nonatomic,strong) NSString * categoryColorPic;
@property(nonatomic,strong) NSString * note;
@property(nonatomic,strong) NSString * recurring;
@end
