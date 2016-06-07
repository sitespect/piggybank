//
//  UILabel+PiggyBankStyles.h
//  Example
//
//  Created by Eliot Williams on 4/21/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (PiggyBankStyles)

- (NSMutableAttributedString *)pgb_mutableAttributedTextWithFont:(UIFont *)font
                                                         kerning:(NSNumber *)kerning
                                                      lineHeight:(NSNumber *)lineHeight
                                                           color:(UIColor *)color
                                                       alignment:(NSTextAlignment)alignment;

@end

@implementation UILabel (PiggyBankStyles)

- (NSMutableAttributedString *)pgb_mutableAttributedTextWithFont:(UIFont *)font
                                                         kerning:(NSNumber *)kerning
                                                      lineHeight:(NSNumber *)lineHeight
                                                           color:(UIColor *)color
                                                       alignment:(NSTextAlignment)alignment
{
    NSString *text = self.text;
    NSRange textRange = NSMakeRange(0, text.length);
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    [mutableAttributedString addAttribute:NSFontAttributeName
                                    value:font
                                    range:textRange];
    
    (!kerning) ?: [mutableAttributedString addAttribute:NSKernAttributeName
                                                  value:@(kerning.floatValue)
                                                  range:textRange];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    if (lineHeight) {
        [style setMinimumLineHeight:lineHeight.floatValue];
        [style setMaximumLineHeight:lineHeight.floatValue];
    }
    
    [style setAlignment:alignment];
    
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName
                                    value:style
                                    range:textRange];
    
    (!color) ?: [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                                value:color
                                                range:textRange];
    
    return mutableAttributedString;
}

@end
