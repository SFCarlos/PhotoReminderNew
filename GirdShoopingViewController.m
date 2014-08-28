//
//  GirdShoopingViewController.m
//  PhotoReminderNew
//
//  Created by User on 27.06.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "GirdShoopingViewController.h"
#import "UIImage+ScalingMyImage.h"
#import "SelectedItemFotoFullViewController.h"

@interface GirdShoopingViewController (){
    NSMutableArray* items;

}
@property (nonatomic, strong) NSMutableArray *imagenArray;
@end

@implementation GirdShoopingViewController
@synthesize dao;
@synthesize imagenArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     items = [dao getItemListwhitDeletedRowsIncluded:[self retrieveFromUserDefaults] itemType:-1 whitDeletedRowsIncluded:NO];
    [self.collectionView reloadData];

}
- (void)viewDidLoad
{
    dao = [[DatabaseHelper alloc] init];
    items = [[NSMutableArray alloc] init];
      imagenArray = [[NSMutableArray alloc] init];
    items = [dao getItemListwhitDeletedRowsIncluded:[self retrieveFromUserDefaults] itemType:-1 whitDeletedRowsIncluded:NO];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //menu icons
    //self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem* home = [[UIBarButtonItem alloc]
                             initWithImage:[UIImage imageNamed:@"home-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
    
    
    UIBarButtonItem* addbutton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddItemAction:)];
                                   
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:addbutton, nil];
    self.navigationItem.leftBarButtonItems =
   [NSArray arrayWithObjects:home, nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Disposeof any resources that can be recreated.
}
-(void)handleBack:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)AddItemAction: (id)sender{
    
    [self performSegueWithIdentifier:@"addshoopingitemsegue" sender:sender];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return items.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PhotoCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
     ReminderObject *tem = [items objectAtIndex:indexPath.row];
    UIImage*image;
    imagenArray =[dao get_items_PhotoPaths:tem.reminderID];
    if (imagenArray.count==0 ){
        image =[UIImage imageWithImage:[UIImage imageNamed:@"noimage.jpg"] scaledToSize:CGSizeMake(100.0,100.0)];
        
    }
    else{
        
        image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[imagenArray firstObject]]scaledToSize:CGSizeMake(100.0,100.0)];
    }

    UIImageView *itemImageView = (UIImageView *)[cell viewWithTag:85];
    UILabel *itemNameView = (UILabel *)[cell viewWithTag:909];
    itemNameView.text = tem.reminderName;
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marco.png"]];
    itemImageView.image = image;
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFullScreenPhoto"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
       
        SelectedItemFotoFullViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        
       
        ReminderObject * temObj = [items objectAtIndex:indexPath.row];
     
        destViewController.IdNote = temObj.reminderID;
        destViewController.ShoppTile = temObj.reminderName;
       
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
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
