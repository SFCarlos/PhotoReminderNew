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
-(NSInteger *)insert_item: (NSInteger*)id_cat item_Name:(NSString*)item_Name alarm:(NSDate*)alarm  note:(NSString*)note repeat:(NSString*)repeat itemclientStatus:(NSInteger *)itemclientStatus should_send_item:(NSInteger *)should_send_item;

-(BOOL)edit_item:(NSInteger*)id_item item_Name:(NSString*)item_Name alarm:(NSDate*)alarm  note:(NSString*)note repeat:(NSString*)repeat itemclientStatus:(NSInteger *)itemclientStatus;

-(NSInteger*)insert_item_images: (NSInteger *)id_cat id_item:(NSInteger*)id_item file_Name:(NSString*)file_Name;
-(NSInteger*)insert_item_recordings: (NSInteger *)id_cat id_item:(NSInteger*)id_item file_Name:(NSString*)file_Name;
-(BOOL)edit_item_images:(NSInteger*)id_item file_Name:(NSString*)file_Name;
-(BOOL)edit_item_recordings:(NSInteger*)id_item file_Name:(NSString*)file_Name;

-(NSMutableArray*)getFiles:(NSInteger*) id_item;
-(ReminderObject*)getItemwhitServerID:(NSInteger*) id_item usingServerId:(BOOL)usingServerId;
-(ReminderObject*)getCategorieWhitServerID:(NSInteger*) id_cat usingServerId:(BOOL)usingServerId;
-(BOOL)deleteItem:(NSInteger*) id_item permanently:(BOOL)permanently;
-(BOOL)deleteFiles:(NSInteger*) id_file permanently:(BOOL)permanently;
-(NSMutableArray*)get_items_PhotoPaths:(NSInteger*)id_item;
-(NSString*)get_AudioPath_item_reminder:(NSInteger*)id_item;
- (NSMutableArray *) getCategoryListwhitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded;
-(NSMutableArray * ) getItemListwhitDeletedRowsIncluded:(NSInteger *) CategoryId itemType:(NSInteger*)itemType whitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded;
-(NSMutableArray * ) getFilesListwhitDeletedRowsIncluded:(NSInteger*)fileType whitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded;


-(NSArray*) getHistoryList:(NSInteger*) CategoryId;

-(NSInteger *) getCountItemInCategory:(NSInteger *)CategoryId ;
- (NSString *) getRutaBD;
-(NSInteger*)saveCategoryOrder:(NSMutableArray*) orderOarray;

-(void)updateSTATUSandSHOULDSENDInTable:(NSInteger*)id_client clientStatus:(NSInteger*)clientStatus should_send:(NSInteger*)should_send tableName:(NSString*)tableName;

-(void)UpdateSERVERIDinTable:(NSInteger*)id_client id_server:(NSInteger*)id_server tableName:(NSString*)tableName ;

-(void)UpdateFileTIMESTAMP:(NSInteger*)id_client file_timestamp:(NSInteger*)file_timestamp ;
-(void)UpdateSHOULDSendinFILESbyType:(NSInteger*)id_item  file_type:(NSInteger*)file_type should_send:(NSInteger*)should_send comeFroMSync:(BOOL*)comeFroMSync;

-(BOOL)updateorden:(NSInteger*)id_cat orden:(NSInteger*)orden;;
-(NSMutableArray *) getCategoryorder;
-(NSInteger*)insertCategory:(NSString*)catName colorPic:(NSString*)colorPic type:(NSInteger*)type client_status:(NSInteger*)client_status should_send_cat:(NSInteger*)should_send_cat;

-(NSInteger *)insertReminder:(NSInteger*)idCat eventname:(NSString*)EventName alarm:(NSDate*)Alarm photopath:(NSString*)photoPath audiopath:(NSString*)audioPath note:(NSString*)note recurring:(NSString*)recurring;
-(BOOL)insertHistory:(NSInteger*)idCat history_desc:(NSString*)history_descripcion;
-(ReminderObject*)getReminder:(NSInteger*) IDreminder;
-(NSString*)getHexColorFronCategory:(NSInteger*)categotyId;
-(NSString*)getCategoryName:(NSInteger*)categotyId;
-(NSInteger*)getCategoryType:(NSInteger*)categotyId;
-(BOOL)deleteReminder:(NSInteger*) id_rem;
-(BOOL)InvalidateReminder:(NSInteger*) id_rem recurring:(NSString*)recurring;

-(BOOL)deleteCategory:(NSInteger*)id_cat permanently:(BOOL)permanently;
-(BOOL)editCategory:(NSInteger*)id_cat categoryName:(NSString*) categoryName categoryColor:(NSString*) categoryColor type:(NSInteger*)type;
@end
