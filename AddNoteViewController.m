//
//  AddNoteViewController.m
//  PhotoReminderNew
//
//  Created by User on 03.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "AddNoteViewController.h"

#import "iToast.h"
#import "UIImage+ScalingMyImage.h"
@interface AddNoteViewController (){
 NSString * audioPath;
     UIImage* imagenSelected;
}

@end

@implementation AddNoteViewController
@synthesize NotetextArea;
@synthesize voiceHud;
@synthesize dao;
@synthesize marco;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        textView.selectedRange = NSMakeRange(0, 0);
    });
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [NotetextArea becomeFirstResponder];
    
}

- (void)viewDidLoad
{
    imagenSelected = nil;
    [super viewDidLoad];
    NotetextArea.delegate=self;
    NotetextArea.layer.borderWidth = 1.0f;
    NotetextArea.layer.borderColor = [[UIColor grayColor] CGColor]; //[YounCan Use any Color For Border]
    NotetextArea.layer.cornerRadius=8.0f;
    NotetextArea.layer.masksToBounds=YES;
    
    //record voice stuff
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    self.voiceHud.title = @"Speak Now";
    [self.voiceHud setDelegate:self];
    [self.view addSubview:self.voiceHud];
    dao = [[DatabaseHelper alloc]init];
    
    
    marco.hidden = YES;
    
   UIBarButtonItem* doneButton          = [[UIBarButtonItem alloc]
                           initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(saveNoteAction:)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton, nil];

   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveNoteAction:(id)sender{
//collect the data
    
    NSString* itenname;
    if (NotetextArea.text == nil ||[NotetextArea.text isEqualToString:@""]||[NotetextArea.text isEqualToString:@"(null)"])
        itenname = @"Item";
    else
        itenname = NotetextArea.text;
    
    NSString * ImagenPath = [self saveImageGetPath:imagenSelected];
    NSInteger * idcat = [self retrieveFromUserDefaults];
    //insert in note
       NSInteger *id_item = [dao insert_item:idcat item_Name:nil alarm:nil note:itenname repeat:nil itemclientStatus:0 should_send_item:1];
   
    
    NSLog(@"ImagenPath %@",ImagenPath);
    if (ImagenPath == nil ||[ImagenPath isEqualToString:@""]||[ImagenPath isEqualToString:@"(null)"]){
    //es null no inserto nada
        
    }else{
        [dao insert_item_images:idcat id_item:id_item file_Name:ImagenPath];
       [dao UpdateSHOULDSendinFILESbyType:id_item file_type:1 should_send:1 comeFroMSync:NO];
    }
    
    if (audioPath == nil ||[audioPath isEqualToString:@""]||[audioPath isEqualToString:@"(null)"]){
   
    
    }else{
         //insert audio
    [dao insert_item_recordings:idcat id_item:id_item file_Name:audioPath];
    [dao UpdateSHOULDSendinFILESbyType:id_item file_type:2 should_send:1 comeFroMSync:NO];
        
        
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
    [self.view endEditing:YES];
    UIActionSheet* photoPopup =[[UIActionSheet alloc]initWithTitle:@"Add photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery" ,nil];
    [photoPopup showInView:[UIApplication sharedApplication].keyWindow];
    photoPopup.tag =3;

}

- (IBAction)recordAction:(id)sender {
    //present option 'Record' and "play" if there one to play
    
    [self.view endEditing:YES];
    
    if (audioPath) {
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
    audioPath = recordPath;
    [[[[iToast makeText:NSLocalizedString(@"Record saved", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
    
    
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
}

- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD {
    [[[[iToast makeText:NSLocalizedString(@"Record canceled", @"")]setGravity:iToastGravityBottom]setDuration:iToastDurationNormal]show];
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
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
