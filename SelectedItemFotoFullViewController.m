//
//  SelectedItemFotoFullViewController.m
//  PhotoReminderNew
//
//  Created by User on 03.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "SelectedItemFotoFullViewController.h"
#import "EditShoopingItemViewController.h"
#import "UIImage+ScalingMyImage.h"
@interface SelectedItemFotoFullViewController (){
    NSMutableArray * imagenPath;
}

@end

@implementation SelectedItemFotoFullViewController
@synthesize IdNote;
@synthesize FullPhoto;
@synthesize dao;
@synthesize ShoppTile;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    dao = [[DatabaseHelper alloc] init];
    imagenPath = [dao get_items_PhotoPaths:IdNote];
   
     self.navigationItem.title = ShoppTile;
   
    if (imagenPath.count==0) {
        self.FullPhoto.image = [UIImage imageNamed:@"noimage.jpg"];
        
    }else
        self.FullPhoto.image = [UIImage imageWithImage:[UIImage imageWithContentsOfFile:(NSString*)[imagenPath firstObject]]scaledToSize:CGSizeMake(128.0,128.0)];;
    
    UIBarButtonItem* editShoppItem          = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"edit-32.png"] style:UIBarStyleDefault target:self action:@selector(editShoppItemAction:)];
    
    UIBarButtonItem* deleteShoopItem          = [[UIBarButtonItem alloc]
                                               initWithImage:[UIImage imageNamed:@"trash-25.png"] style:UIBarStyleDefault target:self action:@selector(deleteShoopItemAction:)];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];    self.toolbarItems=[NSArray arrayWithObjects: editShoppItem,flexibleItem,deleteShoopItem, nil];

    // Do any additional setup after loading the view.
}
-(void)deleteShoopItemAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Confirmation"
                                                    message:[NSString stringWithFormat:@"Delete %@ fron the list?",ShoppTile]
                          
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK",nil];
    [alert show];



}
-(void)editShoppItemAction:(id)sender{
    [self performSegueWithIdentifier:@"editShoppingItem" sender:sender];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
       
        ReminderObject * ShopingItem = [dao getItemwhitServerID: (int)IdNote usingServerId:NO]; //idNote is shooping iditem
        //mark for future sync
        if(ShopingItem.id_server_item != 0){ //esta en server database
            [dao deleteItem:IdNote permanently:NO];
            [dao updateSTATUSandSHOULDSENDInTable:IdNote clientStatus:1 should_send:1 tableName:@"items"];
            
        }else if (ShopingItem.id_server_item == 0){ //no esta en server db
            [dao deleteItem:IdNote permanently:YES]; //delete foreverc
            
        }

        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}
-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    
    
    [super viewWillAppear:animated];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editShoppingItem"]) {
       
        
        EditShoopingItemViewController *destViewController = segue.destinationViewController;

        
        destViewController.IdShoopingItemToEdit = IdNote;
      
        
       
    }
}

@end
