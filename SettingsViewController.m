//
//  SettingsViewController.m
//  PhotoReminder
//
//  Created by User on 09.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NotificationsTableViewController.h"
#import "CategoryListViewControllerV2.h"
#import <PixateFreestyle/PixateFreestyle.h>
@interface SettingsViewController ()
@property (strong, nonatomic) NSString* usuario;
@property (strong, nonatomic) NSString* contrasenna;

@end

@implementation SettingsViewController{

    AVAudioPlayer * cellTapSound;
    NSArray * sounfFiles;
    NSString* selectedSound;
    NSString* alreadyselectedSound;
   
    
    UITextField *username;
    UITextField *password;
    
    UITextField* usernameRegister;
    UITextField*  passwordRegister;

    BOOL *flagConnection;
    BOOL *flagSync;
}

@synthesize scrollV;
@synthesize soundselectedLabel;
@synthesize usuario;
@synthesize contrasenna;
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
    self.service = [[iOSServiceProxy alloc]initWithUrl:@"http://reminderapi.cybernetlab.com/WebServiceSOAP/server.php" AndDelegate:self];
//self.view.styleId = @"MyTable";
   // self.view.styleClass = @"tableMy";
    //first call autenticate to kow if connected;
    //[self.service autenticate:username.text :password.text];
    [scrollV setScrollEnabled:YES];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem* doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveSettingsAction:)];
    self.navigationItem.rightBarButtonItem =doneButton;
    
    //selected soud
    soundselectedLabel.text = [self retrieveSoundReminderFromUserDefaults];
    //swith 24/12 initial state
    int * flag = [self retrieve24_12FromUserDefaults];
    if(flag==1)
        [timeformatSwitch setOn:YES];
    else
        [timeformatSwitch setOn:NO];
    
    
    int* fsync = [self retrieveSYNCSTATUSSFromUserDefaults];
    int* flagconect = [self retrieveConnectionSTATUSSFromUserDefaults];
    
        //estado de la sync
    if (fsync==1) {
        flagSync =YES;
        
    }else{
        flagSync =NO;
    }
    
    //estado de conection
    if (flagconect==1) {
        flagConnection=YES;
       // connectButon.hidden=NO;
    }else{
        flagConnection=NO;
    }
//setear switc acording staus
    if(flagSync && flagConnection){
        syncSwitch.on =YES;
        connectButon.hidden=NO;
    }else if (flagSync == NO){
        syncSwitch.on =NO;
        connectButon.hidden=YES;
    
    }
    self.usuario = [self retrieveUSERFromUserDefaults];
    [connectButon setTitle:[NSString stringWithFormat:@"LogOut '%@'",usuario] forState:(UIControlStateNormal)];
    self.contrasenna =[self retrievePASSFromUserDefaults];
    self.navigationItem.title = @"Settings";
    [super viewDidLoad];
    
    NSLog(@"Usuario store in defaults %@",self.usuario);
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [soundselectedLabel setText:[self retrieveSoundReminderFromUserDefaults]];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    if(timeformatSwitch.on){
        [self save2412ToUserDefaults:1];
        
    }else{
        [self save2412ToUserDefaults:0];
    }
    
    if (syncSwitch.on) {
        [self saveSyncStatusToUserdefaults:usuario :contrasenna :1];
    }
    else{
        [self saveSyncStatusToUserdefaults:usuario:contrasenna :0];
        
    }if (flagConnection) {
        [self saveConnecctionStatusToUserdefaults:1];
    }
    else{
        [self saveConnecctionStatusToUserdefaults:0];
        
    }

    
    [super viewWillDisappear:animated];
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
        NSLog(@"ejecuto el metod %@ and result %@",method,(NSString*)data);
        //retorna -1 error
        if ([(NSString*)data isEqualToString:@"-1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Autenticate fail"
                                                            message:@"Incorrect Email or Password"
                                  
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            
             flagConnection =NO;
            flagSync=NO;
            connectButon.hidden=YES;
            [syncSwitch setOn:NO animated:YES];

        }else{
           //retorna el UserID en server
           
           
            flagConnection = YES;
            flagSync = YES;
            connectButon.hidden=NO;
            [connectButon setTitle:[NSString stringWithFormat:@"LogOut '%@'",usuario] forState:(UIControlStateNormal)];
            [syncSwitch setOn:YES animated:YES];
            
        }
        
    }if ([method isEqualToString:@"registerUser"]){
        NSNumber* resu = data;
    NSLog(@"ejecuto el metod %@ and result %@",method,resu);
        //currenlty
        if ([resu doubleValue] == -1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"%@",self.usuario]
                                                            message:[NSString stringWithFormat:@"This email is already registered"]

                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
            [alert show];
            [syncSwitch setOn:NO animated:YES];
             
        }else if([resu doubleValue] == -2){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Server said: "                                                           message:@"Empty fiels or bad email"
                                  
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil,nil];
            [alert show];

        }else {
            //return the userId in server
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",usuario]
                                                            message:@"successfully register"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil,nil];
            alert.tag =45;
            [alert show];
            
            [self.service autenticate:usuario :contrasenna];
        
            
        }
    
    
    }
    
    
}
-(void)proxyRecievedError:(NSException *)ex InMethod:(NSString *)method{

    if ([method isEqualToString:@"autenticate"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Autenticate fail"
                                                        message:@"check your connection"
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
        
        flagConnection =NO;
        flagSync=NO;
        connectButon.hidden=YES;
        [syncSwitch setOn:NO animated:YES];

    
    }else if  ([method isEqualToString:@"registerUser"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Register fail "                                                           message:@"check your connection"
                              
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,nil];
        [alert show];
        flagConnection =NO;
        flagSync=NO;
        connectButon.hidden=YES;
        [syncSwitch setOn:NO animated:YES];
               }
   }



-(void)viewDidLayoutSubviews{
    [scrollV setContentSize:CGSizeMake(320, 700)];
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


- (void)saveSettingsAction:(id)sender {
    
    
    
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
        val = [standardUserDefaults objectForKey:@"PASSW"];
    
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


- (IBAction)SyncSwitchAction:(id)sender {
    if (syncSwitch.on) {
      //new imp
      //si esta conectado muesta boton desconectarse
        flagSync=YES;
        if(flagConnection ){
            connectButon.hidden=NO;
        }
        //si no esta conectado muesta sheet con opciones
        else {
            UIActionSheet* photoPopup =[[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Login",@"Register" ,nil];
            [photoPopup showInView:[UIApplication sharedApplication].keyWindow];
        
        }
        
    }else{
        flagSync=NO;
        connectButon.hidden=YES;
       
    }
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            // login was presseed
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Login" message:@"Enter Username & Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            
            [alert textFieldAtIndex:0].text = self.usuario;
            [alert textFieldAtIndex:1].text = self.contrasenna;
            
            [alert addButtonWithTitle:@"Connect"];
            alert.tag=2;
            [alert show];
        }
     break;
            
        case 1:{
        //register was pressed
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Register" message:@"Enter Email & Password for registration" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Register", nil];
            alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            //[alert addButtonWithTitle:@"Register"];
            alert.tag=11;

            [alert show];
                    
        }
            break;
        case 2:
            [syncSwitch setOn:NO animated:YES];

            break;
        
    default:
            //cancel press
                        break;
    
    }


}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    //the connect alert
    if (alertView.tag ==2) {
      if (buttonIndex == 1)
      {
         self.usuario = [alertView textFieldAtIndex:0].text;
        self.contrasenna = [alertView textFieldAtIndex:1].text;
          
        [self.service autenticate:usuario:contrasenna];
        
      }else if (buttonIndex == 0){
      //cancel in login press
          [syncSwitch setOn:NO animated:YES];
      }
    }
    //the regiter alert
    else if (alertView.tag==11){
        if (buttonIndex == 1)
        {
          
            self.usuario = [alertView textFieldAtIndex:0].text;
            self.contrasenna = [alertView textFieldAtIndex:1].text;

            [self.service registerUser:[alertView textFieldAtIndex:0].text:[alertView textFieldAtIndex:1].text];

        }if(buttonIndex == 0){
            //cancel in register press
            [syncSwitch setOn:NO animated:YES];
        }
    }
    //log out confirmation
    else if (alertView.tag==3){
        
        if (buttonIndex == 1)
        {
            flagConnection=NO;
            [syncSwitch setOn:NO animated:YES];
            connectButon.hidden=YES;
            
        }
    
    
    } else if (alertView.tag==45){
        
        if (buttonIndex == 1)
        {
            [self.service autenticate:usuario :contrasenna];
            
        }
        
        
    }

}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.tag==11) {
    
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] > 0 && [self NSStringIsValidEmail:inputText] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    }
    return YES;
}



- (IBAction)connectButtonAction:(id)sender {
    //mostrar confirmacion de desconexion
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"log out?" message:@"Sync will be off" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    alert.tag=3;
    [alert show];
    
    }
- (IBAction)showNotificationOptionsAction:(id)sender {
    
    NotificationsTableViewController *detailViewController = [[NotificationsTableViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navController animated:YES completion:nil];
    
}
- (IBAction)CategoriesEditAction:(id)sender {
    [self performSegueWithIdentifier:@"editcategorieesList" sender:sender];
}
@end
