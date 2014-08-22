//
//  RecipeViewController.m
//  CustomTableView
//


#import "CategoryLisViewController.h"
#import "RemindersListViewController.h"
#import "EditCategoryViewController.h"
#import "AddReminderV2Controller.h"

@interface CategoryListViewController ()
@property (strong, nonatomic) NSMutableArray *arrayTag;
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
@synthesize arrayTag;
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
    [self LoadAgain];
    [super viewDidLoad];
}
-(void)LoadAgain{
    /* edit = [[UIBarButtonItem alloc]
     initWithImage:[UIImage imageNamed:@"micro-25.png"] style:UIBarStyleDefault target:self action:@selector(editAction:)];*/
    NSLog(@"DidLoad");
    UIBarButtonItem *setting         = [[UIBarButtonItem alloc]
                                        initWithImage:[UIImage imageNamed:@"back-25.png"] style:UIBarStyleDefault target:self action:@selector(settingAction:)];
    addCategory = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCategoryAction:)];
    
    
    UIBarButtonItem* doneButton          = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"checkmark-25.png"] style:UIBarStyleDefault target:self action:@selector(doneAction:)];
    //add buttons to nav bar
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItems=
    [NSArray arrayWithObjects: doneButton, nil];
    self.toolbarItems=[NSArray arrayWithObjects: addCategory, nil];
    //init the arrays
    
    
    dao = [[DatabaseHelper alloc] init];
    categoryArray = [[NSMutableArray alloc] init];
    
    
    //order the array
    categoryArray = [dao getCategoryListwhitDeletedRowsIncluded:NO] ;
    //[self preformOrder:categoryArray];
    
    
    
    [tableView setEditing:YES animated:YES];
    
    
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

-(void) viewWillDisappear:(BOOL)animated{
[self.navigationController setToolbarHidden:YES animated:YES];
    
    
    [super viewWillDisappear:animated];
   
  
}
-(void) viewWillAppear:(BOOL)animated{
   [self.navigationController setToolbarHidden:NO animated:YES];
    NSLog(@"Entro al willAppear in reorder categories");
   
   // categoryArray=[dao getCategoryListwhitDeletedRowsIncluded:NO];
    //
    //[self.tableView reloadData];
    //[self preformOrder:categoryArray];
    
    [super viewWillAppear:animated];
    

    
    
}
//gifme the orden
-(NSMutableArray*)retrieveORDENFromUserDefaults{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:@"ORDENARRAY"];
    
    return val;
    
}
- (void)EditCategoryButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"edit_categorySegue" sender:sender];
}
-(void)settingAction:(id)sender{
    
    [self performSegueWithIdentifier:@"settingsSegue" sender:sender];
}
-(void)addCategoryAction:(id)sender{
    
    [self performSegueWithIdentifier:@"add_categoryV2" sender:sender];
}
-(void)doneAction:(id)sender{
    
       
    [self performSegueWithIdentifier:@"settingsSegue" sender:sender];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
   
     return @"              Select a category to edit";
}

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
    
    cell.tag = indexPath.row;
    NSString *strCellTag = [NSString stringWithFormat:@"%d",cell.tag];
   if(![arrayTag containsObject:strCellTag])
    {
        [arrayTag addObject:strCellTag];
   }
   
    /* MKNumberBadgeView* numberb= [[MKNumberBadgeView alloc]initWithFrame:CGRectMake(5, 74, 50, 50)];
    numberb.value = 5;*/
    
    ReminderObject *cate = [categoryArray objectAtIndex:[indexPath row]];
   
    //update orden
     [dao updateorden:cate.cat_id orden:indexPath.row];
    NSLog(@"%@ - %d",cate.categoryName,indexPath.row);
    
   /* NSString * count = [NSString stringWithFormat:@"%d", (int)[dao getCountItemInCategory:cate.cat_id]];
   */
    
    
    //UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
  // recipeImageView.image = [UIImage imageNamed:cate.categoryImagenPic];
    
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:1234];
   
    categoryLabel.text=cate.categoryName;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EditCategoryButtonAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [categoryLabel addGestureRecognizer:tapGestureRecognizer];
    categoryLabel.userInteractionEnabled = YES;
    
    //color al principio y en el boton redondo
    UIColor * colo = [self colorFromHexString:cate.categoryColorPic];
     UILabel *bandColor = (UILabel *)[cell viewWithTag:200];
    bandColor.backgroundColor= colo;
    
    
   
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
//store the orden in userdefult
-(void)saveOrdenToUserDefaults:(NSMutableArray*)ordenArray
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [[NSUserDefaults standardUserDefaults] setObject:ordenArray forKey:@"ORDENARRAY"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
        CGPoint labelPoss = [(UIGestureRecognizer*)sender locationInView: self.tableView];
        NSIndexPath * clicedbut =[self.tableView indexPathForRowAtPoint:labelPoss];
       
      
        ReminderObject* tem =[categoryArray objectAtIndex:clicedbut.row];
        
        //pass value Idcategoria to eddit
        editCategory.IdCategoryToEdit =tem.cat_id;
    
    }
}

// Override to support conditional editing of the table view.








// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
  
    ReminderObject* ob = [categoryArray objectAtIndex:sourceIndexPath.row];
    
    [categoryArray removeObjectAtIndex:sourceIndexPath.row];
    [categoryArray insertObject:ob atIndex:destinationIndexPath.row];
    
       /////*******
    
    
  
    
    [self.tableView reloadData];
 
    NSLog(@"DIsparada");
    }
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return UITableViewCellEditingStyleNone;

}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
   /*
     EditCategoryViewController *editCategory = [[EditCategoryViewController alloc] init];
    ReminderObject* tem =[categoryArray objectAtIndex:indexPath.row];
    
    
    editCategory.IdCategoryToEdit =tem.cat_id;
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:editCategory animated:YES];
    */
}
-(void)preformOrder:(NSMutableArray*)catArray{
    NSMutableArray * categoryArrayOrdered = [[NSMutableArray alloc] init];
    
    
        for (ReminderObject* temp in catArray) {
            
            [categoryArrayOrdered addObject:[catArray objectAtIndex:(int)temp.orden]];
       
    }
        categoryArray = categoryArrayOrdered;


}



@end
