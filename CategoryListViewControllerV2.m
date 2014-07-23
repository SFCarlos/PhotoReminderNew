//
//  CategoryListViewControllerV2.m
//  PhotoReminderNew
//
//  Created by User on 27.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "CategoryListViewControllerV2.h"

#import "RemindersListViewController.h"
#import "EditCategoryViewController.h"
#import "CategoryCustomCell.h"
#import "AppDelegate.h"
#import "returnArrayIds.h"
@interface CategoryListViewControllerV2 ()
@property (nonatomic,retain) iOSServiceProxy* service;

@end

@implementation CategoryListViewControllerV2{
    NSMutableArray *categoryArray;
    NSMutableArray *categoryArrayFULL;
    NSIndexPath * indextoEdit;
    NSIndexPath * indextoDelete;
    NSMutableArray *leftUtilityButtons;
    UIButton* catNameButton;
    UIButton* showitemsListButton;
    NSInteger* flagSyncSTatus;
    UIBarButtonItem *setting ;
    UIBarButtonItem* SyncLogo;
    UIBarButtonItem * addCategory;
    
    NSInteger* id_cat_addservice;
    NSInteger* id_cat_deleteservice;
    NSInteger* id_cat_editservice;
    

}
@synthesize dao;
@synthesize service;

-(NSInteger*)retrieveSYNCSTATUSSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"STATUS"];
    
    return val;
    
}

- (void)viewDidLoad
{
    self.service = [[iOSServiceProxy alloc]initWithUrl:@"http://reminderapi.cybernetlab.com/WebServiceSOAP/server.php" AndDelegate:self];
    
    
    
    //init the arrays
    dao = [[DatabaseHelper alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    categoryArrayFULL = [[NSMutableArray alloc] init];
    categoryArray = [dao getCategoryListwhitDeletedRowsIncluded:NO];
    categoryArrayFULL = [dao getCategoryListwhitDeletedRowsIncluded:YES];
          setting = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"settings-25x.png"] style:UIBarStyleDefault target:self action:@selector(settingAction:)];
    
    SyncLogo = [[UIBarButtonItem alloc]
                initWithImage:[UIImage imageNamed:@"link-25.png"] style:UIBarStyleDefault target:self action:@selector(SyncAll:)];
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
}
-(void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //[self.tableView reloadData];
    
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
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];

}
#pragma mark - wsdl delegate
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString *)method{
   
   returnArrayIds *dataTem= (returnArrayIds*)data;
    if([method isEqualToString:@"categorySync"]){
        NSLog(@"result.>>>> idclient %d and idserver %d",dataTem.clientID,dataTem.serverID);
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
      
    }

}
-(void)proxyRecievedError:(NSException *)ex InMethod:(NSString *)method{
    [self.tableView reloadData];
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"EXPLOTO %@ con error %@ ",method,ex.description);
       
    
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
    cell.reminderListButton.hidden=NO;
    // add action to the round button to conditional show list
    [cell.reminderListButton addTarget:self
                                action:@selector(ShowItemsAction:)
                      forControlEvents:UIControlEventTouchUpInside];

    
    NSLog(@"Status %@ =---> %@ and serverID %d and clientid %d",categTemp.categoryName,categTemp.client_status,categTemp.cat_id_server, categTemp.cat_id);
    
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
    NSLog(@"type %d",(int)tem.categoryType);
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
             NSLog(@"type %d y mostrarshopinglist",(int)tem.categoryType);
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
    if (buttonIndex==0) {
        // Delete the row from the data source
        ReminderObject *cate = [categoryArray objectAtIndex:[indextoDelete row]];
        [dao deleteCategory:cate.cat_id];
        [categoryArray removeObjectAtIndex:indextoDelete.row];
        [self.tableView deleteRowsAtIndexPaths:@[indextoDelete] withRowAnimation:UITableViewRowAnimationFade];
        
        
        // delete and cancel all the notification reminder
        NSMutableArray * notificantionInCategory = [dao getItemList:cate.cat_id itemType:-1];
        NSString *idtem =[NSString stringWithFormat:@"%d",(int)cate.reminderID];
        UIApplication*app =[UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++) {
            
            for (int j=0; j<[notificantionInCategory count]; j++){
                UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
                NSDictionary *userInfoIDremin = oneEvent.userInfo;
                NSString*uid=[NSString stringWithFormat:@"%@",[userInfoIDremin valueForKey:@"ID_NOT_PASS"]];
                ReminderObject * iuy=[notificantionInCategory objectAtIndex:j];
                NSString *remindId =[NSString stringWithFormat:@"%d",(int)iuy.reminderID];
                if([uid isEqualToString:remindId]){
                    [app cancelLocalNotification:oneEvent];
                    
                    
                    
                }
                
            }
        }
                
    }else{
        //cancel pressed nada
        
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
    for(ReminderObject* cate in categoryArrayFULL ){
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
           
     [service categorySync:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults] :[NSString stringWithFormat:@"%d",(int)cate.cat_id] :[NSString stringWithFormat:@"%d",(int)cate.cat_id]:(int)cate.categoryType :cate.categoryName :cate.categoryColorPic :cate.client_status];
     
    
    }


    categoryArray = [dao getCategoryListwhitDeletedRowsIncluded:NO];

    //[self.tableView reloadData];
     
    
}
@end
