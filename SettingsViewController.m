//
//  SettingsViewController.m
//  PhotoReminder
//
//  Created by User on 09.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface SettingsViewController ()

@end

@implementation SettingsViewController{
    
    AVAudioPlayer * cellTapSound;
    NSArray * sounfFiles;
    NSString* selectedSound;
    NSString* alreadyselectedSound;
}
@synthesize scrollV;
@synthesize userImput;
@synthesize passwImput;
@synthesize registerButton;
@synthesize timeformatSwitch;
@synthesize syncSwitch;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    userImput.delegate =self;
    passwImput.delegate=self;
    [scrollV setScrollEnabled:YES];
    //fill array sound
       sounfFiles = [[NSArray alloc] initWithObjects:@"Alarm Classic",@"Birds",@"Fire Pager",@"Frenzy",@"Siren Noise",@"Note",nil];
    //know the selected sound
    alreadyselectedSound=[self retrieveSoundReminderFromUserDefaults];
    if (selectedSound == nil) {
        selectedSound = alreadyselectedSound;
    }
    
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem* doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"done-24x.png"] style:UIBarStyleDefault target:self action:@selector(saveSettingsAction:)];
    self.navigationItem.leftBarButtonItem =doneButton;
    //swith 24/12 initial state
    int * flag = [self retrieve24_12FromUserDefaults];
    if(flag==1)
        [timeformatSwitch setOn:YES];
    else
        [timeformatSwitch setOn:NO];
    int* flagSync = [self retrieveSYNCSTATUSSFromUserDefaults];
    
    userImput.text = [self retrieveUSERFromUserDefaults];
    passwImput.text =[self retrievePASSFromUserDefaults];
     passwImput.secureTextEntry=YES;
    
    if (flagSync==1) {
        [syncSwitch setOn:YES];
        userImput.hidden= NO;
        passwImput.hidden= NO;
        registerButton.hidden = NO;
    }else{
        [syncSwitch setOn:NO];
        userImput.hidden= YES;
        passwImput.hidden= YES;
        registerButton.hidden = YES;
    }
 passwImput.secureTextEntry=YES;
    
    

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [userImput resignFirstResponder];
    [passwImput resignFirstResponder];
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return sounfFiles.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"soundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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


-(void)viewDidLayoutSubviews{
    [scrollV setContentSize:CGSizeMake(320, 700)];
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

-(void)saveSyncStatusToUserdefaults:(NSString*)user :(NSString*) passw :(NSInteger*)statuss{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:user forKey:@"USER"];
        [standardUserDefaults setObject:passw forKey:@"PASSW"];
        [standardUserDefaults setInteger:(int)statuss forKey:@"STATUS"];
        [standardUserDefaults synchronize];
    }

}


-(void)save2412ToUserDefaults:(NSInteger*)TimeFormat
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:(int)TimeFormat forKey:@"24/12"];
        [standardUserDefaults synchronize];
    }
    
}
-(void)saveSoundReminderToUserDefaults:(NSString*)SoundSelected
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:SoundSelected forKey:@"REMINDER_SOUND"];
        [standardUserDefaults synchronize];
    }
    
}

- (void)saveSettingsAction:(id)sender {
    
    

    if(timeformatSwitch.on){
        [self save2412ToUserDefaults:1];
    
    }else{
    [self save2412ToUserDefaults:0];
    }
    [self saveSoundReminderToUserDefaults:selectedSound];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
    
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
        val = [standardUserDefaults objectForKey:@"PASS"];
    
    return val;
    
}-(NSInteger*)retrieveSYNCSTATUSSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"STATUS"];
    
    return val;
    
}
-(NSInteger*)retrieve24_12FromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"24/12"];
    
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
- (IBAction)registerAction:(id)sender {
    //save locally firt //sync on
    
    //if consult
    [self saveSyncStatusToUserdefaults:userImput.text :userImput.text :1];
    
}

- (IBAction)SyncSwitchAction:(id)sender {
    if (syncSwitch.on) {
        userImput.hidden= NO;
        passwImput.hidden= NO;
        registerButton.hidden = NO;
    }else{
        userImput.hidden= YES;
        passwImput.hidden= YES;
        registerButton.hidden = YES;
    }
    
    
    
}
@end
