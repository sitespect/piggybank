//
//  FinalViewController.m
//  Example
//
//  Created by Eliot Williams on 4/22/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import "FinalViewController.h"
#import "PiggyBankStyles.h"

@interface FinalViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFundsButton;
@property (weak, nonatomic) IBOutlet UIButton *viewAccountButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainerView;
@property (weak, nonatomic) IBOutlet UIView *textContainerView;
@property (weak, nonatomic) IBOutlet UILabel *allSetLabel;

@end

@implementation FinalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureLayouts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor pgb_lightGrayBackgroundColor];
    self.navigationController.navigationBar.hidden = YES;
    [self configureButtons];
    [self configureLayouts];
    [super viewWillAppear:animated];
}

- (IBAction)pressedAddFunds:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)configureLayouts
{
    CGSize availableSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    self.mainImage.frame = CGRectMake(0, 0, availableSize.width, (availableSize.width * 2)/3);
    CGFloat mainImageHeight = self.mainImage.bounds.size.height;
    CGFloat availableHeight = availableSize.height - self.mainImage.bounds.size.height;
    
    // Set up the text container layout
    CGRect textAndButtonsFrame = CGRectMake(0, mainImageHeight + 28, availableSize.width, availableHeight - 28);
    CGRect initialTextFrame = CGRectMake(textAndButtonsFrame.origin.x + 35, textAndButtonsFrame.origin.y, textAndButtonsFrame.size.width - 65, 156);
    self.textContainerView.frame = initialTextFrame;
    self.allSetLabel.frame = CGRectMake(0, 0, initialTextFrame.size.width, 22);
    CGSize maximumLabelSize = CGSizeMake(initialTextFrame.size.width, FLT_MAX);
    CGRect labelBoundingRect = [self.mainLabel.text boundingRectWithSize:maximumLabelSize
                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                  attributes:@{NSFontAttributeName:self.mainLabel.font}
                                                                     context:nil];
    self.mainLabel.frame = CGRectMake(0, 36, initialTextFrame.size.width, labelBoundingRect.size.height);
    self.textContainerView.frame = CGRectMake(initialTextFrame.origin.x, initialTextFrame.origin.y, initialTextFrame.size.width, 22+16+self.mainLabel.frame.size.height);
    
    // Set up the button container layout
    CGRect initialButtonsFrame = CGRectMake(textAndButtonsFrame.origin.x + 30, availableSize.height - 104 - 26, textAndButtonsFrame.size.width - 60, 104);
    self.buttonsContainerView.frame = initialButtonsFrame;
    self.addFundsButton.frame = CGRectMake(0, 0, initialButtonsFrame.size.width, 44);
    self.viewAccountButton.frame = CGRectMake(0, initialButtonsFrame.size.height - 44, initialButtonsFrame.size.width, 44);
}

- (void)configureButtons
{
    [self.addFundsButton pgb_styleAsBlueButton];
    [self.viewAccountButton pgb_styleAsWhiteButton];
}

@end
