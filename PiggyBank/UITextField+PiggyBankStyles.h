//
//  UITextField+PiggyBankStyles.h
//  Example
//
//  Created by Eliot Williams on 4/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UITextField (PiggyBankStyles)

- (void)pgb_styleWithGrayText;
- (void)pgb_styleWithMediumWeightBlueText;

@end

@implementation UITextField (PiggyBankStyles)

- (void)pgb_styleWithGrayText
{
    self.textColor = [UIColor pgb_darkGrayTextColor];
    self.font = [UIFont systemFontOfSize:self.font.pointSize weight:UIFontWeightRegular];
}

- (void)pgb_styleWithMediumWeightBlueText
{
    self.textColor = [UIColor pgb_lightBlueColor];
    self.font = [UIFont systemFontOfSize:self.font.pointSize weight:UIFontWeightMedium];
}

@end