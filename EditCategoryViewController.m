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


@end

@implementation EditCategoryViewController{
    UIBarButtonItem *doneButton;
UIColor* colorcito_selected;
    UIColor* colorEdit;
}

@synthesize Pickercontainer;
@synthesize dao;
@synthesize categoryName;
@synthesize IdCategoryToEdit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    //title
    self.navigationItem.title = @"Edit category";
    dao = [[DatabaseHelper alloc] init];
    self.navigationItem.hidesBackButton = YES;
    
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;
    
    doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"done-24x.png"] style:UIBarStyleDefault target:self action:@selector(saveEditedCategoryAction:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    categoryName.delegate = self;
   //set up values to edit
    NSString* catName = [dao getCategoryName:IdCategoryToEdit];
    categoryName.text = catName;
    
    colorEdit = [self colorFromHexString:[dao getHexColorFronCategory:IdCategoryToEdit]];
    [super viewDidLoad];
    
    
	// Do any additional setup after loading the view.//Color did change block declaration
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        //Your code handling a color change in the picker view.
        colorcito_selected = color;
        
    };
    
    NKOColorPickerView *colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) color:colorEdit andDidChangeColorBlock:colorDidChangeBlock];
    
    //Add color picker to your view
    [self.Pickercontainer addSubview:colorPickerView];
    //[self.view addSubview:colorPickerView];
}
-(void)handleBack:(id)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshCategoriesList" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)saveEditedCategoryAction:(id)sender{
    NSString* COLOR;
    if(colorcito_selected != nil){
        COLOR = [self htmlFromUIColor:colorcito_selected];
    }else{
        COLOR = [self htmlFromUIColor:colorEdit];
    }
    
   
    if(categoryName.text== nil || [categoryName.text isEqualToString:@""]){
        [[[[iToast makeText:NSLocalizedString(@"Name empty", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
        
    }
    else if([dao editCategory:IdCategoryToEdit categoryName:categoryName.text categoryColor:COLOR]){
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshCategoriesList" object:nil];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"done_category" sender:sender];
    }else{
    [[[[iToast makeText:NSLocalizedString(@"Can not save", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
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
