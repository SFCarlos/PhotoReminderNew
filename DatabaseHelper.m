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
    
    return rutaBD;
}
-(ReminderObject*) getCategorie:(NSInteger *)id_cat{
    ReminderObject * rema = [[ReminderObject alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT id_cat,id_cat_server, category_name,imagePic,colorPic,type,client_status FROM categories WHERE id_cat = %d", (int)id_cat];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en getItem");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        rema.cat_id = sqlite3_column_int(sqlStatement, 0);
       
        rema.cat_id_server = sqlite3_column_int(sqlStatement, 1);
        rema.categoryName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        
        rema.categoryImagenPic = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        rema.categoryColorPic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
        rema.categoryType = sqlite3_column_int(sqlStatement,5);
        rema.client_status = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
        
    }
    
    return rema;
    




}
- (NSMutableArray *) getCategoryListwhitDeletedRowsIncluded:(BOOL *)whitDeletedRowsIncluded{
  
NSMutableArray *listaR = [[NSMutableArray alloc] init];
        NSString *ubicacionDB = [self getRutaBD];
    const char *sentenciaSQL;
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    if (whitDeletedRowsIncluded) {
        sentenciaSQL = "SELECT id_cat, category_name,imagePic,colorPic,type,client_status,id_cat_server FROM categories ";
    }else{
   sentenciaSQL = "SELECT id_cat, category_name,imagePic,colorPic,type,client_status,id_cat_server FROM categories WHERE client_status != '1'";
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
        rema.client_status = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
        rema.cat_id_server = sqlite3_column_int(sqlStatement,6);
        [listaR addObject:rema];
    }
   /* orden = [self getCategoryorder];
    //return listaR;
    
    if(listaR.count== orden.count){
       
    for (NSString* indexOrden in orden)
        {
            //NSLog(@"indexOrden %@",indexOrden);
            
            ReminderObject* obj=[listaR objectAtIndex:[indexOrden intValue]];
            [FinarArraYCategory addObject:obj];
          
    }
     
    }else{
        return listaR;
    }*/
     //por ahora solo retornar el array original luego lo ordeno
    return listaR;
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

-(NSInteger*)insert_item:(NSInteger *)id_cat item_Name:(NSString *)item_Name alarm:(NSDate *)Alarm note:(NSString *)note repeat:(NSString *)repeat{
   
    NSInteger *id_item = -1;
    NSString *ubicacionDB = [self getRutaBD];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:Alarm];
    NSLog(@"Date in alarmobjet %@",dateString);
    //double valueToWriteDAte = [Alarm timeIntervalSince1970];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return id_item;
        
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO items (id_cat,item_name,alarm,note,repeat)  VALUES (%d, '%@' ,'%@','%@','%@')", (int)id_cat, item_Name,dateString,note,repeat];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        NSLog(@"%@",sqlInsert);
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

-(BOOL)insert_item_images:(NSInteger *)id_cat id_item:(NSInteger *)id_item file_Name:(NSString *)file_Name{

    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO item_images (id_cat,id_item,file_name)  VALUES (%d,%d, '%@')", (int)id_cat,(int)id_item ,file_Name];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement item_images %s",sql);
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
-(BOOL)insert_item_recordings: (NSInteger *)id_cat id_item:(NSInteger*)id_item file_Name:(NSString*)file_Name{
    
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO item_recordings (id_cat,id_item,file_name)  VALUES (%d,%d, '%@')", (int)id_cat,(int)id_item ,file_Name];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement item_recordings %s",sql);
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
-(NSMutableArray*)get_items_PhotoPaths:(NSInteger *)id_item{
    NSString* Photo_path;
   NSMutableArray *PhotosArray = [[NSMutableArray alloc] init];
    
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD get_PhotoPath_item_reminder");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT file_name FROM item_images WHERE id_item = %d", (int)id_item];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement in get_PhotoPath_item_reminder");
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
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT file_name FROM item_recordings WHERE id_item = %d", (int)id_item];
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
-(ReminderObject*)getItem:(NSInteger *)id_item{
    ReminderObject * rema = [[ReminderObject alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT id_item, id_cat,item_name,alarm,note,repeat FROM items WHERE id_item = %d", (int)id_item];
    const char *sql = [selecting UTF8String];
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement en getItem");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        rema.reminderID= sqlite3_column_int(sqlStatement, 0);
        rema.cat_id = sqlite3_column_int(sqlStatement, 1);
        rema.reminderName = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        rema.alarm =[dateFormat dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 3)]];
        
        
       // rema.photoPath = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
       // rema.audioPath =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        
        rema.note =[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        rema.recurring = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 5)];
    }
    
    return rema;
    
    
    
}
-(BOOL)deleteItem:(NSInteger *)id_item{
    
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM items WHERE id_item = %d",(int)id_item];
        const char *sql = [sqlDelete UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete item");
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

-(NSInteger *) getCountItemInCategory:(NSInteger *)CategoryId{
    NSInteger* cantidad;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT count(*) FROM categories inner join items using (id_cat) where id_cat =  %d", (int)CategoryId];
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
-(NSMutableArray *)getItemList:(NSInteger *)CategoryId itemType:(NSInteger *)itemType{
    NSMutableArray *listaR = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    NSString *selecting;
    //select item type(reminder,note or shoopinglist)according itemTypeparameter
    switch((int)itemType){
        case 0: //shooping
            selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat FROM items WHERE id_cat = %d AND alarm = null" , (int)CategoryId];
        break;
    case 1: //reminder
            selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat FROM items WHERE id_cat = %d AND alarm != null" , (int)CategoryId];
        break;
    case 2://note
            selecting =[NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat FROM items WHERE id_cat = %d AND alarm = null AND note != null" , (int)CategoryId];
        break;
            default: //all
            selecting = [NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat FROM items WHERE id_cat = %d " , (int)CategoryId];
                break;
    }
    
    
    
    
    const char *sql = [selecting UTF8String];
    	    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement in getitemlist");
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

-(NSInteger*)insertCategory:(NSString *)catName colorPic:(NSString *)colorPic type:(NSInteger*)type client_status:(NSString*)client_status{
    NSInteger*id_cat;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        return -1;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO categories (category_name,imagePic,colorPic,type,client_status)  VALUES ('%@', '%@','%@',%d,'%@')", catName, nil,colorPic,type,client_status];
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
-(BOOL)deleteCategory:(NSInteger *)id_cat{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlDelete = [NSString stringWithFormat:@"UPDATE categories SET client_status = '1' WHERE id_cat = %d",(int)id_cat];
        const char *sql = [sqlDelete UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement delete category");
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

-(NSMutableArray *) getCategoryorder{
    NSMutableArray *listaR = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    const char *sentenciaSQL = "SELECT * FROM category_order";
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement select category_order");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        
        NSString * order = [NSString stringWithFormat:@"%d",sqlite3_column_int(sqlStatement, 1)];
        
        [listaR addObject:order];
    }
    
    return listaR;
    
}
-(void)updateClientStatus_and_IdServerinCategory:(NSInteger *)Id_cat_client Id_cat_server:(NSInteger *)Id_cat_server clientStatus:(NSString *)clientStatus{

   
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD en updateClientStatus_and_IdServerinCategory");
        
    } else {
        NSString *sqlDelete = [NSString stringWithFormat:@"UPDATE categories SET client_status = '%@',id_cat_server = %d WHERE id_cat = %d",clientStatus,(int)Id_cat_server,(int)Id_cat_client];
        const char *sql = [sqlDelete UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement updateClientStatus_and_IdServerinCategory");
            
        } else {
            if(sqlite3_step(sqlStatement) == SQLITE_DONE){
                sqlite3_finalize(sqlStatement);
               
                //sqlite3_close(bd);
                
            }
        }
        
    }
    






}
@end
