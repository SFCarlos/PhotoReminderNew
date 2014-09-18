//
//  RemindersListViewController.m
//  PhotoReminder
//
//  Created by User on 08.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "RemindersListViewController.h"
#import "SWTableViewCell.h"
#import "EditReminderViewController.h"
#import "UIImage+ScalingMyImage.h"
#import "ReminderCustomCell.h"
#import "POVoiceHUD.h"
#import "Globals.h"
@interface RemindersListViewController ()
@property POVoiceHUD* voiceHud;
@end

@implementation RemindersListViewController{


NSArray * reminders;
DatabaseHelper *dao;
UISegmentedControl *segmentedContrlol;
    NSMutableArray * completed;
    NSMutableArray* active;
int CantidadActive;
    int CantidadCompleted;
NSIndexPath * indextoEdit;
    NSIndexPath * indextoDelete;
    ReminderObject * reminderToEdit;
    NSString* urltoPlay;
}
@synthesize reminderObj;
@synthesize tableView;
@synthesize dao;
@synthesize reminderArray;
@synthesize voiceHud;

- (void)viewDidLoad
{
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.SeparatorStyle=UITableViewCellSeparatorStyleNone;
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;
    //button add
    UIBarButtonItem*addReminder=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddReminder:)];
                          
    self.navigationItem.leftBarButtonItem=back;
    self.navigationItem.rightBarButtonItem = addReminder;
    
    dao = [[DatabaseHelper alloc] init];
    reminderArray = [[NSMutableArray alloc] init];
    
    NSInteger* cat_id = reminderObj.cat_id;
    reminderArray = [dao getItemListwhitDeletedRowsIncluded:cat_id itemType:-1 whitDeletedRowsIncluded:NO];
     [self LoadTheActiveList];
     //segmented contlol
    CantidadActive=active.count;
    CantidadCompleted= completed.count;
     NSArray* segmenteItems = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Active (%d)",CantidadActive],[NSString stringWithFormat:@"Completed (%d)",CantidadCompleted], nil];
     segmentedContrlol= [[UISegmentedControl alloc]initWithItems:segmenteItems];
     segmentedContrlol.selectedSegmentIndex=0;
     [segmentedContrlol addTarget:self action:@selector(onChangeSegmented:) forControlEvents:UIControlEventValueChanged];
     self.navigationItem.titleView = segmentedContrlol;
    
    
    
    
    self.navigationItem.title = reminderObj.categoryName;
    
    
    //init the audio
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
-(void)LoadTheActiveList{
    completed = [[NSMutableArray alloc]init];
    active = [[NSMutableArray alloc]init];
    ReminderObject * temf;
    for (int i = 0; i<reminderArray.count; i++) {
        temf= [reminderArray objectAtIndex:i];
        if ([temf.recurring isEqualToString:@"finished"]) {
            [completed addObject:temf];
        }else{
            [active addObject:temf];
        }
        
    }
   }
-(void)onChangeSegmented:(UISegmentedControl*)sender{
    [self.tableView reloadData];
     completed = [[NSMutableArray alloc]init];
    active = [[NSMutableArray alloc]init];
    ReminderObject * temf;
    for (int i = 0; i<reminderArray.count; i++) {
        temf= [reminderArray objectAtIndex:i];
        if ([temf.recurring isEqualToString:@"finished"]) {
            [completed addObject:temf];
        }else{
            [active addObject:temf];
        }
        
    }
      [self.tableView reloadData];
   
    
}

-(void)handleBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}-(void)AddReminder:(id)sender{
     [self performSegueWithIdentifier:@"addreminder" sender:sender];
}

-(NSInteger*)retrieve24_12FromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"24/12"];
    
    return val;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"                   Touch Reminder for options";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (segmentedContrlol.selectedSegmentIndex == 0) {
        
        return active.count;
    }else if (segmentedContrlol.selectedSegmentIndex ==1){
        return completed.count;
    }
    return active.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ReminderCell";
    
    ReminderCustomCell *cell = (ReminderCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
   // cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
   //active
    if (segmentedContrlol.selectedSegmentIndex == 0 ){
         ReminderObject *remin;
        remin= [active objectAtIndex:[indexPath row]];
        NSMutableArray* audioPathCopy =[dao get_items_RecordPaths:remin.reminderID];
        //make completed visible or not
        if ([remin.recurring isEqualToString:@"finished"]) {
            cell.completedLabel.hidden = NO;
        }else
            cell.completedLabel.hidden = YES;
     
        
        //Foto en la imagen
        NSMutableArray * photoPathsCopy = [dao get_items_PhotoPaths:remin.reminderID];
       
        if (photoPathsCopy.count==0){
            cell.image.image =[UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(32.0,32.0)];
        }
        else{
    
            cell.image.image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[photoPathsCopy firstObject]]scaledToSize:CGSizeMake(32.0,32.0)];
        }
        //Reminder name
        cell.ReminderNameLabel.text = remin.reminderName;
        //Date depending 24 or 12
        //show 24 or 12 format in label list
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSLocale * loc = [[NSLocale alloc]initWithLocaleIdentifier:@"en_GB"];
        [format setLocale:loc];
        int * flag2412 = [self retrieve24_12FromUserDefaults];
        if(flag2412 == 1){
           
            [format setDateFormat:@"dd-MM-yyyy 'at' HH:mm"];
            cell.descritionLabel.text = [format stringFromDate:remin.alarm];
        }
        else{
            
           
            [format setDateFormat:@"dd-MM-yyyy hh:mm a"];
            cell.descritionLabel.text = [format stringFromDate:remin.alarm];
        }
           //recurring label
        cell.recurringLabel.hidden =YES;
        if ([remin.recurring isEqualToString:@"none"]) {
            cell.recurringLabel.text = @"One Time";
            cell.recurringLabel.hidden= NO;
        }else if([remin.recurring isEqualToString:@"day"]){
            cell.recurringLabel.text = @"Daily";
            cell.recurringLabel.hidden= NO;
        
        }else if([remin.recurring isEqualToString:@"week"]){
            cell.recurringLabel.text = @"Weekly";
            cell.recurringLabel.hidden= NO;
        }else if([remin.recurring isEqualToString:@"month"]){
            cell.recurringLabel.text = @"Monthly";
            cell.recurringLabel.hidden= NO;
        }else if([remin.recurring isEqualToString:@"year"]){
                cell.recurringLabel.text = @"Yearly";
            cell.recurringLabel.hidden= NO;
        
        
        }
        
        if(audioPathCopy.count == 0){
            cell.hasVoice.hidden = YES;
            
        }else
            cell.hasVoice.hidden =NO;
        return cell;

    
    }
    //completed
    else{
        ReminderObject *remin;
        remin= [completed objectAtIndex:[indexPath row]];
        
         NSMutableArray* audioPathCopy =[dao get_items_RecordPaths:remin.reminderID];
        //make completed visible or not
        if ([remin.recurring isEqualToString:@"finished"]) {
            cell.completedLabel.hidden = NO;
        }else
            cell.completedLabel.hidden = YES;
        
        //hide label
        cell.recurringLabel.hidden =YES;
        //Foto en la imagen
        NSMutableArray * photoPathsCopy =[dao get_items_PhotoPaths:remin.reminderID];
        if (photoPathsCopy.count==0){
            cell.image.image =[UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(32.0,32.0)];
        }
        else{
            
            cell.image.image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[photoPathsCopy firstObject]]scaledToSize:CGSizeMake(32.0,32.0)];
        }

        //Reminder name
        cell.ReminderNameLabel.text = remin.reminderName;
        //Date depending 24 or 12
        //show 24 or 12 format in label list
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSLocale * loc = [[NSLocale alloc]initWithLocaleIdentifier:@"en_GB"];
        [format setLocale:loc];
        int * flag2412 = [self retrieve24_12FromUserDefaults];
        if(flag2412 == 1){
           
            [format setDateFormat:@"dd-MM-yyyy 'at' HH:mm"];
            cell.descritionLabel.text = [format stringFromDate:remin.alarm];
        }
        else{
           
            [format setDateFormat:@"dd-MM-yyyy hh:mm a"];
            cell.descritionLabel.text = [format stringFromDate:remin.alarm];
        }
        
        if(audioPathCopy.count == 0){
            cell.hasVoice.hidden = YES;
            
        }else
            cell.hasVoice.hidden =NO;
        return cell;

    }
    
   }
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - SWTableViewDelegate

-(BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    return NO;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSLog(@"edit button was pressed");
            indextoEdit = [tableView indexPathForCell:cell];
            
            [self performSegueWithIdentifier:@"editreminder" sender:self];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
           // Delete button was pressed
             [tableView beginUpdates];
             indextoDelete = [tableView indexPathForCell:cell];
               
             ReminderObject *remin;
          //Active reminder delete was pressed
            if (segmentedContrlol.selectedSegmentIndex == 0 ){
               //presenting alert
               
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                                message:@"Delete this active reminder?"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:@"Cancel",nil];
                [alert show];
              //move the delete logic to Alert delegate
                [cell hideUtilityButtonsAnimated:YES];
               
            }else{
                //completed reminder delete press delete whitout alert

                remin= [completed objectAtIndex:[indextoDelete row]];
          [completed removeObjectAtIndex:[indextoDelete row]];
                CantidadCompleted= completed.count;
                [segmentedContrlol setTitle:[NSString stringWithFormat:@"Completed (%d)",CantidadCompleted] forSegmentAtIndex:1];
               [tableView deleteRowsAtIndexPaths:@[indextoDelete] withRowAnimation:UITableViewRowAnimationFade];
                
                //delete from database
                NSLog(@"resultado en delete item %d",[dao deleteItem:remin.reminderID permanently:NO]);
                
                
                //cancel the notification
                [Globals cancelAllNotificationsWhitItemID:(int)remin.reminderID];
            }
            [tableView endUpdates];
            [tableView reloadData];
            //
            // [dao InvalidateReminder:remin.reminderID recurring:@"finished"];
            
            
            
            
                break;
            }
        default:
            break;
        }
            
    }
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        //Ok presed...delete
        //move the delete logic to Alert delegate
        // Delete the row from the data source
         ReminderObject *remin;
        remin= [active objectAtIndex:[indextoDelete row]];
        
        [active removeObjectAtIndex:[indextoDelete row]];
        CantidadActive= active.count;
        [segmentedContrlol setTitle:[NSString stringWithFormat:@"Active (%d)",CantidadActive] forSegmentAtIndex:0];
        
        [tableView deleteRowsAtIndexPaths:@[indextoDelete] withRowAnimation:UITableViewRowAnimationFade];
       
        //deletelogic in sync
        [dao deleteItem:remin.reminderID permanently:NO];
        
        //mark for future sync
        if(remin.id_server_item != 0){ //esta en server database
            [dao updateSTATUSandSHOULDSENDInTable:(int)remin.reminderID clientStatus:1 should_send:1 tableName:@"items"];
            
        }else if (remin.id_server_item == 0){ //no esta en server db
            [dao deleteItem:(int)remin.reminderID permanently:YES]; //delete foreverc
            
        }

        
       
        //cancel the notification
        NSString *idtem =[NSString stringWithFormat:@"%d",(int)remin.reminderID];
        UIApplication*app =[UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++) {
            UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
            NSDictionary *userInfoIDremin = oneEvent.userInfo;
            NSString*uid=[NSString stringWithFormat:@"%@",[userInfoIDremin valueForKey:@"ID_NOT_PASS"]];
            if ([uid isEqualToString:idtem]) {
                [app cancelLocalNotification:oneEvent];
                NSLog(@"CANCELADA LA NOTIFICACION %@",uid);

                
            }
        }

    }else{
    //cancel pressed nada
    }

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"editreminder"]) {
        //[tableView reloadData];
        EditReminderViewController* edit = segue.destinationViewController;
        ReminderObject* tem;
        if (segmentedContrlol.selectedSegmentIndex==0){
       tem=[active objectAtIndex:indextoEdit.row];
        
        }else{
            tem=[completed objectAtIndex:indextoEdit.row];
        }
            
        
      
        
        edit.ReminderToEdit = tem;
        
    }
}
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
if (segmentedContrlol.selectedSegmentIndex == 0 ){
    reminderToEdit = [active objectAtIndex:indexPath.row];
}else{
reminderToEdit = [completed objectAtIndex:indexPath.row];
}
   
    NSMutableArray* audioPathArray =[dao get_items_RecordPaths: reminderToEdit.reminderID];
    indextoEdit = indexPath;
    indextoDelete=indexPath;
    
    if(audioPathArray.count == 0){
        //do not play cause does not have record atached
        
        UIActionSheet* OptionSheed =[[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Delete" ,nil];
        OptionSheed.tag = 1;
        // OptionSheed.styleId= @"action-sheet";
        [OptionSheed showInView:[UIApplication sharedApplication].keyWindow];
        
    }else
    {
        urltoPlay = (NSString*)[audioPathArray firstObject];
        UIActionSheet* PlaySheed =[[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play",@"Edit",@"Delete" ,nil];
        PlaySheed.tag=2;
        [PlaySheed showInView:[UIApplication sharedApplication].keyWindow];}


}
    
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    switch (actionSheet.tag) {
        case 1:
            //edit
            if (buttonIndex ==0) {//Edit?
                [self performSegueWithIdentifier:@"editreminder" sender:self];
            }
            //delete
            else if (buttonIndex ==1){//Delete?
                // Delete button was pressed
                //[tableView beginUpdates];
                
                ReminderObject *remin;
                //Active reminder delete was pressed
                if (segmentedContrlol.selectedSegmentIndex == 0 ){
                    //presenting alert
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                                    message:@"Delete this active reminder?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:@"Cancel",nil];
                    [alert show];
                    //move the delete logic to Alert delegate
                    
                    
                }else{
                    //completed reminder delete press delete whitout alert
                    
                    remin= [completed objectAtIndex:[indextoDelete row]];
                    [completed removeObjectAtIndex:[indextoDelete row]];
                    CantidadCompleted= completed.count;
                    [segmentedContrlol setTitle:[NSString stringWithFormat:@"Completed (%d)",CantidadCompleted] forSegmentAtIndex:1];
                    [tableView deleteRowsAtIndexPaths:@[indextoDelete] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                    //deletelogic in sync
                    [dao deleteItem:remin.reminderID permanently:NO];
                    
                    //mark for future sync
                    if(remin.id_server_item != 0){ //esta en server database
                        [dao updateSTATUSandSHOULDSENDInTable:(int)remin.reminderID clientStatus:1 should_send:1 tableName:@"items"];
                        
                    }else if (remin.id_server_item == 0){ //no esta en server db
                        [dao deleteItem:(int)remin.reminderID permanently:YES]; //delete foreverc
                        
                    }
                    
                    
                    
                    //cancel the notification
                    NSString *idtem =[NSString stringWithFormat:@"%d",(int)remin.reminderID];
                    UIApplication*app =[UIApplication sharedApplication];
                    NSArray *eventArray = [app scheduledLocalNotifications];
                    for (int i=0; i<[eventArray count]; i++) {
                        UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
                        NSDictionary *userInfoIDremin = oneEvent.userInfo;
                        NSString*uid=[NSString stringWithFormat:@"%@",[userInfoIDremin valueForKey:@"ID_NOT_PASS"]];
                        if ([uid isEqualToString:idtem]) {
                            [app cancelLocalNotification:oneEvent];
                            NSLog(@"CANCELADA LA NOTIFICACIONN %@",uid);
                            
                        }
                    }
                    
                }
             
            
                
            }

            break;
        case 2:
            //play
            if (buttonIndex ==0) {
                NSLog(@"Play: %@",urltoPlay);
                [self.voiceHud playSound:urltoPlay];
            }
            ///edit
            else if (buttonIndex ==1) {//Edit?
                [self performSegueWithIdentifier:@"editreminder" sender:self];
            }
            //delete
            else if (buttonIndex ==2){//Delete?
                // Delete button was pressed
                //[tableView beginUpdates];
                
                ReminderObject *remin;
                //Active reminder delete was pressed
                if (segmentedContrlol.selectedSegmentIndex == 0 ){
                    //presenting alert
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                                    message:@"Delete this active reminder?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:@"Cancel",nil];
                    [alert show];
                    //move the delete logic to Alert delegate
                    
                    
                }else{
                    //completed reminder delete press delete whitout alert
                    
                    remin= [completed objectAtIndex:[indextoDelete row]];
                    [completed removeObjectAtIndex:[indextoDelete row]];
                    CantidadCompleted= completed.count;
                    [segmentedContrlol setTitle:[NSString stringWithFormat:@"Completed (%d)",CantidadCompleted] forSegmentAtIndex:1];
                    [tableView deleteRowsAtIndexPaths:@[indextoDelete] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                    //deletelogic in sync
                    [dao deleteItem:remin.reminderID permanently:NO];
                    
                    //mark for future sync
                    if(remin.id_server_item != 0){ //esta en server database
                        [dao updateSTATUSandSHOULDSENDInTable:(int)remin.reminderID clientStatus:1 should_send:1 tableName:@"items"];
                        
                    }else if (remin.id_server_item == 0){ //no esta en server db
                        [dao deleteItem:(int)remin.reminderID permanently:YES]; //delete foreverc
                        
                    }
                    
                    
                    
                    //cancel the notification
                    NSString *idtem =[NSString stringWithFormat:@"%d",(int)remin.reminderID];
                    UIApplication*app =[UIApplication sharedApplication];
                    NSArray *eventArray = [app scheduledLocalNotifications];
                    for (int i=0; i<[eventArray count]; i++) {
                        UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
                        NSDictionary *userInfoIDremin = oneEvent.userInfo;
                        NSString*uid=[NSString stringWithFormat:@"%@",[userInfoIDremin valueForKey:@"ID_NOT_PASS"]];
                        if ([uid isEqualToString:idtem]) {
                            [app cancelLocalNotification:oneEvent];
                            NSLog(@"CANCELADA LA NOTIFICACIONN %@",uid);
                            
                        }
                    }
                    
                }
                
                
                
            }

        default:
            break;
    }
    
    
    }


@end
