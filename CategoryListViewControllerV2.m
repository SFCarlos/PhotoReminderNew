//
//  CategoryListViewControllerV2.m
//  PhotoReminderNew
//
//  Created by User on 27.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "CategoryListViewControllerV2.h"
#import "Globals.h"
#import "RemindersListViewController.h"
#import "EditCategoryViewController.h"
#import "CategoryCustomCell.h"
#import "AppDelegate.h"
#import "LocalNotificationCore.h"
#import "UIImage+ScalingMyImage.h"
#import <PixateFreestyle/PixateFreestyle.h>


@interface CategoryListViewControllerV2 ()
@property (nonatomic,retain) iOSServiceProxy* service;
@property (nonatomic,assign) NSInteger * serverCategoryIdshare;

@end

@implementation CategoryListViewControllerV2{
    NSMutableArray *categoryArray;
    NSMutableArray *categoryArrayFULL;
    NSMutableArray * itemsArrayFULL;
     NSMutableArray * filesArrayFULL;
    NSIndexPath * indextoEdit;
    NSIndexPath * indextoDelete;
    NSMutableArray *leftUtilityButtons;
    UIButton* catNameButton;
    UIButton* showitemsListButton;
    NSInteger* flagSyncSTatus;
    UIBarButtonItem *setting ;
    UIBarButtonItem* SyncLogo;
    UIBarButtonItem * addCategory;
    
    CMPopTipView *navBarRigthButtonPopTipView;
    NSInteger* id_cat_addservice;
    NSInteger* id_cat_deleteservice;
    NSInteger* id_cat_editservice;
    
    UIAlertView *Syncalert;
}
@synthesize dao;
@synthesize service;
@synthesize serverCategoryIdshare;

-(NSInteger*)retrieveSYNCSTATUSSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
   
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"STATUS"];
    
    return val;
    
}
-(NSInteger*)retrieveserverFILETIMESTAMPFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"FILE_TIMESTAMP"];
    
    return val;
    
}

-(NSInteger*)retrieveTIMESTAMPFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"TIMESTAMP"];
    
    return val;
    
}

-(NSString*)retrieveSoundReminderFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"REMINDER_SOUND"];
    
    return val;
}

- (void)viewDidLoad
{
    
    
    self.service = [[iOSServiceProxy alloc]initWithUrl:@"http://reminderapi.cybernetlab.com/WebServiceSOAP/server.php" AndDelegate:self];
   
    
       // self.navigationController.navigationBar.styleClass =@"navigation-bar";
  // self.tableView.styleClass = @"table-cell";

  //self.tableView.styleClass =@"view";
   // self.navigationItem.styleClass = @"view";
    //init the arrays
    dao = [[DatabaseHelper alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    categoryArrayFULL = [[NSMutableArray alloc] init];
    categoryArray = [dao getCategoryListwhitDeletedRowsIncluded:NO];
    categoryArrayFULL = [dao getCategoryListwhitDeletedRowsIncluded:YES];
    itemsArrayFULL =[[NSMutableArray alloc] init];
    itemsArrayFULL = [dao getItemListwhitDeletedRowsIncluded:-1 itemType:-2 whitDeletedRowsIncluded:YES];//return all items in db
    filesArrayFULL =[[NSMutableArray alloc] init];
    filesArrayFULL = [dao getFilesListwhitDeletedRowsIncluded:-1 whitDeletedRowsIncluded:YES];
    
          setting = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"settings-25x.png"] style:UIBarStyleDefault target:self action:@selector(settingAction:)];
    
    SyncLogo = [[UIBarButtonItem alloc]
                initWithImage:[UIImage imageNamed:@"update-25.png"] style:UIBarStyleDefault target:self action:@selector(SyncAll:)];
    //add buttons to nav bar
    self.navigationItem.leftBarButtonItems =
    [NSArray arrayWithObjects: setting, nil];
    
    flagSyncSTatus = [self retrieveSYNCSTATUSSFromUserDefaults];
    
    if(flagSyncSTatus == 1){
    self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects: SyncLogo, nil];}
    else{
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects: nil, nil];
    }
    
    self.navigationItem.title = @"Categories";
    /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:nil];
     [[self navigationItem] setBackBarButtonItem:backButton];*/
    self.tabBarController.tabBar.hidden=YES;
    
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //recomend in SWtableCell
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //tool tips
    // Present a CMPopTipView pointing at a refresh button on nav bar
   

    navBarRigthButtonPopTipView = [[CMPopTipView alloc] initWithMessage:@"Press here!"] ;
    navBarRigthButtonPopTipView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.78f];navBarRigthButtonPopTipView.textColor = [UIColor lightGrayColor];
    navBarRigthButtonPopTipView.hasShadow = YES;
    navBarRigthButtonPopTipView.has3DStyle = NO;
    navBarRigthButtonPopTipView.borderWidth = 0;
    
   

}
-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
   
    
}
-(void) viewWillAppear:(BOOL)animated{
    
    
        flagSyncSTatus = [self retrieveSYNCSTATUSSFromUserDefaults];
   // NSLog(@"flagsync %d", (int)flagSyncSTatus);
    if(flagSyncSTatus == 1){
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects: SyncLogo, nil];}
    else{
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects: nil, nil];
    }

    categoryArrayFULL=[dao getCategoryListwhitDeletedRowsIncluded:YES];
    
    categoryArray=[dao getCategoryListwhitDeletedRowsIncluded:NO];
    itemsArrayFULL = [dao getItemListwhitDeletedRowsIncluded:-1 itemType:-2 whitDeletedRowsIncluded:YES];
    
    filesArrayFULL= [dao getFilesListwhitDeletedRowsIncluded:-1 whitDeletedRowsIncluded:YES];
    
   

    [self.tableView reloadData];
    
    
    [super viewWillAppear:animated];
    
    
}
#pragma mark - wsdl delegate
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString *)method{
   

    if([method isEqualToString:@"checkUpdates"]){
    GetReturnArray * result = (GetReturnArray*)data;
       
        
/////////update the server timestmp////
       
    [self saveServerTIMESTAMPToUserDefaults:(int)result.timestamp];
        
/////////insert the returned categories and items in my db/////
        NSMutableArray* categoriesReturned = result.categoriesArray;
        NSMutableArray* itemsReturned = result.itemsArray;
        NSMutableArray* filesReturned = result.filesArray;
       
       
        
        if (categoriesReturned.count != 0) {//if dont send categories but sendme item or files means that this I HAVE this category cause is share, so insert,update or delete item and files shares
             NSLog(@"CheckUpdates--return,categoriesArray %d, itemsArray %d, filesArray %d",categoriesReturned.count,itemsReturned.count,filesReturned.count);
        for (CategoryObj * retCat in categoriesReturned) {
            
            NSInteger * id_cat_client = [dao insertCategory:retCat.categoryName colorPic:retCat.categoryColor type:retCat.categoryType client_status:0 should_send_cat:0];
            [dao UpdateSERVERIDinTable:id_cat_client id_server:retCat.serverCategoryID tableName:@"categories" ];
            
                for (ItemObj * retItem in itemsReturned) {
                    NSInteger* id_item_client = 0;
                    
                    if (retCat.serverCategoryID == retItem.serverCategoryID ) {
                        // Convert string to date object
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                        NSDate *dateA = [dateFormat dateFromString:retItem.itemAlarm];
                       
                       id_item_client = [dao insert_item:id_cat_client item_Name:retItem.itemName alarm:dateA note:retItem.itemNote repeat:retItem.itemRepeat itemclientStatus:0 should_send_item:0];
                        [dao UpdateSERVERIDinTable:id_item_client id_server:retItem.serverItemID tableName:@"items"];
                        
                        //Reminder
                        [Globals ScheduleSharedNotificationwhitItemId:id_item_client ItemName:retItem.itemName andAlarm:retItem.itemAlarm andRecurring:retItem.itemRepeat andStatus:0];
                    }
                    
                    for (GetFileObj * retFile in filesReturned) {
                       
                        if (retItem.serverItemID == retFile.serverItemID) {
                            //NSLog(@"checkUpdates return-legth %d , serveritemID %d , ",retFile.fileData.length,retFile.serverItemID);
                            
                            
                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                            NSString *documentsDirectory = [paths objectAtIndex:0];
                            NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
                            NSString *caldate = [now description];
                         
                            if (retFile.fileType == 1) {//imagen
                                NSString * dataPathImage  = [NSString stringWithFormat:@"%@/%@-%d",documentsDirectory,caldate,(int)id_item_client];
                               ;
                                NSInteger* id_file_client= [dao edit_item_images:id_cat_client id_item:id_item_client file_Name:dataPathImage];
                                [dao UpdateFileTIMESTAMP:id_file_client file_timestamp:retFile.fileTimestamp];
                               
                                [dao UpdateSERVERIDinTable:id_file_client id_server:retFile.serverFileID tableName:@"item_files"];
                                
                                
                                //[dao updateSTATUSandSHOULDSENDInTable:id_file_client clientStatus:0 should_send:0 tableName:@"item_files"];
                                
                                // Save it into file system
                                [retFile.fileData writeToFile:dataPathImage atomically:YES];

                            }
                            else if (retFile.fileType == 2){ //audio
                                
                                NSString *pathForAudio = [NSString stringWithFormat:@"%@/Documents/%@-%d.caf", NSHomeDirectory(),caldate,retFile.serverFileID];
                                
                                NSInteger * id_file_client_audio=[dao edit_item_recordings:id_cat_client id_item:id_item_client file_Name:pathForAudio];
                                [dao UpdateFileTIMESTAMP:id_file_client_audio file_timestamp:retFile.fileTimestamp];
                                [dao UpdateSERVERIDinTable:id_file_client_audio id_server:retFile.serverFileID tableName:@"item_files"];
                                
                                // Save it into file system
                                [retFile.fileData writeToFile:pathForAudio atomically:YES];

                           
                            }
                            
                            
                        }
                        
                    }
                }
            
        }
        
        }
        else{ //here should be only items and files cause is share and I have the category
             NSLog(@"CheckUpdatesShare--return,categoriesArray %d, itemsArray %d, filesArray %d",categoriesReturned.count,itemsReturned.count,filesReturned.count);
            if (itemsReturned.count != 0) {
                
            for (GetItemObj * retItemShared in itemsReturned) {
               
                NSInteger* id_item_client = 0;
               //get sharedcategory in my DB
                ReminderObject *sharedCategory = [dao getCategorieWhitServerID:retItemShared.serverCategoryID usingServerId:YES];
               
                if (sharedCategory.cat_id_server == retItemShared.serverCategoryID ) {
                    // Convert string to date object
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSDate *dateA = [dateFormat dateFromString:retItemShared.itemAlarm];
                    
                    ReminderObject* iteminmydb = [dao getItemwhitServerID:retItemShared.serverItemID usingServerId:YES];
                   
                   // NSLog(@"iteminmydb.reminderID = %d",iteminmydb.reminderID);
                    //see if item is not im my bd Insert or Update
                    if (iteminmydb.reminderID == nil) {
                        if (retItemShared.itemStatus != 1) {
                            id_item_client = [dao insert_item:sharedCategory.cat_id item_Name:retItemShared.itemName alarm:dateA note:retItemShared.itemNote repeat:retItemShared.itemRepeat itemclientStatus:0 should_send_item:0];
                            [dao UpdateSERVERIDinTable:id_item_client id_server:retItemShared.serverItemID tableName:@"items"];
                            NSLog(@"%d",[Globals ScheduleSharedNotificationwhitItemId:id_item_client ItemName:retItemShared.itemName andAlarm:retItemShared.itemAlarm andRecurring:retItemShared.itemRepeat andStatus:0]);
                        }
                        
                    
                    }else{
                        
                        
                        id_item_client=[dao edit_item:iteminmydb.reminderID item_Name:retItemShared.itemName alarm:dateA note:retItemShared.itemNote repeat:retItemShared.itemRepeat itemclientStatus:retItemShared.itemStatus];
                        [Globals cancelAllNotificationsWhitItemID:iteminmydb.reminderID];
                         NSLog(@"cancelNot inedit %d",[Globals ScheduleSharedNotificationwhitItemId:id_item_client ItemName:retItemShared.itemName andAlarm:retItemShared.itemAlarm andRecurring:retItemShared.itemRepeat andStatus:retItemShared.itemStatus]);
                        
                        //delete ligic from shared items
                        if (retItemShared.itemStatus == 1) {
                        [dao deleteItem:iteminmydb.reminderID permanently:YES];
                            //cancel notifications
                            [Globals cancelAllNotificationsWhitItemID:iteminmydb.reminderID];
                            
                        }
                        
                    }
                    
                                        
                }
                
///// files in the share category and item
                
                for (GetFileObj * retFile in filesReturned){
                    if(retItemShared.serverItemID == retFile.serverItemID){
                        
                    
                        
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSString *caldate = [now description];
                    
                    if (retFile.fileType == 1) {//imagen
                        NSString * dataPathImage  = [NSString stringWithFormat:@"%@/%@---%d",documentsDirectory,caldate, arc4random_uniform(100)];
                        
                        NSInteger* id_file_client= [dao edit_item_images:sharedCategory.cat_id id_item:id_item_client file_Name:dataPathImage];
                        [dao UpdateFileTIMESTAMP:id_file_client file_timestamp:retFile.fileTimestamp];
                        [dao UpdateSERVERIDinTable:id_file_client id_server:retFile.serverFileID tableName:@"item_files"];
                       
                                                // Save it into file system
                        [retFile.fileData writeToFile:dataPathImage atomically:YES];
                        
                    }
                    else if (retFile.fileType == 2){ //audio
                        
                        NSString *pathForAudio = [NSString stringWithFormat:@"%@/Documents/%@-%d.caf", NSHomeDirectory(),caldate,retFile.serverFileID];
                        
                        NSInteger * id_file_client_audio=[dao edit_item_recordings:sharedCategory.cat_id id_item:id_item_client file_Name:pathForAudio];
                        [dao UpdateFileTIMESTAMP:id_file_client_audio file_timestamp:retFile.fileTimestamp];
                        [dao UpdateSERVERIDinTable:id_file_client_audio id_server:retFile.serverFileID tableName:@"item_files"];
                        
                        // Save it into file system
                        [retFile.fileData writeToFile:pathForAudio atomically:YES];
                        
                        
                    }

                        
                    
                }
            
                }
            }
            
            
            }
            //esto no se ejecuta porke siempre mando el item asi que ninca ItemsReturnes == 0
            if(filesReturned.count != 0 && itemsReturned.count == 0){ //the items array is empty so only files are send this time in shares
                for (GetFileObj * retFile in filesReturned){
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSString *caldate = [now description];
                    
                    ///find the item in my db
                    ReminderObject * itemShared= [dao getItemwhitServerID:retFile.serverItemID usingServerId:YES];
                    //NSLog(@"itemShared.itemid = %d and itemShared.cateID = %d itemSaredserverId = %d",itemShared.reminderID,itemShared.cat_id,itemShared.id_server_item);
                    
                    if (retFile.fileType == 1) {//imagen
                        NSString * dataPathImage  = [NSString stringWithFormat:@"%@/%@--!%d",documentsDirectory,caldate, arc4random_uniform(100)];
                        
                       
                        NSInteger* id_file_client= [dao edit_item_images:itemShared.cat_id id_item:itemShared.reminderID file_Name:dataPathImage];
                        [dao UpdateFileTIMESTAMP:id_file_client file_timestamp:retFile.fileTimestamp];
                        [dao UpdateSERVERIDinTable:id_file_client id_server:retFile.serverFileID tableName:@"item_files"];
                        
                        // Save it into file system
                        [retFile.fileData writeToFile:dataPathImage atomically:YES];
                        
                    }else if (retFile.fileType == 2){ //audio
                        
                        NSString *pathForAudio = [NSString stringWithFormat:@"%@/Documents/%@-%d.caf", NSHomeDirectory(),caldate,retFile.serverFileID];
                        
                        NSInteger * id_file_client_audio=[dao insert_item_recordings:itemShared.cat_id id_item:itemShared.reminderID file_Name:pathForAudio];
                        [dao UpdateFileTIMESTAMP:id_file_client_audio file_timestamp:retFile.fileTimestamp];
                        [dao UpdateSERVERIDinTable:id_file_client_audio id_server:retFile.serverFileID tableName:@"item_files"];
                        
                        // Save it into file system
                        [retFile.fileData writeToFile:pathForAudio atomically:YES];
                        
                        
                    }
                    
                    
                }

            
            }
        }
        
        
        
        
        
    ////////////syncall call///////////
        categoryArrayFULL = [dao getCategoryListwhitDeletedRowsIncluded:YES];
        itemsArrayFULL = [dao getItemListwhitDeletedRowsIncluded:-1 itemType:-2 whitDeletedRowsIncluded:YES];//return all items in db
        filesArrayFULL = [dao getFilesListwhitDeletedRowsIncluded:-1 whitDeletedRowsIncluded:YES];

        //init the things
        inAllArray * imputservice = [[inAllArray alloc]init];
        
        
        NSMutableArray *parameterCategoryArray = [[NSMutableArray alloc]init];
        NSMutableArray *parameterItemsArray = [[NSMutableArray alloc]init];
        NSMutableArray *parameterFilesArray = [[NSMutableArray alloc]init];
        
        //iterate in my categoryArrayFULL to create the object and insert into service  array to send
        for (ReminderObject * cattem in categoryArrayFULL){
            //discover whitch I should send or not
            
            if((int)cattem.should_send_cat == 1){
                CategoryObj * CatToAddinArraySend = [[CategoryObj alloc]init];
                CatToAddinArraySend.clientCategoryID = (int)cattem.cat_id;
                CatToAddinArraySend.serverCategoryID = (int)cattem.cat_id_server;
                CatToAddinArraySend.categoryType = (int)cattem.categoryType;
                CatToAddinArraySend.categoryName = cattem.categoryName;
                CatToAddinArraySend.categoryColor=cattem.categoryColorPic;
                CatToAddinArraySend.categoryStatus=(int)cattem.client_status;
                
                [parameterCategoryArray addObject:CatToAddinArraySend];
            }
            
        }
        // NSLog(@"cantidad de Categories a enviar %d", parameterCategoryArray.count);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        for (ReminderObject * itemtem in itemsArrayFULL){
            if((int)itemtem.should_send_item == 1){
              
                ItemObj * ItemToAddinArraySend = [[ItemObj alloc]init];
                ItemToAddinArraySend.serverCategoryID = (int)itemtem.cat_id_server;
                ItemToAddinArraySend.clientCategoryID = (int)itemtem.cat_id;
                ItemToAddinArraySend.clientItemID = (int)itemtem.reminderID;
                ItemToAddinArraySend.serverItemID = (int)itemtem.id_server_item;
                ItemToAddinArraySend.itemName = itemtem.reminderName;
                
                ItemToAddinArraySend.itemAlarm = [dateFormat stringFromDate:itemtem.alarm];
                
                ItemToAddinArraySend.itemRepeat = itemtem.recurring;
                ItemToAddinArraySend.itemNote = itemtem.note;
                ItemToAddinArraySend.itemStatus = (int)itemtem.item_statuss;
                
                [parameterItemsArray addObject:ItemToAddinArraySend];
               // NSLog(@"serverCatItemId:%d and clientItemId %d and itemStatus %d",(int)itemtem.cat_id_server,(int)itemtem.reminderID,(int)itemtem.item_statuss);
                
                
                
                
              
            }
            
            
        }
        
        for (ReminderObject * filestem in filesArrayFULL){
           // NSLog(@"filestem.should_send_file %d item_id= %d",(int)filestem.should_send_file,filestem.reminderID);
            if((int)filestem.should_send_file == 1){
                
                NSLog(@"files a eviar timestamp %d",filestem.file_timestamp);
                FileObj * FileToAddinArraySend = [[FileObj alloc]init];
                FileToAddinArraySend.clientFileID = (int)filestem.id_file;
                FileToAddinArraySend.serverFileID = (int)filestem.server_file_id;
                FileToAddinArraySend.clientItemID = (int)filestem.reminderID;
                FileToAddinArraySend.serverItemID = (int)filestem.id_server_item;
                FileToAddinArraySend.fileType = (int)filestem.file_type;
                if ((int)filestem.file_type == 1) {//imGEN DATA
                   UIImage *fot = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:filestem.file_path]scaledToSize:CGSizeMake(128.0,128.0)];
                    //UIImage * fot = [UIImage imageWithContentsOfFile:filestem.file_path];
                    NSData *dataImagen = [NSData dataWithData:UIImageJPEGRepresentation(fot, 0.5f)];//1.0f = 100% quality
                    
                    FileToAddinArraySend.fileData = dataImagen;
                    
                }else if ((int)filestem.file_type == 2){
                
                 NSData *dataAudio = [NSData dataWithContentsOfFile:filestem.file_path options:nil error:nil];
                    
                    FileToAddinArraySend.fileData= dataAudio;
                
                
                }
                
                [parameterFilesArray addObject:FileToAddinArraySend];
            }
        }
        
        
        NSLog(@"cantidad de files a enviar SyncAll=%d ",parameterFilesArray.count);
        
        
        imputservice.user = [self retrieveUSERFromUserDefaults];
        imputservice.pass = [self retrievePASSFromUserDefaults];
        imputservice.categoriesArray = parameterCategoryArray;
        imputservice.itemsArray = parameterItemsArray;
        imputservice.filesArray = parameterFilesArray;
       
 /////////////call metod
        [service syncAll:imputservice];
    }
//***************************************************************
    else if([method isEqualToString:@"syncAll"]){
           RetAllArray * result = (RetAllArray*)data;
        
        /////////update the server timestmp////
       
        switch (result.globalReturn) {
            case -1:
                NSLog(@"AutError in syncAllReturn");
                break;
            case 0:
               // NSLog(@"OK");
                [self saveServerTIMESTAMPToUserDefaults:(int)result.timestamp];
                break;
            case 2:
                //the server return 2 if Isend empty arrays means that nothing is shange and Inot update timestamp
                NSLog(@"nothing sahnge all is empty syncAllReturn");
                break;
            default:
                
                break;
        }
        
        

        NSMutableArray * idsArray = result.categoriesIdsArray;
 ///////actualizo los serverCategoryId en mi database con los que estan en el server
           for(ReminderObject * catMia in categoryArrayFULL){
           
               for (IdsCategories * temids in idsArray){
               
                   if((int)temids.clientCategoryID == (int)catMia.cat_id){
                       [dao UpdateSERVERIDinTable:(int)catMia.cat_id id_server:(int)temids.serverCategoryID tableName:@"categories" ];
                       
                      
                       ////delete in my db
                       if (catMia.client_status == 1){
                           
                           NSLog(@"delete forever idclient: %d nd name %@",temids.clientCategoryID, catMia.categoryName);
                           [dao deleteCategory:temids.clientCategoryID permanently:YES];
                           
                       }

                       [dao updateSTATUSandSHOULDSENDInTable:(int)catMia.cat_id clientStatus:0 should_send:0 tableName:@"categories"];
                       //shoud_send = 0 mean NO SEND cause was just SYNC rigt now
                       //delete wen recive response
                                          }
           
               }
           }
       /////////////////////////////////////////////////////////////////////
          NSMutableArray * idArraysItems = result.itemsIdsArray;
           for(ReminderObject * itemMio in itemsArrayFULL){
               
               for (IdsItems * temids in idArraysItems){
                   
                   if((int)temids.clientItemID == (int)itemMio.reminderID){
                      // NSLog(@"Update Item %d whit serverItemID %d",(int)itemMio.reminderID,(int)temids.serverItemID );
                       [dao UpdateSERVERIDinTable:(int)itemMio.reminderID id_server:(int)temids.serverItemID tableName:@"items" ];
                       
                       [dao updateSTATUSandSHOULDSENDInTable:(int)itemMio.reminderID clientStatus:0 should_send:0 tableName:@"items"];
                       //shoud_send = 0 mean NO SEND cause was just SYNC rigt now
                       //delete in my db when recive response
                       if (itemMio.item_statuss == 1){
                           [dao deleteItem:itemMio.reminderID permanently:YES];
                           
                       }
                   }
               
               }
               
           }
        /////////////////////////////////////////////////////////////////////
        NSMutableArray * idArraysfiles = result.filesIdsArray;
        for(ReminderObject * fileMio in filesArrayFULL){
            
            for (IdsFiles * temids in idArraysfiles){
               
                if ((int)fileMio.id_file == (temids.clientFileID)) {
                    //NSLog(@"ReturnSyncAll ClientFileId: %d  ServerFileId: %d  ServerFilType: %d",temids.clientFileID,temids.serverFileID, temids.fileType);
                   
                    [dao UpdateFileTIMESTAMP:temids.clientFileID file_timestamp:[self retrieveTIMESTAMPFromUserDefaults]];
                    [dao UpdateSERVERIDinTable:temids.clientFileID id_server:(int)temids.serverFileID tableName:@"item_files"];
                    
                    //shoud_send = 0 mean NO SEND cause was just SYNC rigt now
                    
                    [dao UpdateSHOULDSendinFILESbyType:temids.clientFileID file_type:temids.fileType should_send:0 comeFroMSync:YES];
                    
                    //delete when recive response

                    if ((int)fileMio.client_status == 1) {
                        [dao deleteFiles:temids.clientFileID permanently:YES];
                    }
                }
                
            }
            
        }
   //call saresChek
        [service checkShares:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults]];

        
        [Syncalert dismissWithClickedButtonIndex:0 animated:YES];
        SyncLogo.enabled = YES;

/////*******************************
    }
    else if ([method isEqualToString:@"checkShares"]) {
        checkSharesRet * result = (checkSharesRet*)data;
        NSLog(@"shekshares return: globalreturn %d friendMail %@ categorytoshare: %d",result.globalReturn,result.friendEmail,result.serverCategoryID);
        if (result.globalReturn == 0) {
            self.serverCategoryIdshare = result.serverCategoryID;
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Share confirmation"
    message:[NSString stringWithFormat:@"Your friend %@ want to share whit you!", result.friendEmail]
                               
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Accept!",nil];
        alert1.tag=546;
        [alert1 show];
        }
        
    }else if ([method isEqualToString:@"shareConfirm"]){
        shareConfirmRet * result = (shareConfirmRet *)data;
        
       // NSLog(@"%d,%d,%@",result.globalReturn,result.serverCategoryID,result.categoryName);
        //tool tips
        if (result.globalReturn==0) {
            
            [navBarRigthButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
            
            [self performSelector:@selector(test:) withObject:navBarRigthButtonPopTipView afterDelay:5];

        }
        
        
    }
    
}
// CMPopTipViewDelegate method

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // Any cleanup code, such as releasing a CMPopTipView instance variable, if necessary
}

-(void)test:(CMPopTipView*)x{
    
    [x dismissAnimated:YES];
}
-(void)proxyRecievedError:(NSException *)ex InMethod:(NSString *)method{
    NSLog(@"ERROR in %@ -- NSException.name=%@, NSException.reason=%@, callStackSymbols %d ",method,ex.name,ex.reason,[ex callStackSymbols].count);
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Sorry, no response, try later"
                                                    message:@""
                          
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil,nil];
    
    [Syncalert dismissWithClickedButtonIndex:0 animated:YES];
    SyncLogo.enabled = YES;
    [alert1 show];

}

-(void)addCategoryAction:(id)sender{
    
    [self performSegueWithIdentifier:@"add_categoryV2" sender:sender];
}
-(void)orderAction:(id)sender{
    
    [self.tableView setEditing:YES animated:YES];
}

//store ide category in NSUserDfauls
-(void)saveToUserDefaults:(NSInteger*)ID_CAT color:(NSString*)color
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:ID_CAT forKey:@"ID_CAT"];
        
        [standardUserDefaults setObject:color forKey:@"COLOR"];
        [standardUserDefaults synchronize];
    }
}
-(void)saveServerFILETimestampToUserDefaults:(NSInteger*)FILE_TIMESTAMP
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:FILE_TIMESTAMP forKey:@"FILE_TIMESTAMP"];
        
        
        [standardUserDefaults synchronize];
    }
}

-(void)saveServerTIMESTAMPToUserDefaults:(NSInteger*)TIMESTAMP
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:TIMESTAMP forKey:@"TIMESTAMP"];
        
        
        [standardUserDefaults synchronize];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"edit_categorySegue"]){
        EditCategoryViewController* editCategory = segue.destinationViewController;
        
        ReminderObject* tem =[categoryArray objectAtIndex:indextoEdit.row];
        
        //pass value Idcategoria to eddit
        editCategory.IdCategoryToEdit =tem.cat_id;
        
    }else if ([segue.identifier isEqualToString:@"showreminder_segue"]) {
        [self.tableView reloadData];
        RemindersListViewController* listReminder = segue.destinationViewController;
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        idcat_selected = tem.cat_id;
        NSString *color = tem.categoryColorPic;
        [self saveToUserDefaults:idcat_selected color:color];
        listReminder.reminderObj = tem;

    }else if ([segue.identifier isEqualToString:@"shownotesegue"]) {
       // [self.tableView reloadData];
        //RemindersListViewController* listReminder = segue.destinationViewController;
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        idcat_selected = tem.cat_id;
        NSString *color = tem.categoryColorPic;
        [self saveToUserDefaults:idcat_selected color:color];
        //listReminder.reminderObj = tem;
        
    }else if ([segue.identifier isEqualToString:@"addReminderSegue"]){
        //NSLog(@"netro al add rmeinder");
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        NSString *color = tem.categoryColorPic;
        idcat_selected = tem.cat_id;
        [self saveToUserDefaults:idcat_selected color:color];
        
    }else if ([segue.identifier isEqualToString:@"addshoopingCarItemSegue"]){
        
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        NSString *color = tem.categoryColorPic;
        idcat_selected = tem.cat_id;
        [self saveToUserDefaults:idcat_selected color:color];
        
    }else if ([segue.identifier isEqualToString:@"ShowShoopingListItems"]){
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        NSString *color = tem.categoryColorPic;
        idcat_selected = tem.cat_id;
        [self saveToUserDefaults:idcat_selected color:color];

    }else if ([segue.identifier isEqualToString:@"addnote"]){
        
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        NSString *color = tem.categoryColorPic;
        idcat_selected = tem.cat_id;
        [self saveToUserDefaults:idcat_selected color:color];
    
    }
}
-(void)settingAction:(id)sender{
  
    [self performSegueWithIdentifier:@"settingsSegue" sender:sender];
}


//color fron HEX

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  return categoryArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryCell";
    
    CategoryCustomCell *cell = (CategoryCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
  
    cell.leftUtilityButtons = [self leftButtons];
    cell.delegate = self;
    ReminderObject * categTemp = [categoryArray objectAtIndex:[indexPath row]];
  
    
    //Boton round
    NSString * count = [NSString stringWithFormat:@"%d", (int)[dao getCountItemInCategory:categTemp.cat_id]];
    cell.reminderListButton.frame = CGRectMake(135.0, 180.0, 32.0, 32.0);//width and height should be same value
    cell.reminderListButton.clipsToBounds = YES;
    cell.reminderListButton.layer.cornerRadius = 16;//half of the width
    [cell.reminderListButton setTitle:count forState:UIControlStateNormal];
    
    //color al principio y en el boton redondo
    UIColor * colo = [self colorFromHexString:categTemp.categoryColorPic];
    cell.reminderListButton.backgroundColor = colo;
    cell.colorlabel.backgroundColor = colo;
    
     cell.colorlabel.layer.cornerRadius = 5.0;
    cell.colorlabel.layer.masksToBounds = YES;

    cell.reminderListButton.hidden=NO;
    // add action to the round button to conditional show list
    [cell.reminderListButton addTarget:self
                                action:@selector(ShowItemsAction:)
                      forControlEvents:UIControlEventTouchUpInside];

    
    //NSLog(@"Status %@ =---> %d and serverID %d and clientid %d",categTemp.categoryName,categTemp.client_status,categTemp.cat_id_server, categTemp.cat_id);
    
    //put icon if is sync or not..
    
    if(categTemp.cat_id_server == 0){ //is sync whit server
       [cell.iconbutonType setHidden:YES];
    }else
       [cell.iconbutonType setHidden:NO];
    
    //name button and add action to conditional add acoording type
    catNameButton = cell.categoryNameButon;
    [catNameButton setTitle:categTemp.categoryName forState:UIControlStateNormal];
    [catNameButton addTarget:self
                      action:@selector(addItemsAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if ([count isEqualToString:@"0"] || tableView.editing) {
        cell.reminderListButton.hidden=YES;
        
    }
    
    return cell;
}

-(void)addItemsAction:(id)sender{
    CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
    
    NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
   ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
    //NSLog(@"type %d",(int)tem.categoryType);
    switch ((int)tem.categoryType) {
        case 0:
            [self performSegueWithIdentifier:@"addshoopingCarItemSegue" sender:sender];
            break;
        case 1:
            [self performSegueWithIdentifier:@"addReminderSegue" sender:sender];
            break;
        case 2:
            [self performSegueWithIdentifier:@"addnote" sender:sender];
            break;
        default:
            break;
    }
    

}
-(void)ShowItemsAction:(id)sender{
    CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
    
    NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
    ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
   
    switch ((int)tem.categoryType) {
        case 0:
            [self performSegueWithIdentifier:@"ShowShoopingListItems" sender:sender];
            // NSLog(@"type %d y mostrarshopinglist",(int)tem.categoryType);
            break;
        case 1:
            [self performSegueWithIdentifier:@"showreminder_segue" sender:sender];
            break;
        case 2:
           [self performSegueWithIdentifier:@"shownotesegue" sender:sender];
            break;
        default:
            break;
    }




}
-(NSArray*)leftButtons{
    leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                icon:[UIImage imageNamed:@"edit-32.png"]];
    //when reorder this button apear so i make it transparest
    UIColor* colorOfDeleteButton;
   // if ([editButton.title isEqualToString:@"Done"]) {
      //  colorOfDeleteButton = [UIColor clearColor];
   // }else
        colorOfDeleteButton = [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:colorOfDeleteButton icon:[UIImage imageNamed:@"trash-32.png"]];
     
    
    return leftUtilityButtons;


}
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id ob = [categoryArray objectAtIndex:destinationIndexPath.row];
    
    [categoryArray replaceObjectAtIndex:destinationIndexPath.row withObject:[categoryArray objectAtIndex:sourceIndexPath.row]];
    [categoryArray replaceObjectAtIndex:sourceIndexPath.row withObject:ob];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - SWTableViewDelegate

-(BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
        return NO;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;

}
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
   /*
    switch (index) {
       
        case 0:
        {
            NSLog(@"edit button was pressed");
            indextoEdit = [self.tableView indexPathForCell:cell];
            ReminderObject *cat = [categoryArray objectAtIndex:[indextoEdit row]];
            if ([dao getCountItemInCategory:cat.cat_id] == 0 ) {
                [self performSegueWithIdentifier:@"edit_categorySegue" sender:nil];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to edit"
                                                                message:@"Delete its contents first"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil,nil];
                
                [alert show];

            }
           
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            NSLog(@"Delete button was pressed");

            
            //[self.tableView beginUpdates];
            indextoDelete = [self.tableView indexPathForCell:cell];
            
            
            //presenting alert
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                                message:@"Delete this category and its contents?"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"Cancel",nil];
           [cell hideUtilityButtonsAnimated:NO];

                [alert show];
                //move the delete logic to Alert delegate
            
            }
           // [self.tableView endUpdates];
            [self.tableView reloadData];
           
            
         
    }*/
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 546) { //confirmation sahre alert
        
        if (buttonIndex==0) { //cancel press
          
            [self.service shareConfirm:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults] :(int)self.serverCategoryIdshare :0];
            
            
            
            
            

            
        }else if (buttonIndex == 1){// acept! press
           
            [self.service shareConfirm:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults] :(int)self.serverCategoryIdshare :1];
            
            
            
        }
        
    }

}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
      
       //[self.tableView reloadData];
        [self viewWillDisappear:YES];
        [self viewWillAppear:YES];
    }
}
-(NSString*)retrieveUSERFromUserDefaults{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"USER"];
    
    return val;
    
}-(NSString*)retrievePASSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"PASSW"];
    
    return val;
    
}

-(void)SyncAll:(id)sender{
    
    if ([Globals hasConnectivity]) {
        
    
    
    SyncLogo.enabled = NO;
        filesArrayFULL = [dao getFilesListwhitDeletedRowsIncluded:-1 whitDeletedRowsIncluded:YES];
    [navBarRigthButtonPopTipView dismissAnimated:YES];
    ///////////antes de llamar a syncall check if smt new/////
    GetQueryArray * inputchekUpdates = [[GetQueryArray alloc]init];
   
    
    inputchekUpdates.user = [self retrieveUSERFromUserDefaults];
    inputchekUpdates.pass = [self retrievePASSFromUserDefaults];
    inputchekUpdates.timestamp =(int)[self retrieveTIMESTAMPFromUserDefaults];//globaltimestamp
    
    NSMutableArray *parameterFilesArray = [[NSMutableArray alloc]init];
    
    for (ReminderObject * filestem in filesArrayFULL){
   GetQueryFileObj * Send = [[GetQueryFileObj alloc]init];
        Send.fileTimestamp = (int)filestem.file_timestamp;
        Send.serverFileID = (int)filestem.server_file_id;
        Send.serverItemID= (int)filestem.id_server_item;
        [parameterFilesArray addObject:Send];
    //NSLog(@"checkUpdatecall--filesArray fileTimestamp %d, server_file_id %d,Id_server_item %d",Send.fileTimestamp,Send.serverFileID,Send.serverItemID);
    }
    inputchekUpdates.filesArray = parameterFilesArray;
    
    
    [service checkUpdates:inputchekUpdates];
  
    Syncalert = [[UIAlertView alloc] initWithTitle:@"Sync.."
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [Syncalert show];
        
    }else{
    UIAlertView * errorconectiondialog = [[UIAlertView alloc] initWithTitle:@"Please check your Internet connection!"
                                           message:nil
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    [errorconectiondialog show];
    }
}
@end
