//
//  ShoopingListViewController.m
//  PhotoReminderNew
//
//  Created by User on 26.06.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "ShoopingListViewController.h"
#import "ShoppingItemCustomCell.h"
#import "UIImage+ScalingMyImage.h"

@interface ShoopingListViewController (){
    
    NSMutableArray * shoopingItemsArray;
    UIBarButtonItem * home;
    UIBarButtonItem * done;
}

@end

@implementation ShoopingListViewController
@synthesize dao;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init the arrays
    dao = [[DatabaseHelper alloc] init];
    shoopingItemsArray = [[NSMutableArray alloc] init];
    shoopingItemsArray = [dao getItemList:[self retrieveFromUserDefaults] itemType:-1];
    self.navigationItem.hidesBackButton = YES;
    home = [[UIBarButtonItem alloc]
               initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    /*done          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(doneAction:)];*/
    UIBarButtonItem* girdbutton = [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"list-25.png"] style:UIBarStyleDefault target:self action:@selector(girdButtonAction:)];
    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:flexibleItem,girdbutton,flexibleItem2,home, nil];
    
   }
-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleBack:(id)sender{
       [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)doneAction:(id)sender{
 [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)girdButtonAction: (id)sender{

    [self performSegueWithIdentifier:@"ShowShoopingGirdIfotos" sender:sender];

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
    return shoopingItemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SoopingItemCell";
    
    ShoppingItemCustomCell *cell = (ShoppingItemCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    ReminderObject *itemSooping = [shoopingItemsArray objectAtIndex:[indexPath row]];
    
    //foto
    NSMutableArray * photoPathsCopy =[dao get_items_PhotoPaths:itemSooping.reminderID];
   
    if ([(NSString*)[photoPathsCopy firstObject]isEqualToString:@"(null)"] ){
       
        
        cell.image.image =  [UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(32.0,32.0)];
        
    }
    else{
        
        cell.image.image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[photoPathsCopy firstObject]]scaledToSize:CGSizeMake(32.0,32.0)];
        
    }

    cell.shoopingItemDescrip.text= itemSooping.reminderName;
    
    return cell;

}
#pragma mark - SWTableViewDelegate
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"                   Slide to left to edit";
}
-(BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state{
    return YES;
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
     
     NSLog(@"edit button was pressed");
         
     
    
     break;
     
         case 1:{
           NSLog(@"delete button was pressed");
             ReminderObject *remin;
             remin= [shoopingItemsArray objectAtIndex:index];
             
             NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
             
             [shoopingItemsArray removeObjectAtIndex:cellIndexPath.row];
             [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                   withRowAnimation:UITableViewRowAnimationAutomatic];
             NSLog(@"resultado en delete item %d",[dao deleteItem:remin.reminderID]);
         
         
         }
     break;
        
     default:
             break;
     
     
     
    
     }
}




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

@end
