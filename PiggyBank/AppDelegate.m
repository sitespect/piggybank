//
//  AppDelegate.m
//  Example
//
//  Created by Eliot Williams on 3/23/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import "AppDelegate.h"

#import <SiteSpectEditorSDK/SiteSpectSDK+Editor.h>
//#import <SiteSpectSDK/SiteSpectSDK.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SiteSpectSDK enableWithSiteID:@"589"];
    [SiteSpectSDK setLogLevel:SSPCTLogLevelDebug];
    [SiteSpectSDK setTestCreationEnabled:YES];

    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
    return YES;
}

@end
