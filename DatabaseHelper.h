//
//  DatabaseHelper.h
//  ReminderAplication
//
//  Created by User on 04.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ReminderObject.h"
@interface DatabaseHelper : NSObject{
    
    sqlite3 *bd;
    
}
- (NSMutableArray *) getCategoryList;
-(NSMutableArray * ) getReminderList:(NSInteger *) CategoryId;
-(NSArray*) getHistoryList:(NSInteger*) CategoryId;
-(NSInteger *) getCountReminderInCategory:(NSInteger *) CategoryId;
- (NSString *) getRutaBD;

-(NSInteger *)insertReminder:(NSInteger*)idCat eventname:(NSString*)EventName alarm:(NSDate*)Alarm photopath:(NSString*)photoPath audiopath:(NSString*)audioPath note:(NSString*)note recurring:(NSString*)recurring;
-(BOOL)insertHistory:(NSInteger*)idCat history_desc:(NSString*)history_descripcion;
-(ReminderObject*)getReminder:(NSInteger*) IDreminder;
-(NSString*)getHexColorFronCategory:(NSInteger*)categotyId;
-(NSString*)getCategoryName:(NSInteger*)categotyId;
-(BOOL)deleteReminder:(NSInteger*) id_rem;
-(BOOL)InvalidateReminder:(NSInteger*) id_rem recurring:(NSString*)recurring;
-(BOOL)insertCategory:(NSString*)catName colorPic:(NSString*)colorPic;
-(BOOL)deleteCategory:(NSInteger*)id_cat;
@end
