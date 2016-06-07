//
//  UIColor+ExampleAppColors.m
//  Example
//
//  Created by Eliot Williams on 4/13/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import "UIColor+PiggyBankColors.h"

@implementation UIColor (PiggyBankColors)

+ (UIColor *)pgb_lightGrayBackgroundColor
{
    return [UIColor pgb_grayWithRGB:250.0 alpha:1.0];
}

+ (UIColor *)pgb_grayBackgroundColor
{
    return [UIColor pgb_colorWithRed:232.0 green:231.0 blue:231.0 alpha:1.0];
}

+ (UIColor *)pgb_blackShadowColor
{
    return [UIColor pgb_grayWithRGB:0.0 alpha:0.5];
}

+ (UIColor *)pgb_grayShadowColor
{
    return [UIColor pgb_grayWithRGB:178.0 alpha:0.5];
}

+ (UIColor *)pgb_translucentWhiteTextFieldBackgroundColor
{
    return [UIColor pgb_grayWithRGB:255.0 alpha:0.6];
}

+ (UIColor *)pgb_translucentWhiteBorderColor
{
    return [UIColor pgb_grayWithRGB:255.0 alpha:0.2];
}

+ (UIColor *)pgb_darkGrayTextColor
{
    return [UIColor pgb_grayWithRGB:74.0 alpha:1.0];
}

+ (UIColor *)pgb_lightGrayTextColor
{
    return [UIColor pgb_grayWithRGB:155.0 alpha:1.0];
}

+ (UIColor *)pgb_lightGraySeparatorColor
{
    return [UIColor pgb_grayWithRGB:219.0 alpha:1.0];
}

+ (UIColor *)pgb_lightBlueColor
{
    return [UIColor pgb_colorWithRed:36.0 green:157.0 blue:229.0 alpha:1.0];
}

+ (UIColor *)pgb_redColor
{
    return [UIColor pgb_colorWithRed:238.0 green:49.0 blue:86.0 alpha:1.0];
}

#pragma mark Helpers
+ (UIColor *)pgb_colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(red / 255.0)green:(green / 255.0)blue:(blue / 255.0)alpha:alpha];
}

+ (UIColor *)pgb_grayWithRGB:(CGFloat)rgb alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(rgb / 255.0)green:(rgb / 255.0)blue:(rgb / 255.0)alpha:alpha];
}

@end
