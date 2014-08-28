//
//  RecipeViewController.h
//  CustomTableView
//


#import <UIKit/UIKit.h>
#import "DatabaseHelper.h"

#import "MKNumberBadgeView.h"
@interface CategoryListViewController : UITableViewController



@property (nonatomic, strong) IBOutlet UITableView *tableView;
- (IBAction)EditCategoryButtonAction:(id)sender;
@property (nonatomic, strong) DatabaseHelper *dao;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *TapGestureToAddreminder;
@property (strong, nonatomic) IBOutlet UIButton *reminderListButton;
@property (strong, nonatomic) IBOutlet UIButton *addRbutton;



-(UIColor *)colorFromHexString:(NSString *)hexString;
@end
