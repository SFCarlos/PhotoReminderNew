//
//  AddCategoryViewController.m
//  PhotoReminder
//
//  Created by User on 08.04.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "NKOColorPickerView.h"
#import "iToast.h"
#import <PixateFreestyle/PixateFreestyle.h>
@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController{
 UIBarButtonItem *doneButton;
    UIColor* colorcito_selected;
    NSInteger* id_cat_client;
}
@synthesize Pickercontainer;
@synthesize dao;
@synthesize categoryName;
@synthesize typesegmentedControl;


////***color Picker****
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
    
    
    [color1 setBackgroundColor:[UIColor colorWithRed:0.35 green:0.78 blue:0.98 alpha:1.0]];
    color1.layer.cornerRadius = 8.0;
    color1.layer.masksToBounds = YES;
    
    
    [color2 setBackgroundColor:[UIColor colorWithRed:1.00 green:0.80 blue:0.00 alpha:1.0]];
    color2.layer.cornerRadius = 8.0;
    color2.layer.masksToBounds = YES;
    
    
    [color3 setBackgroundColor:[UIColor colorWithRed:1.00 green:0.58 blue:0.00 alpha:1.0]];
    color3.layer.cornerRadius = 8.0;
    color3.layer.masksToBounds = YES;
    
    
    [color4 setBackgroundColor:[UIColor colorWithRed:0.00 green:0.48 blue:1.00 alpha:1.0]];
    color4.layer.cornerRadius = 8.0;
    color4.layer.masksToBounds = YES;
    
    [color5 setBackgroundColor:[UIColor colorWithRed:0.00 green:1.00 blue:0.00 alpha:1.0]];
    
    color5.layer.cornerRadius = 8.0;
    color5.layer.masksToBounds = YES;
    
    
    [color6 setBackgroundColor:[UIColor colorWithRed:1.00 green:0.23 blue:0.19 alpha:1.0]];
    
    color6.layer.cornerRadius = 8.0;
    color6.layer.masksToBounds = YES;
    
    
    
    [color7 setBackgroundColor:[UIColor colorWithRed:0.20 green:0.27 blue:0.55 alpha:1.0]];
    
    color7.layer.cornerRadius = 8.0;
    color7.layer.masksToBounds = YES;
    
    
    [color8 setBackgroundColor:[UIColor colorWithRed:0.65 green:0.30 blue:0.47 alpha:1.0]];
    
    color8.layer.cornerRadius = 8.0;
    color8.layer.masksToBounds = YES;
    
    
    [color9 setBackgroundColor:[UIColor colorWithRed:0.55 green:0.55 blue:0.56 alpha:1.0]];
    
    color9.layer.cornerRadius = 8.0;
    color9.layer.masksToBounds = YES;
    
    
    
    
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
        
    //self.view.styleClass = @"tableMy";
    
       self.navigationItem.title = @"New category";
    dao = [[DatabaseHelper alloc] init];
    self.navigationItem.hidesBackButton = YES;
    
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"back-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;

    doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveCategoryAction:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    categoryName.delegate = self;
    typesegmentedControl.styleClass=@"segmented-control";
    [super viewDidLoad];
    
    
    //**colorPicker***
    [self SetUpColorsButtons];
    selectedButomcolor.layer.cornerRadius = 6.0;
    selectedButomcolor.layer.masksToBounds = YES;
   
    
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
    [self performSegueWithIdentifier:@"done_categoryV2" sender:sender];
}
-(void)saveCategoryAction:(id)sender{
    NSString* COLOR;
    /*
    if(colorcito_selected != nil){
    COLOR = [self htmlFromUIColor:colorcito_selected];
    }else{
        COLOR = [self htmlFromUIColor:[UIColor blueColor]];
    }*/
    if(selectedButomcolor.layer.backgroundColor){
    
        COLOR = [self htmlFromUIColor:[[UIColor alloc]initWithCGColor:selectedButomcolor.layer.backgroundColor]];
    }else{
        COLOR = [self htmlFromUIColor:[UIColor blueColor]];

    }
    
       NSInteger* catType;
    
    switch (typesegmentedControl.selectedSegmentIndex) {
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
        [[[[iToast makeText:NSLocalizedString(@"Name empty", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationShort]show];

    }else {
        id_cat_client = [dao insertCategory:categoryName.text colorPic:COLOR type:catType client_status:0 should_send_cat:1]; //clientStatus 0 to piotr inser in server
                                                    //should_send_cat 1 to send in the sunc cause is new
        //update the orden, put at the end
       // int myInt = [[NSNumber numberWithFloat:[dao getCategoryListwhitDeletedRowsIncluded:NO].count] intValue];
      
       // [dao updateorden:id_cat_client orden:myInt-1];
        
       
        if((int)id_cat_client == -1){ //if -1 no inserto
                       //syn is off
             [[[[iToast makeText:NSLocalizedString(@"Problem  insertion", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationShort]show];
            
        }else
            [self performSegueWithIdentifier:@"done_categoryV2" sender:sender];
    }

    
    
    



}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [self.categoryName  resignFirstResponder];
  
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

- (IBAction)color1:(id)sender {
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
