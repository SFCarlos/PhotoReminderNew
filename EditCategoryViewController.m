//
//  EditCategoryViewController.m
//  PhotoReminderNew
//
//  Created by User on 15.05.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "NKOColorPickerView.h"
#import "iToast.h"
#import "returnArrayIds.h"
@interface EditCategoryViewController ()<UIAlertViewDelegate>
@property (nonatomic,retain) iOSServiceProxy* service;

@end

@implementation EditCategoryViewController{
    UIBarButtonItem *doneButton;
UIColor* colorcito_selected;
    UIColor* colorEdit;
    ReminderObject* categoryToEdit;
}

@synthesize Pickercontainer;
@synthesize dao;
@synthesize categoryName;
@synthesize IdCategoryToEdit;
@synthesize typeSegmentedContlos;
@synthesize service;

//*****8 Color picker buttons***
@synthesize selectedButomcolor;

@synthesize color1;
@synthesize color2;
@synthesize color3;
@synthesize color4;
@synthesize color5;
@synthesize color6;
@synthesize color7;
@synthesize color8;
@synthesize color9;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//setup the colors buttons
-(void)SetUpColorsButtons{

    
    [color1 setBackgroundColor:[UIColor colorWithRed:0.95 green:0.35 blue:0.29 alpha:1.0]];
    color1.layer.cornerRadius = 8.0;
        color1.layer.masksToBounds = YES;
    
    
    [color2 setBackgroundColor:[UIColor colorWithRed:0.23 green:0.18 blue:0.18 alpha:1.0]];
    color2.layer.cornerRadius = 8.0;
    color2.layer.masksToBounds = YES;
    
    
    [color3 setBackgroundColor:[UIColor colorWithRed:1.00 green:0.91 blue:0.00 alpha:1.0]];
    color3.layer.cornerRadius = 8.0;
    color3.layer.masksToBounds = YES;
    
    
    [color4 setBackgroundColor:[UIColor colorWithRed:0.44 green:0.66 blue:0.86 alpha:1.0]];
    color4.layer.cornerRadius = 8.0;
    color4.layer.masksToBounds = YES;
    
    [color5 setBackgroundColor:[UIColor colorWithRed:0.25 green:0.60 blue:0.05 alpha:1.0]];
    
    color5.layer.cornerRadius = 8.0;
    color5.layer.masksToBounds = YES;
    
    
    [color6 setBackgroundColor:[UIColor colorWithRed:0.65 green:0.30 blue:0.47 alpha:1.0]];
    
    color6.layer.cornerRadius = 8.0;
    color6.layer.masksToBounds = YES;
    
    
    
    [color7 setBackgroundColor:[UIColor colorWithRed:1.00 green:0.60 blue:0.00 alpha:1.0]];
    
    color7.layer.cornerRadius = 8.0;
    color7.layer.masksToBounds = YES;
    
    
    [color8 setBackgroundColor:[UIColor colorWithRed:0.25 green:0.60 blue:0.05 alpha:1.0]];
    
    color8.layer.cornerRadius = 8.0;
    color8.layer.masksToBounds = YES;
    
    
    [color9 setBackgroundColor:[UIColor cyanColor]];
    
    color9.layer.cornerRadius = 8.0;
    color9.layer.masksToBounds = YES;
    



}

//color fron HEX
-(UIColor *)colorFromHexString:(NSString *)hexString {
    if (hexString != nil) {
        
        
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1]; // bypass '#' character
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
    return nil;
}
- (NSString *) htmlFromUIColor:(UIColor *)_color {
    
    if (CGColorGetNumberOfComponents(_color.CGColor) < 4) {
        
        const CGFloat *components = CGColorGetComponents(_color.CGColor);
        
        _color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
        
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(_color.CGColor)) != kCGColorSpaceModelRGB) {
        
        return [NSString stringWithFormat:@"#FFFFFF"];
        
    }
    
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(_color.CGColor))[0]*255.0), (int)((CGColorGetComponents(_color.CGColor))[1]*255.0), (int)((CGColorGetComponents(_color.CGColor))[2]*255.0)];
    
}


- (void)viewDidLoad
{
    
    self.service = [[iOSServiceProxy alloc]initWithUrl:@"http://reminderapi.cybernetlab.com/WebServiceSOAP/server.php" AndDelegate:self];
    //title
    self.navigationItem.title = @"Edit category";
    dao = [[DatabaseHelper alloc] init];
    self.navigationItem.hidesBackButton = YES;
    //categorie to edit
    
    categoryToEdit = [dao getCategorie:IdCategoryToEdit];
    
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"back-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;
    
    doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveEditedCategoryAction:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    UIBarButtonItem*Delete=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"trash-25.png"] style:UIBarStyleDefault target:self action:@selector(deleteAction:)];
    
    self.toolbarItems=[NSArray arrayWithObjects: Delete, nil];;

    categoryName.delegate = self;
    //**colorPicker***
    [self SetUpColorsButtons];
    
   //set up values to edit
   
    categoryName.text = categoryToEdit.categoryName;
    
    colorEdit = [self colorFromHexString:categoryToEdit.categoryColorPic];
    
    
    //type segmented
    NSInteger * index = categoryToEdit.categoryType;
    typeSegmentedContlos.selectedSegmentIndex = (int)index;
    
   //selected color
    selectedButomcolor.layer.cornerRadius = 6.0;
    selectedButomcolor.layer.masksToBounds = YES;
    [selectedButomcolor setBackgroundColor:colorEdit];
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.//Color did change block declaration
   /* NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        //Your code handling a color change in the picker view.
        colorcito_selected = color;
        
    };

    NKOColorPickerView *colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) color:colorEdit andDidChangeColorBlock:colorDidChangeBlock];
    
    //Add color picker to your view
    [self.Pickercontainer addSubview:colorPickerView];
    //[self.view addSubview:colorPickerView];*/
    
    
}
#pragma mark - wsdl delegate
-(void)proxydidFinishLoadingData:(id)data InMethod:(NSString *)method{
 returnArrayIds *dataTem= (returnArrayIds*)data;
    if([method isEqualToString:@"categoryEdit"]){
        
        NSLog(@"ejecuto %@ con resultado serverid %d",method,dataTem.serverID);
        if(dataTem.serverID == -1){
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"updated"];
        }else if(dataTem.serverID == -2){
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"updated"];
        }else {
            //ok retorno el id Updateo category and continue
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:dataTem.serverID clientStatus:@"updated"];
            

        }
        
        
    }else if ([method isEqualToString:@"categoryDelete"]){
     NSLog(@"ejecuto %@ con resultado serverid %d",method,dataTem.serverID);
        if(dataTem.serverID == -1){
           
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"deleted"];
        }else if(dataTem.serverID == -2){
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"deleted"];
            
        }else if(dataTem.serverID == -3){
            //smt bad incorreci catID
            //ha ocurrido error
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"deleted"];
            
        }else {
            //ok retorno el id Updateo category and continue
            NSLog(@"estoy en el delete response y este es el id retornado %d",dataTem.serverID);
            [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:dataTem.serverID clientStatus:@"deleted"];
            
            
        }

    
    
    
    }
    
    
}
-(void)proxyRecievedError:(NSException *)ex InMethod:(NSString *)method{
    NSLog(@"EXPLOTO %@ con error %@",method,ex.description);
    if([method isEqualToString:@"categoryEdit"]){
  
    }else if ([method isEqualToString:@"categoryDelete"]){
        
      
        
        
    }

    
}
-(NSInteger*)retrieveSYNCSTATUSSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"STATUS"];
    
    return val;
    
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
-(void)handleBack:(id)sender{
    
    [self performSegueWithIdentifier:@"done_category" sender:sender];
}
-(void)deleteAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:@"Delete this category and its contents?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        // Delete the row from the data source
        if([dao deleteCategory:IdCategoryToEdit]){;
            if([self retrieveSYNCSTATUSSFromUserDefaults]==1){
                [service categoryDelete:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults] :[NSString stringWithFormat:@"%d",(int)IdCategoryToEdit]];
                
                
            }else{
                //sync is of put 0 and do later
                [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"deleted"];
            
            }
        
        
        // delete and cancel all the notification reminder
        NSMutableArray * notificantionInCategory = [dao getItemList:IdCategoryToEdit itemType:-1];
        
        
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
        [self performSegueWithIdentifier:@"done_category" sender:nil];
        }
        
    }else{
        //cancel pressed nada
        
    }
    
}

-(void)saveEditedCategoryAction:(id)sender{
    NSString* COLOR;
    /*if(colorcito_selected != nil){
        COLOR = [self htmlFromUIColor:colorcito_selected];
    }else{
        COLOR = [self htmlFromUIColor:colorEdit];
    }*/
    
    COLOR = [self htmlFromUIColor:[[UIColor alloc]initWithCGColor:selectedButomcolor.layer.backgroundColor]];
    NSInteger* catType;
    
    switch (typeSegmentedContlos.selectedSegmentIndex) {
        case 0:
            catType=0;
            break;
        case 1:
            catType = 1;
            break;
        case 2:
            catType = 2;
            break;
            
        default:
            break;
    }

   
    if(categoryName.text== nil || [categoryName.text isEqualToString:@""]){
        [[[[iToast makeText:NSLocalizedString(@"Name empty", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
        
    }
    else {
       
       
        //la edito y le pongo en cliet_status = 'updated' in DBhelper
        if([dao editCategory:IdCategoryToEdit categoryName:categoryName.text categoryColor:COLOR type:(int)catType] != -1){ //if -1 no inserto
            
            //compruebo el estado de la sync
            
            if([self retrieveSYNCSTATUSSFromUserDefaults] == 1) {
                
                //si esta sync call edit in server
                
                if (categoryToEdit.cat_id_server != 0) {
                    [self.service categoryEdit:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults] :[NSString stringWithFormat:@"%d",(int)IdCategoryToEdit]  :categoryName.text :COLOR];
                    
                }else if(categoryToEdit.cat_id_server == 0 ){
                    //synlateter put 0 in serverid to  know that is not sync and put added in serverstatus to sync later
                    [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"added"];
                    
                    
                }
                //sync is off
            }else{
                //si esta sync put updateted to update later
                if (categoryToEdit.cat_id_server != 0) {
                   [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"updated"];
                    
                }else if (categoryToEdit.cat_id_server == 0 ){// no esta sync put adde to sync later
                
                [dao updateClientStatus_and_IdServerinCategory:IdCategoryToEdit Id_cat_server:0 clientStatus:@"added"];
                
                }
            
            }
                
                
                
                
            
          [self performSegueWithIdentifier:@"done_category" sender:sender];
        }//no inserto
    }
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [self.categoryName  resignFirstResponder];
    
    return YES;
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [super viewWillAppear:animated];
   
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (IBAction)color1Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
    }
- (IBAction)color2Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color3Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color4Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color5Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color6Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color7Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color8Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
- (IBAction)color9Action:(id)sender {
    UIButton * bt=sender;
    UIColor * color = [[UIColor alloc]initWithCGColor:bt.layer.backgroundColor];
    [selectedButomcolor setBackgroundColor:color];
}
@end
