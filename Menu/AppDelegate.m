//
//  AppDelegate.m
//  Menu
//
//  Created by tarena033 on 16/4/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    

    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setTintColor:kRGBColor(227, 59, 65, 0.8)];
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"day"]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NSUserDefaults standardUserDefaults] setInteger:[TimeManager dayAboutTime] forKey:@"day"];
            
        });
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"day"] != [TimeManager dayAboutTime]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NSUserDefaults standardUserDefaults] setInteger:[TimeManager dayAboutTime] forKey:@"day"];
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtPath:kHeaderViewPath error:&error];
            [[NSFileManager defaultManager] removeItemAtPath:kGuessPath error:&error];
        });
        
    }
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
