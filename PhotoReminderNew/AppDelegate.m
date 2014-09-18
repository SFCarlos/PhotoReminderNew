//
//  AppDelegate.m
//  PhotoReminder
//
//  Created by User on 10.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalNotificationCore.h"
#import "SettingsViewController.h"
#import "DatabaseHelper.h"
#import "Globals.h"
@implementation AppDelegate
{
    BOOL * isAppResumminfromBack;
}
-(void)saveShowAgainSTATUSS:(NSInteger*)statuss
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:(int)statuss forKey:@"SHOWAGAIN"];
        [standardUserDefaults synchronize];
    }
    
}
-(NSInteger*)retrieveShowAgainStatus{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"SHOWAGAIN"];
    
    return val;
    
}
-(NSInteger*)retrieveSYNCSTATUSSFromUserDefaults{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults integerForKey:@"STATUS"];
    
    return val;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    //Tur on: go to setting
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        SettingsViewController *settingController = (SettingsViewController *)[sb instantiateViewControllerWithIdentifier:@"SettingsScreem"];
        [(UINavigationController*)self.window.rootViewController pushViewController:settingController animated:YES];
    }else if (buttonIndex ==1){
        //reminder later if sync is off:        
    
    }else if (buttonIndex ==2){
        //dont show again: save this preference to user defaults
//put 1 to this  status
        [self saveShowAgainSTATUSS:1];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Advice!"
                                                        message:@"You can turn on synchronization in settings "
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //put the firt sound if user not select at the start
    if ([Globals retrieveSoundReminderFromUserDefaults] == nil) {
        [Globals saveSoundReminderToUserDefaults:@"Alarm Classic"];
    }
    
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.01];
   
    
    
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    //flagSync = 0 sync off ******  flagSync = 1 sync on
    NSInteger* flagSync = [self retrieveSYNCSTATUSSFromUserDefaults];
    //DontShowStatus = 1 dont show ever
    NSInteger* DontShowStatus = [self retrieveShowAgainStatus];
    
    if ((flagSync == 0 && DontShowStatus != 1) && !localNotification) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!"
                                                        message:@"Turn on synchronization to keep your reminders safe and share whith friend and family "
                                                       delegate:self
                                              cancelButtonTitle:@"Turn on"
                                              otherButtonTitles:@"Remind Later",
                                             @"Don't show again",nil];
        [alert show];
    }
    
  //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    //si entra a la app por el icono tengo que comprobar que no halla notificaciones viejas en la
    // BD son app que no las vio el cliente.
    //todavie no hacer esto
    
    
    // Override point for customization after application launch.
    
    if (localNotification)
    {
        NSLog(@"NOTIFICATION disparada desde finisLauncWhitOptions: %@",[localNotification description]);
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        NotificationScreenController *cvc = (NotificationScreenController *)[sb instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        
        
        NSDictionary*userinfo=localNotification.userInfo;
        NSInteger* iop=(NSInteger*)[[userinfo objectForKey:@"ID_NOT_PASS"] integerValue];
        cvc.reminderId =iop;
        cvc.recivedNotificaion = localNotification;
        self.window.rootViewController =nil;
        self.window.rootViewController=cvc;
        
        
        [self.window makeKeyAndVisible];
        
        //la cancelo perke ya la vi..en snooze la creo de nuevo
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        UIApplication*app =[UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        for (int i=0; i<[eventArray count]; i++) {
            UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
            NSDictionary *userInfoIDremin = oneEvent.userInfo;
            NSInteger*uid=(NSInteger*)[[userInfoIDremin objectForKey:@"ID_NOT_PASS"] integerValue];
            if (uid == iop) {
                [app cancelLocalNotification:oneEvent];
                NSLog(@"APPDELEGATE...Id del reminder cancelado %d",iop);
            }
        }

        //le descuento uno
        
        [[LocalNotificationCore sharedInstance] handleReceivedNotification:localNotification];
        
    }
    return YES;
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    /* if(isAppResumminfromBack){
     UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Reminder" message:notification.alertBody delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
     
     [alert show];
     }*/
    NSLog(@"NOTIFICATION disparada desde  didReceiveLocalNotification: %@",[notification description]);
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    NotificationScreenController *cvc = (NotificationScreenController *)[sb instantiateViewControllerWithIdentifier:@"NotificationScreen"];
    
    NSDictionary*userinfo=notification.userInfo;
    NSInteger*id_remNotification= (NSInteger*)[[userinfo objectForKey:@"ID_NOT_PASS"] integerValue];
    
    
    //le paso el id reminder  y la not ificacin al notificationScreem
    cvc.reminderId =id_remNotification;
    cvc.recivedNotificaion = notification;
    self.window.rootViewController =nil;
    self.window.rootViewController=cvc;
    [self.window makeKeyAndVisible];
    
    //recurring logic
    
    //la cancelo perke ya la vi..en snooze la creo de nuevo y si es recurrente la creo de nuevo tambien cunado press "done"
    UIApplication*app =[UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++) {
        UILocalNotification* oneEvent= [eventArray objectAtIndex:i];
        NSDictionary *userInfoIDremin = oneEvent.userInfo;
        NSInteger*uid=(NSInteger*)[[userInfoIDremin objectForKey:@"ID_NOT_PASS"] integerValue];
        if (uid == id_remNotification) {
            [app cancelLocalNotification:oneEvent];
            NSLog(@"APPDELEGATE...Id del reminder cancelado %d",id_remNotification);
        }
    }
    
    
    // [[UIApplication sharedApplication] cancelLocalNotification:notification];
    //le descuento uno
    [[LocalNotificationCore sharedInstance] handleReceivedNotification:notification];
    
    
    
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    isAppResumminfromBack = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
