//
//  AddReminderV2Controller.m
//  PhotoReminder
//
//  Created by User on 28.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "AddReminderV2Controller.h"
#import "ReminderObject.h"

#import "iToast.h"
#import "LocalNotificationCore.h"

#import "YIPopupTextView.h"
#import "PMCalendar.h"
#import "ObjectHolder.h"

#import "HTAutocompleteManager.h"
#import <QuartzCore/QuartzCore.h>

#define CAMERA_TRANSFORM                    1.12412
@interface AddReminderV2Controller ()


@property (nonatomic, strong) PMCalendarController *pmCC;
@end

@implementation AddReminderV2Controller{
 NSArray * sugestionarray;
    NSString * audioPath;
    UIImage* imagenSelected;
    UIBarButtonItem *doneButton;
    UIColor * colorcito;
    NSString* textNote;
    NSDate * datecalendar;
    UIDatePicker *datePicker;
 
    
}
@synthesize MyScroll;
@synthesize pmCC;
@synthesize dao;
@synthesize colorband1;
@synthesize colorband2;
@synthesize colorband3;
@synthesize EventNametextField;

@synthesize ImageViewSelected;
@synthesize frameButton;
@synthesize DatePickerContainer;
@synthesize dateSelectedFromCalendar;
@synthesize calendarbutom;
@synthesize selectRepeat;
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
    [super viewDidLoad];
    
    CGRect pikerframe = CGRectMake(0, 0, 261, 162);
    
    datePicker = [[ObjectHolder sharedInstance]datePicker];
    [datePicker setFrame:pikerframe];
    
//check 24 or 12 and display datepicker corectly
    int * flag =[self retrieve24_12FromUserDefaults];
    NSLocale * locale;
    NSLog(@"Este es el flag 24 12 %d",flag);
    if(flag == 1){
        locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_GB"];
    }else{
        locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    [datePicker setLocale:locale];
    [DatePickerContainer addSubview:datePicker];

    
    self.navigationItem.hidesBackButton = YES;
    //back buttom
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem=back;
    UIBarButtonItem *recordButton         = [[UIBarButtonItem alloc]
                                           initWithImage:[UIImage imageNamed:@"microphone-24x.png"] style:UIBarStyleDefault target:self action:@selector(recordAction:)];
    UIBarButtonItem *addNote         = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"note-25x.png"] style:UIBarStyleDefault target:self action:@selector(addNoteAction:)];
    
 
    UIBarButtonItem *takePictureButton         = [[UIBarButtonItem alloc]
                                                  initWithImage:[UIImage imageNamed:@"camera-24x.png"] style:UIBarStyleDefault target:self action:@selector(takePictureAction:)];
    
    doneButton          = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"done-24x.png"] style:UIBarStyleDefault target:self action:@selector(saveReminderAction:)];
   
    
    
    
         //initiate DB
    dao = [[DatabaseHelper alloc] init];
    //retrive idcat
    NSInteger * idcat = [self retrieveFromUserDefaults];
        //put colors in band
  colorcito =[self colorFromHexString:[self retrieveColorFromUserDefaults]];

  colorband1.backgroundColor = colorcito;
    colorband2.backgroundColor = colorcito;
    colorband3.backgroundColor = colorcito;
    //put color in buttons hiden buton frame and band
    frameButton.hidden = YES;
        
    calendarbutom.tintColor =colorcito;
        recordButton.tintColor = colorcito;
    takePictureButton.tintColor= colorcito;
    addNote.tintColor=colorcito;
   doneButton.tintColor = colorcito;
    selectRepeat.tintColor=colorcito;
    
   // selectRepeat.transform = CGAffineTransformMakeRotation(M_PI/2.0);
  //  [self rotateSegmented];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:doneButton, takePictureButton,recordButton,addNote, nil];
    
    
    //fill array of sugestions
    sugestionarray = [dao getHistoryList:idcat];
   
    // Set a default data source for all instances. Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    self.EventNametextField.delegate = self;

    self.EventNametextField.autocompleteType= HTAutocompleteTypeColor;
    self.EventNametextField.showAutocompleteButton = YES;
    self.EventNametextField.ignoreCase = YES;
   
    //record voice stuff
    self.voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
    self.voiceHud.title = @"Speak Now";
    [self.voiceHud setDelegate:self];
    [self.view addSubview:self.voiceHud];
    
    //Date fron calendar or original
    if(dateSelectedFromCalendar != nil ){
        datePicker.date = dateSelectedFromCalendar;
    }
       [MyScroll setScrollEnabled:YES];
   
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
   
   
}
- (void)keyboardDidShow: (NSNotification *) notif{
    NSLog(@"Aparecio teclado");
    self.EventNametextField.autocompleteDisabled=NO;
    self.EventNametextField.showAutocompleteButton=YES;
}

- (void)keyboardDidHide: (NSNotification *) notif{
     NSLog(@"Aparecio teclado");
    self.EventNametextField.showAutocompleteButton=NO;
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewDidLayoutSubviews{
[MyScroll setContentSize:CGSizeMake(320, 700)];
}
-(void)handleBack:(id)sender{
   // [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshCategoriesList" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

#pragma mark YIPopupTextViewDelegate

- (void)popupTextView:(YIPopupTextView *)textView willDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    NSLog(@"will dismiss: cancelled=%d",cancelled);
    
    
    

}

- (void)popupTextView:(YIPopupTextView *)textView didDismissWithText:(NSString *)text cancelled:(BOOL)cancelled
{
    textNote = text;
    NSLog(@"did dismiss: cancelled=%d",cancelled);
}

-(void)addNoteAction:(id)sender{
    
    // NOTE: maxCount = 0 to hide count
   // self.navigationController.navigationBarHidden=YES;
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc]  initWithPlaceHolder:@"Reminder Note" maxCount:100 buttonStyle:YIPopupTextViewButtonStyleRightDone doneButtonColor:colorcito];
    popupTextView.delegate = self;
   // popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    popupTextView.keyboardAppearance=UIKeyboardAppearanceDefault;
    popupTextView.text = textNote;
    
    popupTextView.editable = YES;                  // set editable=NO to show without keyboard
    
    //[popupTextView showInView:self.view];
    [popupTextView showInViewController:self]; // recommended, especially for iOS7
    
  }

//new implementation insert in items
-(void)saveReminderAction:(id)sender{
    NSLog(@"entro save");
    
    //elementos to store
    NSInteger * idcat = [self retrieveFromUserDefaults];
    NSString * eventName = self.EventNametextField.text;
    NSDate * alarmdate = [datePicker date];
    NSString * ImagenPath = [self saveImageGetPath:imagenSelected];
    NSString* audioPathstore = audioPath;
    NSString * note =textNote;
    NSString* recurring = [self returnRecurringSelect];
    //if eventName is Empty show "Reminder"
    if([eventName isEqualToString:@""])
        eventName = @"Reminder";
    if (note == nil ||[note isEqualToString:@""]||[note isEqualToString:@"(null)"])
        note = @"Reminder";
    
    //insert in reminder
    NSInteger *id_item = [dao insert_item:idcat item_Name:eventName alarm:alarmdate note:note repeat:recurring];
    //insert image
    [dao insert_item_images:idcat id_item:id_item file_Name:ImagenPath];
//insert
    //insert in history
    BOOL resulthistory = [dao insertHistory:idcat history_desc:eventName];
    
    //NSLog(@"idcat %d eventname %@ ImagePat %@ date %@ Resultado en reminder(idreminder) %d resultado en history %hhd " ,(int)idcat,eventName,ImagenPath,alarmdate,(int)result,resulthistory);
    
    //shedule notification
    NSString *idtem =[NSString stringWithFormat:@"%d",(int)id_item];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:idtem,@"ID_NOT_PASS" ,recurring,@"RECURRING",  nil];
    
    NSString* UserSelectedSoundReminder = [self retrieveSoundReminderFromUserDefaults];
    //Set notification for firt time to select fire date and repeatin 1 min
    [[LocalNotificationCore sharedInstance]scheduleNotificationOn:alarmdate text:eventName action:@"Show" sound:UserSelectedSoundReminder launchImage:ImagenPath andInfo:data];
    
    [self performSegueWithIdentifier:@"home" sender:sender];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}
/*-(void)saveReminderAction:(id)sender{
    NSLog(@"entro save");
    
    //elementos to store
    NSInteger * idcat = [self retrieveFromUserDefaults];
    NSString * eventName = self.EventNametextField.text;
    NSDate * alarmdate = [datePicker date];
    NSString * ImagenPath = [self saveImageGetPath:imagenSelected];
    NSString* audioPathstore = audioPath;
    NSString * note =textNote;
    NSString* recurring = [self returnRecurringSelect];
   //if eventName is Empty show "Reminder"
    if([eventName isEqualToString:@""])
        eventName = @"Reminder";
    if (note == nil ||[note isEqualToString:@""]||[note isEqualToString:@"(null)"])
        note = @"Reminder";
        
        //insert in reminder
        NSInteger *result = [dao insertReminder:idcat eventname:eventName alarm:alarmdate photopath:ImagenPath audiopath:audioPath note:note recurring:recurring];
        //insert in history
        BOOL resulthistory = [dao insertHistory:idcat history_desc:eventName];
    
        //NSLog(@"idcat %d eventname %@ ImagePat %@ date %@ Resultado en reminder(idreminder) %d resultado en history %hhd " ,(int)idcat,eventName,ImagenPath,alarmdate,(int)result,resulthistory);
        
        //shedule notification
        NSString *idtem =[NSString stringWithFormat:@"%d",(int)result];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:idtem,@"ID_NOT_PASS" ,recurring,@"RECURRING",  nil];
    
    NSString* UserSelectedSoundReminder = [self retrieveSoundReminderFromUserDefaults];
  //Set notification for firt time to select fire date and repeatin 1 min
        [[LocalNotificationCore sharedInstance]scheduleNotificationOn:alarmdate text:eventName action:@"Show" sound:UserSelectedSoundReminder launchImage:ImagenPath andInfo:data];
    
    [self performSegueWithIdentifier:@"home" sender:sender];
    //[self.navigationController popToRootViewControllerAnimated:YES];
}*/
-(NSString*) returnRecurringSelect{
    NSInteger index = [selectRepeat selectedSegmentIndex];
    
    switch (index) {
        case 0:
            return @"none";
            break;
        case 1:
            return @"day";
            break;
        case 2:
            return @"week";
        case 3:
            return @"month";
            break;
        case 4:
            return @"year";
            break;

        default:
            return @"none";
            break;
    }
}
-(void)recordAction:(id)sender{
    //name for audio
    NSLog(@"Entro al record");
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *caldate = [now description];
    NSString *pathForAudio = [NSString stringWithFormat:@"%@/Documents/%@.caf", NSHomeDirectory(),caldate];
    [self.voiceHud startForFilePath:pathForAudio];

}
-(void)takePictureAction:(id)sender{

    UIActionSheet* snoozePopup =[[UIActionSheet alloc]initWithTitle:@"Add photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery" ,nil];
    [snoozePopup showInView:[UIApplication sharedApplication].keyWindow];


}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

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

}
-(NSInteger*)retrieve24_12FromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"24/12"];
    
    return val;
}

-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}
-(NSString*)retrieveColorFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"COLOR"];
    
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

// this method gets called by the system automatically when the user taps the keyboard's "Done" button
- (BOOL)textFieldShouldReturn:(HTAutocompleteTextField *)theTextField
{
    //[self.EventNametextField forceRefreshAutocompleteText];

    self.EventNametextField.autocompleteDisabled=YES;
    [self.EventNametextField  resignFirstResponder];
    
    
    return YES;
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
    
    imagenSelected = info[UIImagePickerControllerOriginalImage];
    self.ImageViewSelected.image = imagenSelected;
    frameButton.hidden= NO;
    doneButton.enabled = YES;
    //colorband3.hidden=NO;
    [picker dismissViewControllerAnimated:NO completion:NULL];

}
- (IBAction)showcalendatButton:(id)sender {
   
    if ([self.pmCC isCalendarVisible])
    {
        [self.pmCC dismissCalendarAnimated:NO];
    }
    
    BOOL isPopover = YES;
    
        self.pmCC = [[PMCalendarController alloc] initWithThemeName:@"default"];
    
    
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = NO;
    //self.pmCC.showOnlyCurrentMonth = YES; //Only show days in current month
    
            [self.pmCC presentCalendarFromView:sender
                  permittedArrowDirections:PMCalendarArrowDirectionAny
                                 isPopover:isPopover
                                  animated:YES];
    
    //le asigno la fecha actual o la seleccionada previamente
    NSDate *temdate;
    if(datecalendar == nil)//firts time in view
        temdate= [NSDate date];
    else
        temdate = [datecalendar dateByAddingTimeInterval:-3600*4];
        
        
self.pmCC.period = [PMPeriod oneDayPeriodWithDate:temdate];
    self.pmCC.allowsPeriodSelection = NO;
    self.pmCC.allowsLongPressMonthChange=YES;
   [self calendarController:pmCC didChangePeriod:pmCC.period];

    
    //[self performSegueWithIdentifier:@"ShowCalendar_segue" sender:sender];
   // CalendarViewController * calend = [[CalendarViewController alloc]init];
   // [self presentViewController:calend animated:NO completion:nil];
}
#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
   // NSLog(@"Fechaseleccionada %@", newPeriod.startDate.description);
}
-(void)calendarControllerDidDismissCalendar:(PMCalendarController*)calendarController{
NSLog(@"desaparecio");
        NSDate * dateselected = calendarController.period.startDate;
    
    //cuando se selecciona lo hace con un dia menos no se por que le adiciono un dia y es el actual
    datecalendar = [dateselected dateByAddingDays:1];
   NSDate * hoy = [NSDate date];
    NSLog(@"fecha1 %@ fecha 2 %@", datecalendar.description,[[hoy dateByAddingDays:1] dateWithoutTime].description );
    
    //si es hoy no cambiar el tiempo..
    
    if( [datecalendar.dateWithoutTime compare: [[hoy dateByAddingDays:1] dateWithoutTime]]== NSOrderedSame){
        datePicker.date =[NSDate date];
    }else{
    datePicker.date = dateselected;
    }
}

@end
