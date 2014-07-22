//
//  FullScreemPageItemViewController.m
//  PhotoReminderNew
//
//  Created by User on 01.07.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "FullScreemPageItemViewController.h"
#import "ContentFullView.h"

@interface FullScreemPageItemViewController (){
    NSMutableArray* items;
 
}


@end

@implementation FullScreemPageItemViewController
@synthesize indexPhotoToShowFirt;
@synthesize dao;
-(NSInteger*)retrieveFromUserDefaults
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"ID_CAT"];
    
    return val;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.navigationItem.hidesBackButton = YES;
    //*****************
    //back buttom
   
    UIBarButtonItem*back=[[UIBarButtonItem alloc]
                          initWithImage:[UIImage imageNamed:@"back-25.png"] style:UIBarStyleDefault target:self action:@selector(handleBack:)];
  //  self.navigationItem.leftBarButtonItem=back;
    UIBarButtonItem* deleteItem          = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:@"trash-25.png"] style:UIBarStyleDefault target:self action:@selector(deleteAction:)];
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:deleteItem, nil];
    // Do any additional setup after loading the view.

    
    dao = [[DatabaseHelper alloc] init];
    _pageTitles = [[NSMutableArray alloc] init];
    _pageImages = [[NSMutableArray alloc] init];
    items = [dao getItemList:[self retrieveFromUserDefaults] itemType:-1];
    
    for(ReminderObject * tem in items){
       // NSLog(@"Estos son los urls %@ y el name %@",[dao get_items_PhotoPaths:tem.reminderID],tem.reminderName );
        NSMutableArray *tem2 =(NSMutableArray*)[dao get_items_PhotoPaths:(int)tem.reminderID];
        [_pageImages addObject: [tem2 firstObject]];
        [_pageTitles addObject:(NSString*)tem.reminderName];
    
    }
        
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
  
    ContentFullView *startingViewController = [self viewControllerAtIndex:indexPhotoToShowFirt];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}
-(void)handleBack:(id)sender{
    // [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshCategoriesList" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)deleteAction:(id)sender{
    [_pageViewController willMoveToParentViewController:nil];
    [_pageViewController.view removeFromSuperview];
    [_pageViewController removeFromParentViewController];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
     NSArray* array =[self.pageViewController viewControllers];
     // deleteVC is a child view controller of the UIPageViewController
     ContentFullView* deleteVC = array[0];
    ReminderObject *tem =[items objectAtIndex:deleteVC.pageIndex];
    [dao deleteItem:(int)tem.reminderID];
   self.pageViewController.dataSource = self;
   
    
    int indextoshow;
    if (deleteVC.pageIndex == 0) {
        indextoshow = deleteVC.pageIndex + 1;
    }else
        indextoshow = deleteVC.pageIndex -1;
    
    ContentFullView *startingViewController = [self viewControllerAtIndex:indextoshow];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
   /* NSArray* array =[self.pageViewController viewControllers];
    // deleteVC is a child view controller of the UIPageViewController
    ContentFullView* deleteVC = array[0];
    
    [deleteVC willMoveToParentViewController:nil];
    [deleteVC.view removeFromSuperview];
    [deleteVC removeFromParentViewController];
    int indextoshow;
    if (deleteVC.pageIndex == 0) {
        indextoshow = deleteVC.pageIndex + 1;
    }else
        indextoshow = deleteVC.pageIndex -1;
    
    UIViewController* nextController = [self viewControllerAtIndex:indextoshow];
    
    void (^completionBlock)(BOOL) = ^(BOOL finished)
    {
        // It seems that whenever the setViewControllers:
        // method is called with "animated" set to YES, UIPageViewController precaches
        // the view controllers retrieved from it's data source meaning that
        // the dismissed controller might not be removed. In such a case we
        // have to force it to clear the cache by initiating a non-animated
        // transition.
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self.pageViewController setViewControllers:@[nextController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        });
    };
    
    [self.pageViewController setViewControllers:@[nextController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:completionBlock];
    ReminderObject *tem =[items objectAtIndex:deleteVC.pageIndex];
    [dao deleteItem:(int)tem.reminderID];
    [self.pageViewController reloadInputViews];*/
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentFullView*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((ContentFullView*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [items count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return indexPhotoToShowFirt;
}
- (ContentFullView *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ContentFullView *contentFullview = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    contentFullview.imageFile = (NSString*)[self.pageImages objectAtIndex:index];
    contentFullview.titleText = (NSString*)[self.pageTitles objectAtIndex:index];
    contentFullview.pageIndex = index;
    
    return contentFullview;
}
@end
