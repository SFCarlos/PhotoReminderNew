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
    
    [color1 setBackgroundImage:[self imageFromColor:[UIColor colorWithRed:0.95 green:0.35 blue:0.29 alpha:1.0]]
                      forState:UIControlStateNormal];
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
    [super viewDidLoad];
    
    
    //**colorPicker***
    [self SetUpColorsButtons];
    selectedButomcolor.layer.cornerRadius = 6.0;
    selectedButomcolor.layer.masksToBounds = YES;
   
    
    /*
	// Do any additional setup after loading the view.//Color did change block declaration
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        //Your code handling a color change in the picker view.
        colorcito_selected = color;
        
    };
    
    NKOColorPickerView *colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) color:[UIColor blueColor] andDidChangeColorBlock:colorDidChangeBlock];
    
    //Add color picker to your view
   [self.Pickercontainer addSubview:colorPickerView];
   //[self.view addSubview:colorPickerView];*/
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
        id_cat_client = [dao insertCategory:categoryName.text colorPic:COLOR type:catType client_status:@"0"]; //0 id add/updated
        if((int)id_cat_client == -1){ //if -1 no inserto
                       //syn is off
             [[[[iToast makeText:NSLocalizedString(@"Problem whit insertion", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationShort]show];
            
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
