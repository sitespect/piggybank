//
//  SiteSpectSDK+Editor.h
//  SiteSpectEditorSDK
//
//  Created by Fabien Legoupillot on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteSpectSDK.h"

@interface SiteSpectSDK (Editor)

/**
 *  Enable three-finger swipe up to enter native test creation mode in the SDK.
 *  For simulator builds, no gesture is required as the SDK control button will already be visible.
 *  Test creation is disabled by default.
 *  @warning DO NOT enable this for release builds!!!!
 */
+ (void)setTestCreationEnabled:(BOOL)enabled;

@end

