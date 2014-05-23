//
//  AppDelegate.m
//  PhotoReminder
//
//  Created by User on 10.03.2014.
//  Copyright (c) 2014 sybernetsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalNotificationCore.h"
#import "DatabaseHelper.h"
@implementation AppDelegate
{
    BOOL * isAppResumminfromBack;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //si entra a la app por el icono tengo que comprobar que no halla notificaciones viejas en la
    // BD son app que no las vio el cliente.
    //todavie no hacer esto
    
    
    // Override point for customization after application launch.
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotification)
    {
        NSLog(@"NOTIFICATION disparada desde finisLauncWhitOptions");
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        NotificationScreenController *cvc = (NotificationScreenController *)[sb instantiateViewControllerWithIdentifier:@"NotificationScreen"];
        
        
        NSDictionary*userinfo=localNotification.userInfo;
        NSInteger* iop=(NSInteger*)[[userinfo objectForKey:@"ID_NOT_PASS"] integerValue];
        cvc.reminderId =iop;
        self.window.rootViewController =nil;
        self.window.rootViewController=cvc;
        
        
        [self.window makeKeyAndVisible];
        
        //la cancelo perke ya la vi..en snooze la creo de nuevo
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
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
