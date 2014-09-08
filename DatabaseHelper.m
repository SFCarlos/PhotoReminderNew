//
//  DatabaseHelper.m
//  ReminderAplication
//
//  Created by User on 04.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "DatabaseHelper.h"

@implementation DatabaseHelper
- (NSString *) getRutaBD{
    NSString *dirDocs;
    NSArray *rutas;
    NSString *rutaBD;
    
    rutas = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dirDocs = [rutas objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    rutaBD = [[NSString alloc] initWithString:[dirDocs stringByAppendingPathComponent:@"AppDatabase.sqlite"]];
    
    if([fileMgr fileExistsAtPath:rutaBD] == NO){
        [fileMgr copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AppDatabase.sqlite"] toPath:rutaBD error:NULL];
    }
    //NSLog(@"rutaBd %@",rutaBD);
    return rutaBD;
}
-(ReminderObject*) getCategorieWhitServerID:(NSInteger *)id_cat usingServerId:(BOOL)usingServerId{
    ReminderObject * rema = [[ReminderObject alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    NSString *selecting;
    if (usingServerId) {
        selecting =[NSString stringWithFormat:@"SELECT id_cat,id_cat_server, category_name,imagePic,colorPic,type,client_status FROM categories WHERE id_cat_server = %d", (int)id_cat];
    }else{
    selecting =[NSString stringWithFormat:@"SELECT id_cat,id_cat_server, category_name,imagePic,colorPic,type,client_status FROM categories WHERE id_cat = %d", (int)id_cat];
    }
    
    
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en getcategorie");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        rema.cat_id = sqlite3_column_int(sqlStatement, 0);
       
        rema.cat_id_server = sqlite3_column_int(sqlStatement, 1);
        rema.categoryName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        
        rema.categoryImagenPic = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        rema.categoryColorPic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
        rema.categoryType = sqlite3_column_int(sqlStatement,5);
        NSString * valuestringinDB = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
        rema.client_status = [valuestringinDB intValue];
    }
    
    return rema;
    




}
-(NSMutableArray *) getFilesListwhitDeletedRowsIncluded:(NSInteger *)fileType whitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded{
    NSMutableArray *listaR = [[NSMutableArray alloc] init];
    
    NSString *ubicacionDB = [self getRutaBD];
    const char *sentenciaSQL;
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    if (whitDeletedRowsIncluded) {
        sentenciaSQL = "SELECT a.id_file,a.id_cat,a.id_item,a.file_name,a.server_file_id,a.should_send_file,a.client_status_file,a.file_type,file_timestamp,(SELECT id_server_item FROM items b WHERE a.id_item = b.id_item LIMIT 1) server_item_id FROM item_files a";
    }else{
        sentenciaSQL = "SELECT a.id_file,a.id_cat,a.id_item,a.file_name,a.server_file_id,a.should_send_file,a.client_status_file,a.file_type,file_timestamp ,(SELECT id_server_item FROM items b WHERE a.id_item = b.id_item LIMIT 1) server_item_id FROM item_files a WHERE a.client_status_file != 1 ";
    }
    
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement select files");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        ReminderObject * rema = [[ReminderObject alloc] init];
        rema.id_file = sqlite3_column_int(sqlStatement, 0);
        rema.cat_id = sqlite3_column_int(sqlStatement, 1);
        
        rema.reminderID = sqlite3_column_int(sqlStatement, 2);
        rema.file_path = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)];
        rema.server_file_id = sqlite3_column_int(sqlStatement, 4);
        rema.should_send_file=sqlite3_column_int(sqlStatement, 5);
        rema.client_status=sqlite3_column_int(sqlStatement, 6);
        rema.file_type =sqlite3_column_int(sqlStatement, 7);
        rema.file_timestamp = sqlite3_column_int(sqlStatement, 8);
        rema.id_server_item = sqlite3_column_int(sqlStatement, 9);
        
        [listaR addObject:rema];
        
        
    }
   
    return listaR;



}
- (NSMutableArray *) getCategoryListwhitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded{
  
NSMutableArray *listaR = [[NSMutableArray alloc] init];
    
        NSString *ubicacionDB = [self getRutaBD];
    const char *sentenciaSQL;
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    if (whitDeletedRowsIncluded) {
        sentenciaSQL = "SELECT id_cat, category_name,imagePic,colorPic,type,client_status,id_cat_server,orden,should_send_cat FROM categories ORDER BY orden";
    }else{
   sentenciaSQL = "SELECT id_cat, category_name,imagePic,colorPic,type,client_status,id_cat_server,orden,should_send_cat FROM categories WHERE client_status != 1 ORDER BY orden";
    }
    
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement select categories");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        ReminderObject * rema = [[ReminderObject alloc] init];
        rema.cat_id = sqlite3_column_int(sqlStatement, 0);
        rema.categoryName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
      
        rema.categoryImagenPic = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        rema.categoryColorPic = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        rema.categoryType = sqlite3_column_int(sqlStatement,4);
        
        rema.client_status = sqlite3_column_int(sqlStatement,5);
        rema.cat_id_server = sqlite3_column_int(sqlStatement,6);
        rema.orden = sqlite3_column_int(sqlStatement,7);
        
        rema.should_send_cat = sqlite3_column_int(sqlStatement,8);
        [listaR addObject:rema];
        
    
    }
                
    
       

    return listaR;
}
-(BOOL)updateorden:(NSInteger *)id_cat orden:(NSInteger *)orden{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlUpdate= [NSString stringWithFormat:@"UPDATE categories SET orden= %d WHERE id_cat = %d",(int)orden,(int)id_cat];
        const char *sql = [sqlUpdate UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement update ordencategory");
            flag = NO;
            return flag;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                return flag;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    
    return flag;
    


}
//gifme the orden
-(NSMutableArray*)retrieveORDENFromUserDefaults{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"ORDENARRAY"];
    
    return val;
    
}

-(NSInteger*)saveCategoryOrder:(NSMutableArray *)orderOarray{
    BOOL flagdelete = YES;
    BOOL*OK;
    NSInteger *idOreder;
    NSString *ubicacionDB = [self getRutaBD];
  //firt erase the table
   if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flagdelete = NO;
       
    } else {
        NSString *sqlDelete = @"DELETE FROM category_order" ;
        const char *sql = [sqlDelete UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete category_order");
            flagdelete = NO;
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                flagdelete = YES;
                
                //sqlite3_close(bd);
                
            }
        }
        if(flagdelete){
            //NSLog(@"amanno del array con orden %d",[orderOarray count]);
            for (NSString* oreder in orderOarray)
        {
               // NSString* oreder= [orderOarray objectAtIndex:i];
                        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO category_order ('order','id_cat') VALUES (%d,%d)",[oreder intValue], -1];
            const char *sql = [sqlInsert UTF8String];
            sqlite3_stmt *sqlStatement;
            
            if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problema al preparar el statement insert rcategory_order");
                OK=NO;
               
            } else {
                if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                    idOreder =   (NSInteger*)sqlite3_last_insert_rowid(bd);
                    sqlite3_finalize(sqlStatement);
                    OK=YES;
                    
                    //sqlite3_close(bd);
                    
                }
            
            }
        }
        
        
            
        
    }
}
    
  
    return OK;


}

-(NSInteger*)insert_item:(NSInteger *)id_cat item_Name:(NSString *)item_Name alarm:(NSDate *)alarm note:(NSString *)note repeat:(NSString *)repeat itemclientStatus:(NSInteger *)itemclientStatus should_send_item:(NSInteger *)should_send_item{
   
    NSInteger *id_item = -1;
    NSString *ubicacionDB = [self getRutaBD];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:alarm];
  //see if the iten is on my db
    
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return id_item;
        
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO items (id_cat,item_name,alarm,note,repeat,client_status,should_send_item,server_cat_id)  VALUES (%d, '%@' ,'%@','%@','%@',%d,%d,(select id_cat_server FROM categories WHERE id_cat = %d) )", (int)id_cat, item_Name,dateString,note,repeat, (int)itemclientStatus,(int)should_send_item,(int)id_cat];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        //NSLog(@"%@",sqlInsert);
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement insert reminder");
            
            return id_item;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                id_item =   (NSInteger*)sqlite3_last_insert_rowid(bd);
                sqlite3_finalize(sqlStatement);
                
                return id_item;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return id_item;

}
- (BOOL)edit_item: (NSInteger*)id_item  item_Name:(NSString *)item_Name alarm:(NSDate *)alarm note:(NSString *)note repeat:(NSString *)repeat itemclientStatus:(NSInteger *)itemclientStatus{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:alarm];
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqledit = [NSString stringWithFormat:@"UPDATE items SET item_name= '%@' ,alarm = '%@',note ='%@', repeat = '%@',client_status = %d WHERE id_item = %d",item_Name,dateString,note,repeat,itemclientStatus,id_item];
        const char *sql = [sqledit UTF8String];
        sqlite3_stmt *sqlStatement;
                if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement edit item");
            flag = NO;
            return flag;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                return flag;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return flag;
    






}
-(NSInteger*)insert_item_images:(NSInteger *)id_cat id_item:(NSInteger *)id_item file_Name:(NSString *)file_Name{

    NSInteger*idFile;
    NSString *ubicacionDB = [self getRutaBD];
    
        if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO item_files (id_cat,id_item,file_name,server_file_id,should_send_file,client_status_file,file_type)  VALUES (%d,%d, '%@',0,0,0,1)", (int)id_cat,(int)id_item ,file_Name];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement item_images %s",sql);
            return -1;
           
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                 idFile =   (NSInteger*)sqlite3_last_insert_rowid(bd);
                sqlite3_finalize(sqlStatement);
                
                return idFile;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return idFile;
}
-(NSInteger*)insert_item_recordings: (NSInteger *)id_cat id_item:(NSInteger*)id_item file_Name:(NSString*)file_Name{
    
    NSInteger* idFile;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
            } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO item_files (id_cat,id_item,file_name,server_file_id,should_send_file,client_status_file,file_type)  VALUES (%d,%d, '%@',0,0,0,2)", (int)id_cat,(int)id_item ,file_Name];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement item_recordings %s",sql);
            return -1;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
               idFile =   (NSInteger*)sqlite3_last_insert_rowid(bd);
                sqlite3_finalize(sqlStatement);
                
                return idFile;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return idFile;
    
    
    
}
-(BOOL)edit_item_recordings:(NSInteger *)id_item file_Name:(NSString *)file_Name{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        
    } else {
        NSString * update = [NSString stringWithFormat:@"SELECT * FROM item_files WHERE id_item = %d AND file_type = 2",(int)id_item ];
        sqlite3_stmt *stmt;
        int rc = sqlite3_prepare_v2(bd, [update UTF8String], -1, &stmt, nil);
        if (rc == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                update = [NSString stringWithFormat:@"UPDATE item_files SET file_name = '%@' WHERE id_item = %d AND file_type = 2", file_Name,(int)id_item ];
            }
            else{
                update = [NSString stringWithFormat:@"INSERT INTO item_files (id_cat,id_item,file_name,server_file_id,should_send_file,client_status_file,file_type)  VALUES (%d,%d, '%@',0,0,0,2)", (int)[self retrieveFromUserDefaults],(int)id_item ,file_Name];
            }
        }
        
        
        
        const char *sql = [update UTF8String];
        sqlite3_stmt *sqlStatement;
        // NSLog(@"updateimagenpath sql %s" ,sql);
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement edit_item_recordings %s",sql);
            flag = NO;
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return flag;
    


}
-(NSInteger*) edit_item_images:(NSInteger*)id_cat id_item:(NSInteger *)id_item file_Name:(NSString *)file_Name{

    NSInteger * id_file_client;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
       
    
    } else {
        NSString * update = [NSString stringWithFormat:@"SELECT id_file FROM item_files WHERE id_item = %d AND file_type = 1",(int)id_item ];
        sqlite3_stmt *stmt;
        int rc = sqlite3_prepare_v2(bd, [update UTF8String], -1, &stmt, nil);
        if (rc == SQLITE_OK) {
           
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                update = [NSString stringWithFormat:@"UPDATE item_files SET file_name = '%@' WHERE id_item = %d AND file_type = 1", file_Name,(int)id_item ];
           id_file_client = sqlite3_column_int(stmt, 0);            }
            else{
                update = [NSString stringWithFormat:@"INSERT INTO item_files (id_cat,id_item,file_name,server_file_id,should_send_file,client_status_file,file_type)  VALUES (%d,%d, '%@',0,0,0,1)", (int)[self retrieveFromUserDefaults],(int)id_item ,file_Name];
            }
             sqlite3_finalize(stmt);
        }
        
        
       
        const char *sql = [update UTF8String];
        sqlite3_stmt *sqlStatement;
        NSLog(@"edit_item_images: sql %@" ,update);
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement edit_item_images %s",sql);
        
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                
                sqlite3_finalize(sqlStatement);
                id_file_client= (NSInteger*)sqlite3_last_insert_rowid(bd);
                
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return id_file_client;


}
-(NSMutableArray*)get_items_PhotoPaths:(NSInteger *)id_item{
    NSString* Photo_path;
   NSMutableArray *PhotosArray = [[NSMutableArray alloc] init];
    
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD get_PhotoPath_item_reminder");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT file_name FROM item_files WHERE id_item = %d AND file_type = 1", (int)id_item];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement in get_PhotoPath_item");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        
        Photo_path = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        [PhotosArray addObject:Photo_path];
        
    }
    return PhotosArray;
    
}
-(NSString*)get_AudioPath_item_reminder:(NSInteger *)id_item{
    NSString* audio_path;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD get_AudioPath_item_reminder");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT file_name FROM item_files WHERE id_item = %d AND file_type = 2", (int)id_item];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement in get_AudioPath_item_reminder");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        
        audio_path = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        
        
    }
    return audio_path;



}
-(NSMutableArray*)getFiles:(NSInteger *)id_item{
    NSMutableArray * listaR = [[NSMutableArray alloc] init];
    
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT a.id_file,a.id_cat,a.id_item,a.file_name,a.server_file_id,a.should_send_file,a.client_status_file,a.file_type,file_timestamp,(SELECT id_server_item FROM items b WHERE a.id_item = b.id_item LIMIT 1) server_item_id FROM item_files a"];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en getFile");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        ReminderObject * rema = [[ReminderObject alloc] init];
        rema.id_file = sqlite3_column_int(sqlStatement, 0);
        rema.cat_id = sqlite3_column_int(sqlStatement, 1);
        
        rema.reminderID = sqlite3_column_int(sqlStatement, 2);
        rema.file_path = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)];
        rema.server_file_id = sqlite3_column_int(sqlStatement, 4);
        rema.should_send_file=sqlite3_column_int(sqlStatement, 5);
        rema.client_status=sqlite3_column_int(sqlStatement, 6);
        rema.file_type =sqlite3_column_int(sqlStatement, 7);
        rema.file_timestamp = sqlite3_column_int(sqlStatement, 8);
        rema.id_server_item = sqlite3_column_int(sqlStatement, 9);
        
        [listaR addObject:rema];
    }
    
    
    return listaR;



}
-(ReminderObject*)getItemwhitServerID:(NSInteger *)id_item usingServerId:(BOOL)usingServerId{
    ReminderObject * rema = [[ReminderObject alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting;
    if (usingServerId) {
        selecting = [NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_server_item = %d", (int)id_item];
    }else{
       selecting = [NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_item = %d", (int)id_item];
    }
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en getItem");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        rema.reminderID= sqlite3_column_int(sqlStatement, 0);
        rema.reminderName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        rema.alarm =[dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)]];
        
        
        rema.note =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        rema.recurring =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        rema.item_statuss = sqlite3_column_int(sqlStatement, 5);
        rema.id_server_item = sqlite3_column_int(sqlStatement, 6);
        rema.cat_id = sqlite3_column_int(sqlStatement, 7);
        rema.should_send_item = sqlite3_column_int(sqlStatement, 8);
        rema.cat_id_server = sqlite3_column_int(sqlStatement, 9);
    }
    
    return rema;
    
    
    
}
-(BOOL)deleteItem:(NSInteger *)id_item permanently:(BOOL)permanently{
    
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        
    } else {
        NSString *sqlDelete ;
        NSString *sqlDeleteFiles ;
        if (permanently) {
            sqlDelete = [NSString stringWithFormat:@"DELETE FROM items  WHERE id_item = %d",(int)id_item];
            sqlDeleteFiles = [NSString stringWithFormat:@"DELETE FROM item_files  WHERE id_item = %d",(int)id_item];
        }else{
            
            sqlDelete = [NSString stringWithFormat:@"UPDATE items SET client_status = 1 WHERE id_item = %d",(int)id_item];
            sqlDeleteFiles = [NSString stringWithFormat:@"UPDATE item_files SET client_status_file = 1 WHERE id_item = %d",(int)id_item];
        }

        const char *sql = [sqlDelete UTF8String];
        const char *sql1 = [sqlDeleteFiles UTF8String];
        sqlite3_stmt *sqlStatement ;
        sqlite3_stmt *sqlStatement1;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete item");
            flag = NO;
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                flag = YES;
               
                //sqlite3_close(bd);
                
            }
        }
        if(sqlite3_prepare_v2(bd, sql1, -1, &sqlStatement1, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete itemFiles");
            flag = NO;
         
        } else {
            if(sqlite3_step(sqlStatement1) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement1);
                flag = YES;
                
                //sqlite3_close(bd);
                
            }
        }
    }
    
    return flag;





}

-(NSInteger *) getCountItemInCategory:(NSInteger *)CategoryId{
    NSInteger* cantidad;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT count(*) FROM categories inner join items using (id_cat) where id_cat =  %d and items.client_status != 1" , (int)CategoryId];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en countiemincategory");
    }
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
    cantidad = sqlite3_column_int(sqlStatement, 0);
    
    }

    return cantidad;

}
-(NSMutableArray *)getItemListwhitDeletedRowsIncluded:(NSInteger *)CategoryId itemType:(NSInteger *)itemType whitDeletedRowsIncluded:(BOOL*)whitDeletedRowsIncluded{
    NSMutableArray *listaR = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BDin getItemListwhitDeletedRowsIncluded");
    }
    NSString *selecting;
    //select item type(reminder,note or shoopinglist)according itemTypeparameter
if (whitDeletedRowsIncluded) {
       
    switch((int)itemType){
        case 0: //shooping
            selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d AND alarm = null" , (int)CategoryId];
        break;
    case 1: //reminder
            selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d AND alarm != null" , (int)CategoryId];
        break;
    case 2://note
            selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d AND alarm = null AND note != null" , (int)CategoryId];
        break;
        case -2://all items
            selecting = @"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items";
        break;
            default: //all items in category
            selecting = [NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d " , (int)CategoryId];
                break;
            
    }
}else{
        switch((int)itemType){
            case 0: //shooping
                selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item FROM items WHERE id_cat = %d AND alarm = null AND client_status != 1 " , (int)CategoryId];
                break;
            case 1: //reminder
                selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d AND alarm != null AND client_status != 1" , (int)CategoryId];
                break;
            case 2://note
                selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d AND alarm = null AND note != null AND client_status != 1" , (int)CategoryId];
                break;
            case -2://all items
                selecting = @"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items where client_status != 1";
                break;
            default: //all items in category
                selecting = [NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat,client_status,id_server_item,id_cat,should_send_item,server_cat_id FROM items WHERE id_cat = %d and client_status != 1 " , (int)CategoryId];
                break;
                
        }

    
    
    }
    
   // NSLog(@"este es el select items %@",selecting);
    
    const char *sql = [selecting UTF8String];
    	    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement in getitemlist %@" ,selecting);
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        ReminderObject * rema = [[ReminderObject alloc] init];
        rema.reminderID= sqlite3_column_int(sqlStatement, 0);
        rema.reminderName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
         NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
         [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         rema.alarm =[dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)]];
        
        
              rema.note =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        rema.recurring =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        rema.item_statuss = sqlite3_column_int(sqlStatement, 5);
        rema.id_server_item = sqlite3_column_int(sqlStatement, 6);
         rema.cat_id = sqlite3_column_int(sqlStatement, 7);
        rema.should_send_item = sqlite3_column_int(sqlStatement, 8);
        rema.cat_id_server = sqlite3_column_int(sqlStatement, 9);
        [listaR addObject:rema];
    }
    
    return listaR;
    
    
}
-(NSArray*)getHistoryList:(NSInteger *)CategoryId{
    NSMutableArray *listaR = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT history FROM history where id_cat = %d GROUP BY history", (int)CategoryId];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema statment ");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        NSString* History;
        
        
        History = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        
        [listaR addObject:History];
    }
    NSArray *array = [NSArray arrayWithArray:listaR];
    return array;
   
}

-(NSInteger *)insertReminder:(NSInteger *)idCat eventname:(NSString *)EventName alarm:(NSDate *)Alarm photopath:(NSString *)photoPath audiopath:(NSString *)audioPath note:(NSString *)note recurring:(NSString *)recurring{
   
    NSInteger *idrem = 0;
    NSString *ubicacionDB = [self getRutaBD];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:Alarm];
    NSLog(@"Date in alarmobjet %@",dateString);
    //double valueToWriteDAte = [Alarm timeIntervalSince1970];

    
    	    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        	        NSLog(@"No se puede conectar con la BD");
                return idrem;
                
        	    } else {
            	    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO reminder (id_cat,event_name,alarm,photo_path,audio_path,note,recurring)  VALUES (%d, '%@' ,'%@','%@','%@','%@','%@')", (int)idCat, EventName,dateString,photoPath,audioPath,note,recurring];
            	    const char *sql = [sqlInsert UTF8String];
            	    sqlite3_stmt *sqlStatement;
                    NSLog(@"%@",sqlInsert);
            	    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                	        NSLog(@"Problema al preparar el statement insert reminder");
                        
                        return idrem;
                	    } else {
                    	        if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                                   idrem =   (NSInteger*)sqlite3_last_insert_rowid(bd);
                                    sqlite3_finalize(sqlStatement);
                        	           
                                    return idrem;
                                    //sqlite3_close(bd);
                              
                        	        }
                    	    }
            	 
            	    }
    return idrem;


}
-(ReminderObject*)getReminder:(NSInteger *)IDreminder{
  ReminderObject * rema = [[ReminderObject alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT id_rem, event_name,alarm,photo_path,audio_path,id_cat,note,recurring FROM reminder WHERE id_rem = %d", (int)IDreminder];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
         
        rema.reminderID= sqlite3_column_int(sqlStatement, 0);
        rema.reminderName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        rema.alarm =[dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)]];
        
        
        rema.photoPath = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        rema.audioPath =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
       rema.cat_id = sqlite3_column_int(sqlStatement, 5);
        rema.note =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 6)];
    rema.recurring = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 7)];
        
    }
    
    return rema;
    


}
-(BOOL)insertHistory:(NSInteger *)idCat history_desc:(NSString *)history_descripcion{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO history (id_cat,history)  VALUES (%d, '%@')", (int)idCat, history_descripcion];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement history %s",sql);
            flag = NO;
            return flag;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                return flag;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return flag;





}
-(BOOL)deleteReminder:(NSInteger *)id_rem{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM reminder WHERE id_rem = %d",(int)id_rem];
        const char *sql = [sqlDelete UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete reminder");
            flag = NO;
            return flag;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                return flag;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    
    return flag;
}

-(BOOL)InvalidateReminder:(NSInteger *)id_rem recurring:(NSString *)recurring{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlUpdate= [NSString stringWithFormat:@"UPDATE items SET repeat= '%@' WHERE id_item = %d",recurring,(int)id_rem];
        const char *sql = [sqlUpdate UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement update repeat reminder");
            flag = NO;
            return flag;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                return flag;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    
    return flag;

}
-(NSString*)getHexColorFronCategory:(NSInteger *)categotyId{
    NSString *ColorHex;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT colorPic FROM categories WHERE id_cat = %d", (int)categotyId];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en get`hexcolor");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        
        ColorHex = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
       
        
    }
    return ColorHex;


}
-(NSString*)getCategoryName:(NSInteger *)categotyId{
    NSString *CategoryName;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT category_name FROM categories WHERE id_cat = %d", (int)categotyId];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement in getcategoryname");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        
        CategoryName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        
        
    }
    return CategoryName;
 
}
-(NSInteger*)getCategoryType:(NSInteger *)categotyId{
    NSInteger *CategoryType;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT type FROM categories WHERE id_cat = %d", (int)categotyId];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement select cat_type");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        
        CategoryType = sqlite3_column_int(sqlStatement, 0);
        
    }
    return CategoryType;
    
}

-(NSInteger*)insertCategory:(NSString *)catName colorPic:(NSString *)colorPic type:(NSInteger*)type client_status:(NSInteger*)client_status should_send_cat:(NSInteger *)should_send_cat{
    NSInteger*id_cat;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return -1;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO categories (category_name,imagePic,colorPic,type,client_status,should_send_cat)  VALUES ('%@', '%@','%@',%d,%d,%d)", catName, nil,colorPic,type,client_status,should_send_cat];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement categories %s",sql);
            return -1;
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
               id_cat =   (NSInteger*)sqlite3_last_insert_rowid(bd);
                sqlite3_finalize(sqlStatement);
                return id_cat;
                
               
                //sqlite3_close(bd);
                
            }
        }
        
    }
    
    return id_cat;

}
-(BOOL)deleteFiles:(NSInteger *)id_file permanently:(BOOL)permanently{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlDelete ;
        
        if (permanently) {
            sqlDelete = [NSString stringWithFormat:@"DELETE FROM item_files  WHERE id_file = %d",(int)id_file];
            
        }else{
            
            sqlDelete = [NSString stringWithFormat:@"UPDATE item_files SET client_status_file = 1 WHERE id_file = %d",(int)id_file];
           
        }
        const char *sql = [sqlDelete UTF8String];
        
        
        sqlite3_stmt *sqlStatement;
        
        ////////////////execute ////////////
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete file");
            flag = NO;
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                
                //sqlite3_close(bd);
                
            }
        }
        
    }
    
    
    
    return flag;
    

}

-(BOOL)deleteCategory:(NSInteger *)id_cat permanently:(BOOL)permanently{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlDelete ;
        NSString *sqlDeleteItems;
        NSString *sqlDeleteFiles;
        if (permanently) {
            sqlDelete = [NSString stringWithFormat:@"DELETE FROM categories  WHERE id_cat = %d",(int)id_cat];
            sqlDeleteItems = [NSString stringWithFormat:@"DELETE FROM items  WHERE id_cat = %d",(int)id_cat];
            sqlDeleteFiles = [NSString stringWithFormat:@"DELETE FROM item_files  WHERE id_cat = %d",(int)id_cat];
        }else{
        
        sqlDelete = [NSString stringWithFormat:@"UPDATE categories SET client_status = 1 WHERE id_cat = %d",(int)id_cat];
            sqlDeleteItems = [NSString stringWithFormat:@"UPDATE items SET client_status = 1 WHERE id_cat = %d",(int)id_cat];
            sqlDeleteFiles = [NSString stringWithFormat:@"UPDATE item_files SET client_status_file = 1 WHERE id_cat = %d",(int)id_cat];
        }
        const char *sql = [sqlDelete UTF8String];
        const char *sql1 = [sqlDeleteItems UTF8String];
         const char *sql2 = [sqlDeleteFiles UTF8String];
       
        sqlite3_stmt *sqlStatement;
        sqlite3_stmt *sqlStatement1;
        sqlite3_stmt *sqlStatement2;
     ////////////////execute tehe categorie/////////////
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete category");
            flag = NO;
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                
                //sqlite3_close(bd);
                
            }
        }
/////////////////////////execute itenms
        if(sqlite3_prepare_v2(bd, sql1, -1, &sqlStatement1, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete category_items");
            flag = NO;
           
        } else {
            if(sqlite3_step(sqlStatement1) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement1);
                
                flag = YES;
                
                //sqlite3_close(bd);
                
            }
        }
        /////////////////////////execute files
        if(sqlite3_prepare_v2(bd, sql2, -1, &sqlStatement2, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete category_items_files");
            flag = NO;
            
        } else {
            if(sqlite3_step(sqlStatement2) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement2);
                
                flag = YES;
                
                //sqlite3_close(bd);
                
            }
        }

    }
    
    
    
    return flag;

}
-(BOOL)editCategory:(NSInteger *)id_cat categoryName:(NSString *)categoryName categoryColor:(NSString *)categoryColor type:(NSInteger*)type{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqledit = [NSString stringWithFormat:@"UPDATE categories SET category_name= '%@' ,colorPic = '%@',type =%d,client_status = '0' WHERE id_cat = %d",categoryName,categoryColor,(int)type,(int)id_cat];
        const char *sql = [sqledit UTF8String];
        sqlite3_stmt *sqlStatement;
        NSLog(sqledit);
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement edit category");
            flag = NO;
            return flag;
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                flag = YES;
                return flag;
                //sqlite3_close(bd);
                
            }
        }
        
    }
    return flag;

}

-(void)UpdateFileTIMESTAMP:(NSInteger *)id_client file_timestamp:(NSInteger *)file_timestamp{
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD en UpdateFileTIMESTAMP");
        
    } else {
        NSString *sqlUp;
        
        
            
            sqlUp = [NSString stringWithFormat:@"UPDATE item_files SET file_timestamp = %d WHERE id_file = %d",(int)file_timestamp,(int)id_client];
        
        const char *sql = [sqlUp UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement UpdateFileTIMESTAMP %@",sqlUp);
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                //sqlite3_close(bd);
                
            }
        }
        
    }






}
-(void)UpdateItemsFiles:(NSInteger *)id_item file_type:(NSInteger *)file_type should_send:(NSInteger *)should_send file_path:(NSString *)file_path{
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD en UpdateItemsFiles");
        
    } else {
        
        
      
            NSString* sqlUpdates = [NSString stringWithFormat:@"UPDATE item_files SET should_send_file = %d , file_name = '%@' WHERE id_item = %d AND file_type = %d",(int)should_send,file_path,(int)id_item,(int)file_type];
        
        //NSLog(sqlUpdates);
        const char *sql = [sqlUpdates UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement UpdateItemsFiles %@",sqlUpdates);
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                
                sqlite3_finalize(sqlStatement);
                
                //sqlite3_close(bd);
                
            }
        }
        
    }
    


}
-(void)UpdateSHOULDSendinFILESbyType:(NSInteger *)id_item file_type:(NSInteger *)file_type should_send:(NSInteger *)should_send comeFroMSync:(BOOL *)comeFroMSync{
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD en UpdateSHOULDSendinFILESbyType");
        
    } else {
        NSString *sqlUp;
        if (comeFroMSync) {
            sqlUp = [NSString stringWithFormat:@"UPDATE item_files SET should_send_file = %d  WHERE id_file = %d AND file_type = %d",(int)should_send,(int)id_item,(int)file_type];
        }else{
            sqlUp = [NSString stringWithFormat:@"UPDATE item_files SET should_send_file = %d  WHERE id_item = %d AND file_type = %d",(int)should_send,(int)id_item,(int)file_type];
        }
       // NSLog(@"UpdateSHOULDSendinFILESbyType %@",sqlUp);
        const char *sql = [sqlUp UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement UpdateSHOULDSendinFILESbyType %@",sqlUp);
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
              
                sqlite3_finalize(sqlStatement);
                
                //sqlite3_close(bd);
                
            }
        }
        
    }

    
    
}
-(void)updateSTATUSandSHOULDSENDInTable:(NSInteger *)id_client clientStatus:(NSInteger *)clientStatus should_send:(NSInteger *)should_send tableName:(NSString *)tableName {
    
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD en updateSTATUSandSHOULDSENDinTable");
        
    } else {
        NSString *sqlUp;
       
        if([tableName isEqualToString:@"categories"]){

        sqlUp = [NSString stringWithFormat:@"UPDATE categories SET client_status = %d, should_send_cat = %d WHERE id_cat = %d",(int)clientStatus,(int)should_send,(int)id_client];
        }
        else  if([tableName isEqualToString:@"items"]){
            sqlUp = [NSString stringWithFormat:@"UPDATE items SET client_status = %d, should_send_item = %d WHERE id_item = %d",(int)clientStatus,(int)should_send,(int)id_client];
            
        }
        else  if([tableName isEqualToString:@"item_files"]){
            sqlUp = [NSString stringWithFormat:@"UPDATE item_files SET client_status_file = %d, should_send_file = %d WHERE id_item = %d",(int)clientStatus,(int)should_send,(int)id_client];
        }
        
        const char *sql = [sqlUp UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement updateSTATUSandSHOULDSENDinTable %@",sqlUp);
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                //sqlite3_close(bd);
                
            }
        }
        
    }

}
-(void)UpdateSERVERIDinTable:(NSInteger *)id_client id_server:(NSInteger *)id_server tableName:(NSString *)tableName {
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD en UpdateSERVERIDtable");
        
    } else {
        NSString *sqlUp;
        if([tableName isEqualToString:@"categories"]){
        
            sqlUp = [NSString stringWithFormat:@"UPDATE categories SET id_cat_server = %d  WHERE id_cat = %d",(int)id_server,(int)id_client];
        
        }else if ([tableName isEqualToString:@"items"]){
        
            sqlUp = [NSString stringWithFormat:@"UPDATE items SET id_server_item = %d  WHERE id_item = %d",(int)id_server,(int)id_client];
            
        }else if ([tableName isEqualToString:@"item_files"]){
            
            sqlUp = [NSString stringWithFormat:@"UPDATE item_files SET server_file_id = %d   WHERE id_file = %d",(int)id_server,(int)id_client];
        }
        
        const char *sql = [sqlUp UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement UpdateSERVERIDCategory %@",sqlUp);
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
                
                //sqlite3_close(bd);
                
            }
        }
        
    }

}
-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}



@end
