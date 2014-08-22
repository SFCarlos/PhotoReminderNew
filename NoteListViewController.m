//
//  NoteListViewController.m
//  PhotoReminderNew
//
//  Created by User on 02.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "NoteListViewController.h"
#import "EditNoteViewController.h"
#import "NoteCustomCell.h"
#import "UIImage+ScalingMyImage.h"
#import "POVoiceHUD.h"
@interface NoteListViewController (){
    NSMutableArray * NoteArray;
    UIBarButtonItem * home;
    UIBarButtonItem * addNote;
    NSString* urltoPlay;
    NSIndexPath * indextoEdit;
    NSIndexPath * indextoDelete;
    ReminderObject * NoteToEdit;

}
@property POVoiceHUD* voiceHud;
@end

@implementation NoteListViewController
@synthesize dao;
@synthesize voiceHud;
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    NoteArray = nil;
   NoteArray = [dao getItemListwhitDeletedRowsIncluded:[self retrieveFromUserDefaults] itemType:-1 whitDeletedRowsIncluded:NO];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{

   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init the arrays
    dao = [[DatabaseHelper alloc] init];
    NoteArray = [[NSMutableArray alloc] init];
     NoteArray = [dao getItemListwhitDeletedRowsIncluded:[self retrieveFromUserDefaults] itemType:-1 whitDeletedRowsIncluded:NO];
    self.navigationItem.hidesBackButton = YES;
    home = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    /*done          = [[UIBarButtonItem alloc]
     initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(doneAction:)];*/
    addNote= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddNoteAction:)];
              
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:addNote,flexibleItem2,home, nil];
    
    
    //init the audio
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
}
-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}
-(void)handleBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)AddNoteAction:(id)sender{
    [self performSegueWithIdentifier:@"addnote" sender:sender];
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
    
    // Return the number of rows in the section.
    return NoteArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NoteItemCell";
    
    NoteCustomCell *cell = (NoteCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    ReminderObject *itemNote= [NoteArray objectAtIndex:[indexPath row]];
    
    //foto only one
    NSMutableArray * photoPathsCopy =[dao get_items_PhotoPaths:itemNote.reminderID];
    // audio only one
    NSString* audioPathTem =[dao get_AudioPath_item_reminder:itemNote.reminderID];
    
  //NSLog(@"potoPath in notecell: %@",[photoPathsCopy firstObject]);
    if ([(NSString*)[photoPathsCopy firstObject]isEqualToString:@"(null)"] ){
        
        
        cell.image.image =  [UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(32.0,32.0)];
        
    }
    else{
        
        cell.image.image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[photoPathsCopy firstObject]]scaledToSize:CGSizeMake(32.0,32.0)];
        
    }
    
    cell.shoopingItemDescrip.text= itemNote.note;
    if(audioPathTem == nil || [audioPathTem isEqualToString:@"(null)"]){
        cell.hasRecorButton.hidden = YES;
    
    }else
        cell.hasRecorButton.hidden =NO;
    return cell;
    
}
#pragma mark - SWTableViewDelegate
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
}
-(BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    return NO;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
    
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
            
        case 0:
            
            
            
            
            break;
            
        case 1:{
            NSLog(@"delete button was pressed ");
           
            
            
            
        }
            break;
            
        default:
            break;
            
            
            
            
    }
}
-(void)editNote:(NSInteger*)idNote{
    
}-(void)delNote:(NSInteger*)idNote{
   
   
    ReminderObject *remin;
    remin= [NoteArray objectAtIndex:indextoDelete.row];
    [NoteArray removeObjectAtIndex:indextoDelete.row];
    [self.tableView deleteRowsAtIndexPaths:@[indextoDelete]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [dao deleteItem:idNote permanently:NO];
    
    NSMutableArray * arrayFiles = [dao getFiles:idNote];
    for (ReminderObject * filesInNote in arrayFiles) {
        [dao updateSTATUSandSHOULDSENDInTable:idNote clientStatus:1 should_send:0 tableName:@"item_files"];
    }
    //mark for future sync
    if(remin.id_server_item != 0){ //esta en server database
        [dao updateSTATUSandSHOULDSENDInTable:idNote clientStatus:1 should_send:1 tableName:@"items"];
        
    }else if (remin.id_server_item == 0){ //no esta en server db
        [dao deleteItem:idNote permanently:YES]; //delete foreverc
        
    }

    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
   
    switch (actionSheet.tag) {
        case 1:
            if (buttonIndex ==0) {//Edit?
                
                NSLog(@"edit button was pressed ");
                [self performSegueWithIdentifier:@"editNoteSegue" sender:self];

                
            }else if (buttonIndex ==1){//Delete?
            
                [NoteArray removeObjectAtIndex:indextoDelete.row];
                [self.tableView deleteRowsAtIndexPaths:@[indextoDelete]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [dao deleteItem:(int)NoteToEdit.reminderID permanently:NO];
                
                //mark for future sync
                if(NoteToEdit.id_server_item != 0){ //esta en server database
                    [dao updateSTATUSandSHOULDSENDInTable:(int)NoteToEdit.reminderID clientStatus:1 should_send:1 tableName:@"items"];
                    
                }else if (NoteToEdit.id_server_item == 0){ //no esta en server db
                    [dao deleteItem:(int)NoteToEdit.reminderID permanently:YES]; //delete foreverc
                    
                }

            
            }

            break;
        case 2:
            if (buttonIndex ==0) {//Play?
                NSLog(@"Play: %@",urltoPlay);
                [self.voiceHud playSound:urltoPlay];
            }else if (buttonIndex ==1){//Edit
                NSLog(@"edit button was pressed ");
                [self performSegueWithIdentifier:@"editNoteSegue" sender:self];
            }else if (buttonIndex==2){//delete
                [NoteArray removeObjectAtIndex:indextoDelete.row];
                [self.tableView deleteRowsAtIndexPaths:@[indextoDelete]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [dao deleteItem:(int)NoteToEdit.reminderID permanently:NO];
                
                //mark for future sync
                if(NoteToEdit.id_server_item != 0){ //esta en server database
                    [dao updateSTATUSandSHOULDSENDInTable:(int)NoteToEdit.reminderID clientStatus:1 should_send:1 tableName:@"items"];
                    
                }else if (NoteToEdit.id_server_item == 0){ //no esta en server db
                    [dao deleteItem:(int)NoteToEdit.reminderID permanently:YES]; //delete foreverc
                    
                }

            }
            
            break;
        default:
            break;
    }
    }
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
   NoteToEdit = [NoteArray objectAtIndex:indexPath.row];
   NSString* audioPathTem =[dao get_AudioPath_item_reminder:NoteToEdit.reminderID];
    
    indextoEdit = indexPath;
    indextoDelete=indexPath;
    if(audioPathTem == nil || [audioPathTem isEqualToString:@"(null)"]){
        //do nothing cause does not have record atached
        
        UIActionSheet* OptionSheed =[[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Delete" ,nil];
        OptionSheed.tag = 1;
        [OptionSheed showInView:[UIApplication sharedApplication].keyWindow];
   
    }else
    {
        urltoPlay = audioPathTem;
        UIActionSheet* PlaySheed =[[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play",@"Edit",@"Delete" ,nil];
        PlaySheed.tag=2;
        [PlaySheed showInView:[UIApplication sharedApplication].keyWindow];}

    
    }
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"editNoteSegue"]) {
        //[tableView reloadData];
        EditNoteViewController* edit = segue.destinationViewController;
       ReminderObject* tem=[NoteArray objectAtIndex:indextoEdit.row];
        edit.idNoteToedit = tem.reminderID;
    }

}



@end
