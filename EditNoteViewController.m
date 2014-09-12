//
//  EditNoteViewController.m
//  PhotoReminderNew
//
//  Created by User on 04.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "EditNoteViewController.h"
#import "iToast.h"
#import "UIImage+ScalingMyImage.h"

@interface EditNoteViewController ()
@property (nonatomic, assign) BOOL should_send_audio;
@property (nonatomic, assign) BOOL should_send_photo;

@end



@implementation EditNoteViewController
{
    
    UIImage* imagenSelected;
    NSString* texto;
    NSMutableArray* imagenArray;
    NSMutableArray * audioArray;
    NSString* audioPath;
    
}


@synthesize NotetextArea;
@synthesize voiceHud;
@synthesize dao;
@synthesize marco;
@synthesize idNoteToedit;
@synthesize ImageViewSelected;
@synthesize should_send_audio;
@synthesize should_send_photo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
   }
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [NotetextArea becomeFirstResponder];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.should_send_audio = NO;
    self.should_send_photo = NO;
    
    NotetextArea.delegate=self;
    NotetextArea.layer.borderWidth = 1.0f;
    NotetextArea.layer.borderColor = [[UIColor grayColor] CGColor]; //[YounCan Use any Color For Border]
    NotetextArea.layer.cornerRadius=8.0f;
    NotetextArea.layer.masksToBounds=YES;
    
    //accecin values
    NSInteger * idcat = [self retrieveFromUserDefaults];
    
    //////**********
    //initiate DB
    dao = [[DatabaseHelper alloc] init];
    //..acces the item
    ReminderObject * item = [dao getItemwhitServerID:idNoteToedit usingServerId:NO];
    
    imagenArray = [dao get_items_PhotoPaths:idNoteToedit];
    audioArray = [dao get_items_RecordPaths:idNoteToedit];
    texto=item.note;
    self.NotetextArea.text = texto;
   
    if (imagenArray.count==0) {
        imagenSelected = nil;
        self.ImageViewSelected.image = [UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(32.0,32.0)];
    }else{
    imagenSelected = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[imagenArray firstObject]]scaledToSize:CGSizeMake(100.0,100.0)];
    self.ImageViewSelected.image = imagenSelected;
    }
    
    
    
    //record voice stuff
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    self.voiceHud.title = @"Speak Now";
    [self.voiceHud setDelegate:self];
    [self.view addSubview:self.voiceHud];
   
    
    
    
    
    UIBarButtonItem* doneButton          = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveNoteAction:)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton, nil];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveNoteAction:(id)sender{
    //collect the data
    
    
    if (NotetextArea.text == nil ||[NotetextArea.text isEqualToString:@""]||[NotetextArea.text isEqualToString:@"(null)"])
        texto = @"Item";
    else
        texto = NotetextArea.text;
    
    
    NSString * ImagenPath = [self saveImageGetPath:imagenSelected];
   
  
    
    [dao edit_item:idNoteToedit item_Name:nil alarm:nil note:texto repeat:nil itemclientStatus:0];
    ReminderObject * itemnote = [dao getItemwhitServerID:idNoteToedit usingServerId:NO];
    //mark for future sync
    if (itemnote.id_server_item != 0){ //esta sync y debo enviarla
        [dao updateSTATUSandSHOULDSENDInTable:(int)idNoteToedit clientStatus:0 should_send:1 tableName:@"items"];
    }else if (itemnote.id_server_item == 0){
        //updateo  en mi db porke server ni se entera de esta updte..pael es add
        [dao updateSTATUSandSHOULDSENDInTable:(int)idNoteToedit clientStatus:0 should_send:1 tableName:@"items"];
        
    }
    //be shure tht not send files a no ser que should_send = YES
    [dao UpdateSHOULDSendinFILESbyType:itemnote.reminderID file_type:1 should_send:0 comeFroMSync:NO];
    [dao UpdateSHOULDSendinFILESbyType:itemnote.reminderID file_type:2 should_send:0 comeFroMSync:NO];
   // NSLog(@"ShouldSndphotoFlag %d",should_send_photo);
    
        
    
    if (self.should_send_photo == YES) {
        [dao edit_item_images:itemnote.cat_id id_item:idNoteToedit file_Name:ImagenPath];
        [dao UpdateSHOULDSendinFILESbyType:idNoteToedit file_type:1 should_send:1 comeFroMSync:NO];
    }else{
        [dao UpdateSHOULDSendinFILESbyType:idNoteToedit file_type:1 should_send:0 comeFroMSync:NO];
    }
    
    if (self.should_send_audio == YES){
        [dao edit_item_recordings:itemnote.cat_id id_item:idNoteToedit file_Name:audioPath];
        [dao UpdateSHOULDSendinFILESbyType:idNoteToedit file_type:2 should_send:1 comeFroMSync:NO];
        
    }else{
        [dao UpdateSHOULDSendinFILESbyType:idNoteToedit file_type:2 should_send:0 comeFroMSync:NO];
    
    }
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)cameraAction:(id)sender {
    //present option "camera" "Gallery"
    UIActionSheet* photoPopup =[[UIActionSheet alloc]initWithTitle:@"Add photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery" ,nil];
    [photoPopup showInView:[UIApplication sharedApplication].keyWindow];
    photoPopup.tag =3;
    
}

- (IBAction)recordAction:(id)sender {
    //present option 'Record' and "play" if there one to play
    
    [self.view endEditing:YES];
    
    if (audioArray.count != 0) {
        UIActionSheet* audioPopup =[[UIActionSheet alloc]initWithTitle:@"Voice note" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Play",@"Record" ,nil];
        
        audioPopup.tag = 1;
        [audioPopup showInView:[UIApplication sharedApplication].keyWindow];
        
    }else{
        UIActionSheet* audioPopup =[[UIActionSheet alloc]initWithTitle:@"Voice note" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Record" ,nil];
        
        audioPopup.tag = 2;
        [audioPopup showInView:[UIApplication sharedApplication].keyWindow];
    }
    
    
    
}
#pragma mark - POVoiceHUD Delegate

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    
    self.should_send_audio= YES;
    
    audioPath = recordPath;
    [[[[iToast makeText:NSLocalizedString(@"Record saved", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
    
    
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
}

- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD {
    [[[[iToast makeText:NSLocalizedString(@"Record canceled", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
    self.should_send_audio= NO;
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.should_send_photo = YES;
    
    imagenSelected = [UIImage imageWithImage:info[UIImagePickerControllerOriginalImage]scaledToSize:CGSizeMake(32.0,32.0)];
    self.ImageViewSelected.image = imagenSelected;
    marco.hidden = NO;
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    NSString *pathForAudio = [NSString stringWithFormat:@"%@/Documents/%@.caf", NSHomeDirectory(),caldate];
    if(actionSheet.tag == 3){
        switch (buttonIndex) {
            case (0):
                picker.delegate = self;
                picker.allowsEditing = NO;
                picker.wantsFullScreenLayout = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, CAMERA_TRANSFORM, CAMERA_TRANSFORM);
                [self presentViewController:picker animated:YES completion:NULL];
                break;
            case (1):
                picker.delegate = self;
                picker.allowsEditing = NO;
                picker.wantsFullScreenLayout = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController:picker animated:YES completion:NULL];
                
                break;
                
            default:
                break;
                
        }
        
        //audio sheet
    }else if (actionSheet.tag == 1){
        
        //there is audio to play
        switch (buttonIndex) {
            case 0:
                [self.voiceHud playSound:audioPath];
                break;
            case 1:
                
                //record
                //name for audio
                NSLog(@"Entro al record");
                [self.voiceHud startForFilePath:pathForAudio];
                break;
                
            default:
                break;
        }
    }else if (actionSheet.tag==2){
        //no audio
        switch (buttonIndex) {
            case (0):
                //record
                [self.voiceHud startForFilePath:pathForAudio];
                
                break;
                
                
            default:
                break;
        }
        
        
        
    }
}
@end
