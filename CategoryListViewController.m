//
//  RecipeViewController.m
//  CustomTableView
//


#import "CategoryLisViewController.h"
#import "RemindersListViewController.h"
#import "EditCategoryViewController.h"
#import "AddReminderV2Controller.h"

@interface CategoryListViewController ()

@end

@implementation CategoryListViewController {
    
    DatabaseHelper *dao;
    UIBarButtonItem *edit;
    UIBarButtonItem *addCategory;
    UIButton * buttonRedondoG;
    
}
@synthesize tableView;
@synthesize dao;
@synthesize categoryArray;

@synthesize reminderListButton;
@synthesize addRbutton;
@synthesize TapGestureToAddreminder;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
          /* edit = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage imageNamed:@"micro-25.png"] style:UIBarStyleDefault target:self action:@selector(editAction:)];*/
    edit=[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editAction:)];
    UIBarButtonItem *setting         = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"settings-25x.png"] style:UIBarStyleDefault target:self action:@selector(settingAction:)];
             addCategory= [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(addCategoryAction:)];
//add buttons to nav bar
    self.navigationItem.leftBarButtonItems =
    [NSArray arrayWithObjects:edit, setting, nil];
    
    //init the arrays
    dao = [[DatabaseHelper alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    categoryArray = [dao getCategoryList];
    
    
    [super viewDidLoad];

    self.navigationItem.title = @"Categories";
    /*UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];*/
    self.tabBarController.tabBar.hidden=YES;
    
        // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // Assign our own backgroud for the view
   // self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
   // self.tableView.backgroundColor = [UIColor clearColor];

    
    //Add observer to reload data after edit test1...si funciona parece pero lo resolvi poniendo ReloadData en willApear
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"RefreshCategoriesList" object:nil];
}
-(void)refresh:(NSNotification*)notification{
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated{

    [super viewWillAppear:animated];
    [tableView reloadData];

}
-(void) viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
   [self.tableView reloadData];
    
    
}
-(void)editAction:(id)sender{
    [tableView reloadData];
    if ([edit.title isEqualToString:@"Edit"] ) {
        edit.title=@"Done";
        self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:addCategory, nil];
       // buttonRedondo.hidden=YES;
        TapGestureToAddreminder.enabled = NO;
        [self.tableView setEditing:YES];
        
    }else
    {
        [self.tableView setEditing:NO];
        self.navigationItem.rightBarButtonItems = nil;
       // buttonRedondo.hidden=NO;
        TapGestureToAddreminder.enabled=YES;

        edit.title=@"Edit";
    }
    [tableView reloadData];
}
- (IBAction)EditCategoryButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"edit_categorySegue" sender:sender];
}
-(void)settingAction:(id)sender{
    [self performSegueWithIdentifier:@"settingsSegue" sender:sender];
}
-(void)addCategoryAction:(id)sender{
    
    [self performSegueWithIdentifier:@"add_category" sender:sender];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return recipes.count;
    return categoryArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
       
    }

    
   /* MKNumberBadgeView* numberb= [[MKNumberBadgeView alloc]initWithFrame:CGRectMake(5, 74, 50, 50)];
    numberb.value = 5;*/
    
    ReminderObject *cate = [categoryArray objectAtIndex:[indexPath row]];
   
    NSString * count = [NSString stringWithFormat:@"%d", (int)[dao getCountReminderInCategory:cate.cat_id]];
   
    
    
    //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
  // recipeImageView.image = [UIImage imageNamed:cate.categoryImagenPic];
    
    UIButton *categoryButtonLabel = (UIButton *)[cell viewWithTag:101];
    [categoryButtonLabel setTitle:cate.categoryName forState:UIControlStateNormal];
 
    UIButton* buttonRedondo = (UIButton *)[cell viewWithTag:103];
    buttonRedondo.frame = CGRectMake(135.0, 180.0, 32.0, 32.0);//width and height should be same value
    buttonRedondo.clipsToBounds = YES;
    buttonRedondo.layer.cornerRadius = 16;//half of the width
    [buttonRedondo setTitle:count forState:UIControlStateNormal];
    
    //color al principio y en el boton redondo
    UIColor * colo = [self colorFromHexString:cate.categoryColorPic];
     UILabel *bandColor = (UILabel *)[cell viewWithTag:200];
    bandColor.backgroundColor= colo;
    buttonRedondo.backgroundColor = colo;
    //abilitar botton
    [categoryButtonLabel setEnabled:YES];
   
    UIButton* EditCategoryButton = (UIButton *)[cell viewWithTag:22];
    EditCategoryButton.tintColor= colo;
    buttonRedondo.hidden = NO;
    EditCategoryButton.hidden = YES;
    if ([count isEqualToString:@"0"] || tableView.editing) {
        buttonRedondo.hidden=YES;
        
    }
    if (tableView.editing) {
        [categoryButtonLabel setEnabled:NO];
        EditCategoryButton.hidden = NO;
    }
    return cell;
}


//color fron HEX

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
//store ide category in NSUserDfauls
-(void)saveToUserDefaults:(NSInteger*)ID_CAT color:(NSString*)color
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:ID_CAT forKey:@"ID_CAT"];
        
        [standardUserDefaults setObject:color forKey:@"COLOR"];
        [standardUserDefaults synchronize];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  
    if ([segue.identifier isEqualToString:@"showrwminder_segue"]) {
        [tableView reloadData];
        RemindersListViewController* listReminder = segue.destinationViewController;
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        idcat_selected = tem.cat_id;
        NSString *color = tem.categoryColorPic;
        [self saveToUserDefaults:idcat_selected color:color];
        listReminder.reminderObj = tem;
        
    } if ([segue.identifier isEqualToString:@"addReminderSegue"]){
   // AddReminderV2Controller* picture_view = segue.destinationViewController;
        NSLog(@"netro al add rmeinder");
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
   
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
       
        NSInteger * idcat_selected ;
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
         NSString *color = tem.categoryColorPic;
        idcat_selected = tem.cat_id;
        [self saveToUserDefaults:idcat_selected color:color];
        //listReminder.reminderObj = tem;
    
    
    }if ([segue.identifier isEqualToString:@"edit_categorySegue"]){
        EditCategoryViewController* editCategory = segue.destinationViewController;
        CGPoint butoPoss = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:butoPoss];
        
      
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        
        //pass value Idcategoria to eddit
        editCategory.IdCategoryToEdit =tem.cat_id;
    
    }
}

// Override to support conditional editing of the table view.



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ReminderObject *cate = [categoryArray objectAtIndex:[indexPath row]];
        [dao deleteCategory:cate.cat_id];
         [categoryArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        // delete and cancel all the notification reminder
        NSMutableArray * notificantionInCategory = [dao getReminderList:cate.cat_id];
        NSString *idtem =[NSString stringWithFormat:@"%d",(int)cate.reminderID];
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
    [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    

}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    id ob = [categoryArray objectAtIndex:destinationIndexPath.row];
    
    [categoryArray replaceObjectAtIndex:destinationIndexPath.row withObject:[categoryArray objectAtIndex:sourceIndexPath.row]];
    [categoryArray replaceObjectAtIndex:sourceIndexPath.row withObject:ob];
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
   ReminderObject *cate = [categoryArray objectAtIndex:[indexPath row]];
    if ([cate.categoryName isEqualToString:@"People"] || [cate.categoryName isEqualToString:@"Todo"] ||[cate.categoryName isEqualToString:@"Notes"] || [cate.categoryName isEqualToString:@"Shopping"]) {
        return UITableViewCellEditingStyleNone;

        
    }else if(self.tableView.editing)
    {
          return UITableViewCellEditingStyleDelete;
    }

    return UITableViewCellEditingStyleNone;

}
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



@end
