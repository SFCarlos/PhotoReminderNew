//
//  NotificationsTableViewController.m
//  PhotoReminderNew
//
//  Created by User on 11.06.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface NotificationsTableViewController ()

@end

@implementation NotificationsTableViewController{

    AVAudioPlayer * cellTapSound;
    NSArray * sounfFiles;
    NSString* selectedSound;
    NSString* alreadyselectedSound;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSString*)retrieveSoundReminderFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"REMINDER_SOUND"];
    
    return val;
}
-(void)saveSoundReminderToUserDefaults:(NSString*)SoundSelected
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:SoundSelected forKey:@"REMINDER_SOUND"];
        [standardUserDefaults synchronize];
    }
    
}
-(void)doneAction:(id)sender{
    [self saveSoundReminderToUserDefaults:selectedSound];
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* doneButton          = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(doneAction:)];
    self.navigationItem.leftBarButtonItem =doneButton;
    
    //fill array sound
    sounfFiles = [[NSArray alloc] initWithObjects:@"Alarm Classic",@"Birds",@"Fire Pager",@"Frenzy",@"Siren Noise",@"Note",nil];
    //know the selected sound
    alreadyselectedSound=[self retrieveSoundReminderFromUserDefaults];
    if (selectedSound == nil) {
        selectedSound = alreadyselectedSound;
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return sounfFiles.count;
    }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    // Configure the cell...
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    NSString * soundName = [sounfFiles objectAtIndex: indexPath.row];
    cell.textLabel.text =soundName;
    
    
    for (int i=0; i<[sounfFiles count]; i++) {
        
        
    }
    NSString * nameSound = [sounfFiles objectAtIndex:indexPath.row];
    if ([nameSound isEqualToString:alreadyselectedSound]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString*soundname = [sounfFiles objectAtIndex:indexPath.row];
    cellTapSound = [[AVAudioPlayer alloc]initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:soundname withExtension:@"m4r"] error:nil];
    [cellTapSound prepareToPlay];
    
    if (cellTapSound.isPlaying)
        [cellTapSound setCurrentTime:0.0];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger catIndex = [sounfFiles indexOfObject:selectedSound];
    
    if (catIndex == indexPath.row) {
        
        return;
        
    }
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:catIndex inSection:0];
    
    
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        selectedSound = [sounfFiles objectAtIndex:indexPath.row];
        
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    [cellTapSound play];
    
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

@end
