//
//  EditShoopingItemViewController.m
//  PhotoReminderNew
//
//  Created by User on 03.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "EditShoopingItemViewController.h"
#import "HTAutocompleteManager.h"
#import "UIImage+ScalingMyImage.h"
@interface EditShoopingItemViewController ()
@property (nonatomic, assign) BOOL should_send_photo;

@end

@implementation EditShoopingItemViewController{
    UIBarButtonItem * doneButton;
    UIImagePickerController *picker;
    UIImage* imagenSelected;
    NSArray * sugestionarray;
    NSMutableArray* imagenArray;
}

@synthesize nameitemTextField;
@synthesize fotoselectedImageview;
@synthesize camerabutton;
@synthesize gallerybuton;
@synthesize frameButon;
@synthesize dao;
@synthesize IdShoopingItemToEdit;
@synthesize should_send_photo;
- (void)viewDidLoad
{
    
    self.should_send_photo = NO;
    
    picker = [[UIImagePickerController alloc] init];
    //put color in buttons hiden buton frame and band
   
    /* [camerabutton setBackgroundColor:[UIColor colorWithRed:0.23 green:0.18 blue:0.18 alpha:1.0]];
     camerabutton.layer.cornerRadius = 8.0;
     camerabutton.layer.masksToBounds = YES;
     
     [gallerybuton setBackgroundColor:[UIColor colorWithRed:0.23 green:0.18 blue:0.18 alpha:1.0]];
     gallerybuton.layer.cornerRadius = 8.0;
     gallerybuton.layer.masksToBounds = YES;
     
     */
    
    NSInteger * idcat = [self retrieveFromUserDefaults];
    
    //////**********
    //initiate DB
    dao = [[DatabaseHelper alloc] init];
    //..acces the item
    ReminderObject * item = [dao getItemwhitServerID:IdShoopingItemToEdit usingServerId:NO];
   imagenArray = [dao get_items_PhotoPaths:IdShoopingItemToEdit];
    
    //fill array of sugestions
    
    sugestionarray = [dao getHistoryList:idcat];
    
    // Set a default data source for all instances. Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    self.nameitemTextField.delegate = self;
    
    self.nameitemTextField.autocompleteType= HTAutocompleteTypeColor;
    self.nameitemTextField.showAutocompleteButton = YES;
    self.nameitemTextField.ignoreCase = YES;
    self.nameitemTextField.text = item.reminderName;
    self.navigationItem.hidesBackButton = YES;
     //imagen
    if (imagenArray.count==0) {
      
        imagenSelected = nil;
       self.fotoselectedImageview.image = [UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(32.0,32.0)];
    }else{
        imagenSelected = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[imagenArray firstObject]]scaledToSize:CGSizeMake(100.0,100.0)];
    }
    self.fotoselectedImageview.image = imagenSelected;
    //*****************
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;
    doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveShoppingAction:)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton, nil];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [nameitemTextField becomeFirstResponder];
    
}
-(void)handleBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)saveShoppingAction:(id)sender{
    
    NSString* itenname;
    if (nameitemTextField.text == nil ||[nameitemTextField.text isEqualToString:@""]||[nameitemTextField.text isEqualToString:@"(null)"])
        itenname = @"Item";
    else
        itenname = nameitemTextField.text;
    
    NSString * ImagenPath = [self saveImageGetPath:imagenSelected];
    NSInteger * idcat = [self retrieveFromUserDefaults];
  
    
    ReminderObject* ShoppingItem = [dao getItemwhitServerID:IdShoopingItemToEdit usingServerId:NO];
    [dao edit_item:IdShoopingItemToEdit item_Name:itenname alarm:nil note:nil repeat:nil itemclientStatus:0];
   
    //edit logic in sync
    if (ShoppingItem.id_server_item != 0){ //esta sync y debo enviarla
        [dao updateSTATUSandSHOULDSENDInTable:(int)IdShoopingItemToEdit clientStatus:0 should_send:1 tableName:@"items"];
        
    }else if (ShoppingItem.id_server_item == 0){
        //updateo  en mi db porke server ni se entera de esta updte..pael es add
        [dao updateSTATUSandSHOULDSENDInTable:(int)IdShoopingItemToEdit clientStatus:0 should_send:1 tableName:@"items"];
        
        [dao UpdateSHOULDSendinFILESbyType:ShoppingItem.reminderID file_type:1 should_send:0 comeFroMSync:NO];
    }

   // NSLog(@"self.should_send_photo = %d",self.should_send_photo);
    if (self.should_send_photo == YES ) {
        [dao edit_item_images:ShoppingItem.cat_id id_item:ShoppingItem.reminderID file_Name:ImagenPath];
        [dao UpdateSHOULDSendinFILESbyType:ShoppingItem.reminderID file_type:1 should_send:1 comeFroMSync:NO];
    }


    
    
    //insert in history
    BOOL resulthistory = [dao insertHistory:idcat history_desc:itenname];
    
    [self performSegueWithIdentifier:@"backtolist" sender:sender];
    
}
-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}


- (NSString *)saveImageGetPath: (UIImage*)image
{
    if (image != nil)
    {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // create name for picture
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
        NSString *caldate = [now description];
        
        
        NSDateFormatter *datef = [[NSDateFormatter alloc]init];
        datef.dateFormat = @"yyyy-MM-dd--HH:mm:ss";
        NSString* namePhoto = [datef stringFromDate:[NSDate date]];
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@",docDir,caldate];
        
        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        [data2 writeToFile:jpegFilePath atomically:YES];
        return jpegFilePath;
    }else
        return nil;
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.should_send_photo = YES;
    imagenSelected = info[UIImagePickerControllerOriginalImage];
    self.fotoselectedImageview.image = imagenSelected;
    
    //colorband3.hidden=NO;
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}

- (IBAction)cameraButonAction:(id)sender forEvent:(UIEvent *)event {
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.wantsFullScreenLayout = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, CAMERA_TRANSFORM, CAMERA_TRANSFORM);
    [self presentViewController:picker animated:YES completion:NULL];}

- (IBAction)galleryButonAction:(id)sender forEvent:(UIEvent *)event {
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.wantsFullScreenLayout = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
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
