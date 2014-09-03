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

@interface EditCategoryViewController ()
@property (nonatomic,retain) iOSServiceProxy* service;

@end

@implementation EditCategoryViewController{
    UIBarButtonItem *doneButton;
UIColor* colorcito_selected;
    UIColor* colorEdit;
    ReminderObject* categoryToEdit;
    UIBarButtonItem *  shareCategory;
    NSInteger *flagSyncSTatus;
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
    
    shareCategory = [[UIBarButtonItem alloc]
                     initWithImage:[UIImage imageNamed:@"share-25.png"] style:UIBarStyleDefault target:self action:@selector(shareCategoryAction:)];

    
    //title
    self.navigationItem.title = @"Edit category";
    dao = [[DatabaseHelper alloc] init];
    self.navigationItem.hidesBackButton = YES;
    //categorie to edit
    
    categoryToEdit = [dao getCategorieWhitServerID:IdCategoryToEdit usingServerId:NO];
    
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"back-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;
    
    doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveEditedCategoryAction:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    UIBarButtonItem*Delete=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"trash-25.png"] style:UIBarStyleDefault target:self action:@selector(deleteAction:)];
    
    
    
    flagSyncSTatus = [self retrieveSYNCSTATUSSFromUserDefaults];
    if(flagSyncSTatus == 1){
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolbarItems=[NSArray arrayWithObjects: Delete,flexibleItem,shareCategory, nil];
        
    }
    else{
        self.toolbarItems=[NSArray arrayWithObjects: Delete,nil];
    }

    

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
    if([method isEqualToString:@"categoryShare"]){
        categoryShareRet * returnShare = (categoryShareRet*)data;
      // 1 bad user and pass unautorized
      // 2 Category no found
        // 3 SqlError Internal Error
        // 0 OK
        NSLog(@"GlobalReturn: %d", returnShare.globalReturn);
        switch (returnShare.globalReturn) {
            case 0:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succefully shared!"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK",nil];
                [alert show];

                break;
                    }
                
        
            default:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem whit share"
                                                             message:nil
                                                            delegate:nil
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"Cancel",nil];
                [alert show];
                    }
                break;
        }
        
        
        if (returnShare.globalReturn == 0) {
            

        }
    }
    
}
-(void)proxyRecievedError:(NSException *)ex InMethod:(NSString *)method{


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
-(void)deleteAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:@"Delete this category and its contents?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    alert.tag =908;
    [alert show];
}
-(void)shareCategoryAction:(id)sender{

    if (categoryToEdit.cat_id_server == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This category can't be share"
                                                        message:@"Please sync first"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
        [alert show];
    }else{
    
    //present alert whit email inmput
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter email of the person to share"
                                                      message:@""
                                                     delegate:self
                                              cancelButtonTitle:@"Cancel"                                          otherButtonTitles:@"Share", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        message.tag=190;
        [message show];
    }

}


-(void)handleBack:(id)sender{
    
    [self performSegueWithIdentifier:@"done_category" sender:sender];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 190) { //share alert
        if(buttonIndex == 1){
    UITextField *email = [alertView textFieldAtIndex:0];
    
    if (email != nil || [email.text isEqualToString:@""]) {
     [service categoryShare:[self retrieveUSERFromUserDefaults] :[self retrievePASSFromUserDefaults] :(int)categoryToEdit.cat_id :(int)categoryToEdit.cat_id_server :email.text];
        }
        }
    }else if (alertView.tag==908){ // delete alert
        if (buttonIndex==1) {
            if([dao deleteCategory:IdCategoryToEdit permanently:NO]){;
                //cancel notification
                NSMutableArray * items = [dao getItemListwhitDeletedRowsIncluded:IdCategoryToEdit itemType:-1 whitDeletedRowsIncluded:YES];
                UIApplication*app =[UIApplication sharedApplication];
                NSArray *eventArray = [app scheduledLocalNotifications];
                for (int i=0; i<[eventArray count]; i++) {
                    for (int j=0; j<[items count]; j++){
                        UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
                        NSDictionary *userInfoIDremin = oneEvent.userInfo;
                        NSString*uid=[NSString stringWithFormat:@"%@",[userInfoIDremin valueForKey:@"ID_NOT_PASS"]];
                        ReminderObject * iuy=[items objectAtIndex:j];
                        NSString *remindId =[NSString stringWithFormat:@"%d",(int)iuy.reminderID];
                        if([uid isEqualToString:remindId]){
                            [app cancelLocalNotification:oneEvent];
                        }
                    }
                }
                //mark for future sync
                if(categoryToEdit.cat_id_server != 0){ //esta en server database
                    [dao updateSTATUSandSHOULDSENDInTable:IdCategoryToEdit clientStatus:1 should_send:1 tableName:@"categories"];
                }else if (categoryToEdit.cat_id_server == 0){ //no esta en server db
                    [dao deleteCategory:IdCategoryToEdit permanently:YES]; //delete foreverc
                }
                [self performSegueWithIdentifier:@"done_category" sender:nil];
            }
        }else{
            //cancel pressed nada
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
    
    if (alertView.tag == 190) { //share alert evaluate email
        
    
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

   //name is mandatory
    if(categoryName.text== nil || [categoryName.text isEqualToString:@""]){
        [[[[iToast makeText:NSLocalizedString(@"Name empty", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
        
    }
    else {
       
        
        if([dao editCategory:IdCategoryToEdit categoryName:categoryName.text categoryColor:COLOR type:(int)catType] != -1){ //if -1 no edito
            
            if (categoryToEdit.cat_id_server != 0){ //esta sync y debo enviarla
                [dao updateSTATUSandSHOULDSENDInTable:(int)IdCategoryToEdit clientStatus:0 should_send:1 tableName:@"categories"];
            }else if (categoryToEdit.cat_id_server == 0){
                //updateo  en mi db porke server ni se entera de esta updte..pael es add
            [dao updateSTATUSandSHOULDSENDInTable:(int)IdCategoryToEdit clientStatus:0 should_send:1 tableName:@"categories"];
            
            }
           
          
            
            [self performSegueWithIdentifier:@"done_category" sender:sender];
            
        }else {//no edito
        [[[[iToast makeText:NSLocalizedString(@"Problen to edit", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
        }
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
