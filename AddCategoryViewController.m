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
}
@synthesize Pickercontainer;
@synthesize dao;
@synthesize categoryName;
@synthesize typesegmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    //title
    self.navigationItem.title = @"New category";
    dao = [[DatabaseHelper alloc] init];
    self.navigationItem.hidesBackButton = YES;
    
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;

    doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"done-24x.png"] style:UIBarStyleDefault target:self action:@selector(saveCategoryAction:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    categoryName.delegate = self;
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.//Color did change block declaration
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        //Your code handling a color change in the picker view.
        colorcito_selected = color;
        
    };
    
    NKOColorPickerView *colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) color:[UIColor blueColor] andDidChangeColorBlock:colorDidChangeBlock];
    
    //Add color picker to your view
   [self.Pickercontainer addSubview:colorPickerView];
   //[self.view addSubview:colorPickerView];
}
-(void)handleBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)saveCategoryAction:(id)sender{
    NSString* COLOR;
    if(colorcito_selected != nil){
    COLOR = [self htmlFromUIColor:colorcito_selected];
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
        [[[[iToast makeText:NSLocalizedString(@"Name empty", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];

    }
    else if([dao insertCategory:categoryName.text colorPic:COLOR type:catType]){
        
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

@end
