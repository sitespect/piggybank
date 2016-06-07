//
//  UIButton+PiggyBankButtonStyles.h
//  Example
//
//  Created by Eliot Williams on 4/19/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+PiggyBankStyles.h"
#import "UIColor+PiggyBankColors.h"

@interface UIButton (PiggyBankButtonStyles)

- (void)pgb_styleAsBlueButton;
- (void)pgb_styleAsWhiteButton;

@end

@implementation UIButton (PiggyBankButtonStyles)

- (void)pgb_styleAsBlueButton
{
    self.backgroundColor = [UIColor pgb_lightBlueColor];
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.layer.cornerRadius = 4.0;
    [self pgb_styleShadowWithColor:[UIColor pgb_blackShadowColor]
                     shadowOpacity:0.2
                      shadowOffset:CGSizeMake(0, 1)
                      shadowRadius:2];
}

- (void)pgb_styleAsWhiteButton
{
    self.backgroundColor = [UIColor whiteColor];
    
    [self setTitleColor:[UIColor pgb_lightBlueColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor pgb_lightGrayTextColor] forState:UIControlStateDisabled];
    
    self.layer.cornerRadius = 4.0;
    [self pgb_styleShadowWithColor:[UIColor pgb_blackShadowColor]
                     shadowOpacity:0.5
                      shadowOffset:CGSizeMake(0, 1)
                      shadowRadius:2];
}

@end
