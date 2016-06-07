//
//  UIView+PGBStyles.h
//  Example
//
//  Created by Eliot Williams on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PiggyBankStyles)

- (void)pgb_styleAsTextFieldContainer;

- (void)pgb_styleShadowWithColor:(UIColor *)color shadowOpacity:(float)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius;
- (void)pgb_styleBorderWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor;

@end

#import "UIView+PiggyBankStyles.h"
#import "UIColor+PiggyBankColors.h"

@implementation UIView (PiggyBankStyles)

- (void)pgb_styleAsTextFieldContainer
{
    self.backgroundColor = [UIColor pgb_translucentWhiteTextFieldBackgroundColor];
    self.layer.cornerRadius = 4.0;
}

- (void)pgb_styleShadowWithColor:(UIColor *)color shadowOpacity:(float)shadowOpacity shadowOffset:(CGSize)shadowOffset shadowRadius:(CGFloat)shadowRadius
{
    CALayer *viewLayer = self.layer;
    viewLayer.shadowColor = color.CGColor;
    viewLayer.shadowOpacity = shadowOpacity;
    viewLayer.shadowOffset = shadowOffset;
    viewLayer.shadowRadius = shadowRadius;
}

- (void)pgb_styleBorderWithWidth:(CGFloat)borderWidth color:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

@end
