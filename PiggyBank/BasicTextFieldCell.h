//
//  BasicTextFieldCell.h
//  Example
//
//  Created by Eliot Williams on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicTextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textFieldView;
@property (weak, nonatomic) IBOutlet UIView *separatorView2;

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIView *separatorView;

@end

@implementation BasicTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.textField = [[UITextField alloc] init];
        self.separatorView = [[UIView alloc] init];
        self.separatorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.clipsToBounds = YES;
        
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.separatorView];
        [self.textLabel setHidden:YES];
        
        self.textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *textFieldTop = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTopMargin multiplier:1 constant:-8];
        
        NSLayoutConstraint *textFieldLeading = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:32];
        
        NSLayoutConstraint *textFieldTrailing = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-32];
        
        NSLayoutConstraint *textFieldHeight = [NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:40];
        
        NSLayoutConstraint *separatorTop = [NSLayoutConstraint constraintWithItem:self.separatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1];
        
        NSLayoutConstraint *separatorLeading = [NSLayoutConstraint constraintWithItem:self.separatorView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:32];
        
        NSLayoutConstraint *separatorTrailing = [NSLayoutConstraint constraintWithItem:self.separatorView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-32];
        
        NSLayoutConstraint *separatorHeight = [NSLayoutConstraint constraintWithItem:self.separatorView
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeHeight
                                                                               multiplier:1
                                                                                 constant:1];
        
        [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:textFieldTop, textFieldHeight, textFieldLeading, textFieldTrailing, separatorTop, separatorLeading, separatorTrailing, separatorHeight, nil]];
    }
    
    return self;
}

@end
