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
//*****************new iplementation insert into items **************
-(NSInteger *)insert_item: (NSInteger*)id_cat item_Name:(NSString*)item_Name alarm:(NSDate*)Alarm  note:(NSString*)note repeat:(NSString*)repeat;

-(BOOL)insert_item_images: (NSInteger *)id_cat id_item:(NSInteger*)id_item file_Name:(NSString*)file_Name;
-(BOOL)insert_item_recordings: (NSInteger *)id_cat id_item:(NSInteger*)id_item file_Name:(NSString*)file_Name;
-(ReminderObject*)getItem:(NSInteger*) id_item;
-(ReminderObject*)getCategorie:(NSInteger*) id_cat;
-(BOOL)deleteItem:(NSInteger*) id_item;
-(NSMutableArray*)get_items_PhotoPaths:(NSInteger*)id_item;
-(NSString*)get_AudioPath_item_reminder:(NSInteger*)id_item;
- (NSMutableArray *) getCategoryListwhitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded;
-(NSMutableArray * ) getItemList:(NSInteger *) CategoryId itemType:(NSInteger*)itemType;
-(NSArray*) getHistoryList:(NSInteger*) CategoryId;
-(NSInteger *) getCountItemInCategory:(NSInteger *)CategoryId ;
- (NSString *) getRutaBD;
-(NSInteger*)saveCategoryOrder:(NSMutableArray*) orderOarray;
-(void)updateClientStatus_and_IdServerinCategory:(NSInteger*)Id_cat_client Id_cat_server:(NSInteger*)Id_cat_server clientStatus:(NSString*)clientStatus;


-(NSMutableArray *) getCategoryorder;


-(NSInteger *)insertReminder:(NSInteger*)idCat eventname:(NSString*)EventName alarm:(NSDate*)Alarm photopath:(NSString*)photoPath audiopath:(NSString*)audioPath note:(NSString*)note recurring:(NSString*)recurring;
-(BOOL)insertHistory:(NSInteger*)idCat history_desc:(NSString*)history_descripcion;
-(ReminderObject*)getReminder:(NSInteger*) IDreminder;
-(NSString*)getHexColorFronCategory:(NSInteger*)categotyId;
-(NSString*)getCategoryName:(NSInteger*)categotyId;
-(NSInteger*)getCategoryType:(NSInteger*)categotyId;
-(BOOL)deleteReminder:(NSInteger*) id_rem;
-(BOOL)InvalidateReminder:(NSInteger*) id_rem recurring:(NSString*)recurring;
-(NSInteger*)insertCategory:(NSString*)catName colorPic:(NSString*)colorPic type:(NSInteger*)type client_status:(NSString*)client_status;
-(BOOL)deleteCategory:(NSInteger*)id_cat;
-(BOOL)editCategory:(NSInteger*)id_cat categoryName:(NSString*) categoryName categoryColor:(NSString*) categoryColor type:(NSInteger*)type;
@end
