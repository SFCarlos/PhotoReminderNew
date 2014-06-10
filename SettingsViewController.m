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
    UITextField *username;
    UITextField *password;
    BOOL *flagConnection;
}
@synthesize scrollV;

@synthesize registerButton;
@synthesize connectButon;
@synthesize timeformatSwitch;
@synthesize syncSwitch;
@synthesize service;
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
    self.service = [[reminderServiceProxy alloc]initWithUrl:@"http://reminderapi.cybernetlab.com/WebServiceSOAP/server.php" AndDelegate:self];

    
    //first call autenticate to kow if connected;
    //[self.service autenticate:username.text :password.text];
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
    
    username.text = [self retrieveUSERFromUserDefaults];
    password.text =[self retrievePASSFromUserDefaults];
    //estado de la sync
    if (flagSync==1) {
        [syncSwitch setOn:YES];
        connectButon.hidden=NO;
        flagConnection =YES;
        [connectButon setTitle:@"Log in" forState:UIControlStateNormal];
        [connectButon setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        registerButton.hidden=NO;
        
    }else{
        [syncSwitch setOn:NO];
        flagConnection =NO;
        connectButon.hidden=YES;
        registerButton.hidden=YES;
        
       
    }
    
    //estado de la connxion
    int * connectionStatus = [self retrieveConnectionSTATUSSFromUserDefaults];
    if (connectionStatus == 1) {
        [self.service autenticate:username.text :password.text];
    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - wsdl delegate
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString *)method{
   // NSLog(@"ejecuto el metod %@ and result %@",method,(NSString*)data);
    if ([method isEqualToString:@"autenticate"]) {
        //retorna -1 error
        if ([(NSString*)data isEqualToString:@"-1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Is User or Pass correct?"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            
            [connectButon setTitle:@"Log in" forState:UIControlStateNormal];
            [connectButon setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            connectButon.hidden=NO;
            registerButton.hidden=NO;
            flagConnection =NO;
            
        }else{
           //retorna el UserID en server
           /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Welcome %@",username.text]
                                                            message:@"You are connected"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil,nil];
            [alert show];*/
          
            [connectButon setTitle:@"Log out" forState:UIControlStateNormal];
            [connectButon setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            registerButton.hidden=YES;
            flagConnection =YES;
            
        }
        
    }if ([method isEqualToString:@"registerUser"]){
        NSNumber* resu = data;
    NSLog(@"ejecuto el metod %@ and result %@",method,resu);
        //currenlty
        if ([resu doubleValue] == -1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"%@",username.text]
                                                            message:[NSString stringWithFormat:@"This email is already registered"]

                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
            [alert show];

        }else if([resu doubleValue] == -2){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Server said: "                                                           message:@"Empty fiels or bad email"
                                  
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
            [alert show];

        }else {
            //return the userId in server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",username.text]
                                                            message:@"successfully register"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil,nil];
            [alert show];
        
        
        }
    
    
    }
    
    
}
-(void)proxyRecievedError:(NSException *)ex InMethod:(NSString *)method{

    if ([method isEqualToString:@"autenticate"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error "                                                           message:[NSString stringWithFormat:@"error in function %@ ",method]
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
flagConnection =NO;
    
    }else if  ([method isEqualToString:@"registerUser"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error "                                                           message:[NSString stringWithFormat:@"error in function %@ ",method]
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
        
               }
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
//used to store the status of sync as well as user and pass
-(void)saveSyncStatusToUserdefaults:(NSString*)user :(NSString*) passw :(NSInteger*)statuss{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:user forKey:@"USER"];
        [standardUserDefaults setObject:passw forKey:@"PASSW"];
        [standardUserDefaults setInteger:(int)statuss forKey:@"STATUS"];
        [standardUserDefaults synchronize];
    }

}
-(void)saveConnecctionStatusToUserdefaults:(NSInteger*)statuss{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:(int)statuss forKey:@"CONNECTION_STATUS"];
        
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
    
    if (syncSwitch.on) {
        [self saveSyncStatusToUserdefaults:username.text :password.text :1];
    }
    else{
        [self saveSyncStatusToUserdefaults:username.text :password.text :0];
        
    }
  
    if (flagConnection) {
        [self saveConnecctionStatusToUserdefaults:1];
    }else
     [self saveConnecctionStatusToUserdefaults:0];
    
    
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
-(NSInteger*)retrieveConnectionSTATUSSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"CONNECTION_STATUS"];
    
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
    [self saveSyncStatusToUserdefaults:username.text :password.text :1];
    
    
    [service registerUser:username.text :password.text];
    
}

- (IBAction)SyncSwitchAction:(id)sender {
    if (syncSwitch.on) {
        registerButton.hidden=NO;
        connectButon.hidden=NO;
        [connectButon setTitle:@"Log in" forState:UIControlStateNormal];
        [connectButon setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        
       
    }else{
        registerButton.hidden=YES;
        connectButon.hidden=YES;
       
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
         username = [alertView textFieldAtIndex:0];
        NSLog(@"username: %@", username.text);
        password = [alertView textFieldAtIndex:1];
        NSLog(@"password: %@", password.text);
    
        [self.service autenticate:username.text :password.text];
        
    }else{
       
    }
}
- (IBAction)connectButtonAction:(id)sender {
    if ([connectButon.titleLabel.text isEqualToString:@"Log in" ]) {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Login" message:@"Enter Username & Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        if (username) {
            [alert textFieldAtIndex:0].text =username.text;
            [alert textFieldAtIndex:1].text =password.text;

        }else{
        
        [alert textFieldAtIndex:0].text =[self retrieveUSERFromUserDefaults];//username.text;
        [alert textFieldAtIndex:1].text =[self retrievePASSFromUserDefaults];//password.text;
        
        }
        [alert addButtonWithTitle:@"Connect"];
        [alert show];

    }else if ([connectButon.titleLabel.text isEqualToString:@"Log out" ]){
    
        [connectButon setTitle:@"Log in" forState:UIControlStateNormal];
        [connectButon setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        registerButton.hidden= NO;
        
    }
    }
@end
