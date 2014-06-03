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
- (NSMutableArray *) getCategoryList{
  
NSMutableArray *listaR = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    const char *sentenciaSQL = "SELECT id_cat, category_name,imagePic,colorPic,type FROM categories";
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
        [listaR addObject:rema];
    }
    
    return listaR;
    
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
        NSLog(@"Problema al preparar el statement");
    }
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
    cantidad = sqlite3_column_int(sqlStatement, 0);
    
    }

    return cantidad;

}
-(NSMutableArray *)getItemList:(NSInteger *)CategoryId {
    NSMutableArray *listaR = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    NSString *selecting = [NSString stringWithFormat:@"SELECT id_item, item_name,alarm,note,repeat FROM items WHERE id_cat = %d " , (int)CategoryId];
    	    const char *sql = [selecting UTF8String];
    	    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
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
        NSString *sqlUpdate= [NSString stringWithFormat:@"UPDATE reminder SET recurring= '%@' WHERE id_rem = %d",recurring,(int)id_rem];
        const char *sql = [sqlUpdate UTF8String];
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
        NSLog(@"Problema al preparar el statement");
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
        NSLog(@"Problema al preparar el statement");
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

-(BOOL)insertCategory:(NSString *)catName colorPic:(NSString *)colorPic type:(NSInteger*)type{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO categories (category_name,imagePic,colorPic,type)  VALUES ('%@', '%@','%@',%d)", catName, nil,colorPic,type];
        const char *sql = [sqlInsert UTF8String];
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare_v2(bd, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
            NSLog(@"Problema al preparar el statement categories %s",sql);
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
-(BOOL)deleteCategory:(NSInteger *)id_cat{
    BOOL flag = YES;
    NSString *ubicacionDB = [self getRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
        flag = NO;
        return flag;
    } else {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM categories WHERE id_cat = %d",(int)id_cat];
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
        NSString *sqledit = [NSString stringWithFormat:@"UPDATE categories SET category_name= '%@' ,colorPic = '%@',type =%d WHERE id_cat = %d",categoryName,categoryColor,(int)type,(int)id_cat];
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
@end
