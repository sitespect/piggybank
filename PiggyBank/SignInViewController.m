//
//  SignInViewController.m
//  Example
//
//  Created by Eliot Williams on 3/23/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import "SignInViewController.h"
#import "PiggyBankStyles.h"

#import <SiteSpectEditorSDK/SiteSpectSDK+Editor.h>
//#import <SiteSpectSDK/SiteSpectSDK.h>

@interface SignInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UILabel *legalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *legalLabelHeightContraint;

@property (strong, nonatomic) UITextField *activeField;
@property (nonatomic) UIEdgeInsets baseScrollInsets;
@property (nonatomic) UIEdgeInsets baseScrollIndicatorInsets;

@end

@implementation SignInViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor pgb_grayBackgroundColor];

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    __block NSString *imageName = @"imgSigninBackgroundA";
    [SiteSpectSDK applyChangesForVariationGroupWithSDKIdentifier:@"change_bg_img" baseline:nil
                                                         changes:^{
                                                             imageName = @"imgSigninBackgroundB";
                                                         }];

    [SiteSpectSDK applyChangesForVariationGroupWithSDKIdentifier:@"no_bg_img" baseline:nil
                                                         changes:^{
                                                             imageName = nil;
                                                         }];

    backgroundImageView.image = [UIImage imageNamed:imageName];
    [self.view insertSubview:backgroundImageView belowSubview:self.containerView];

    [self configureTextFields];
    [self configureButtons];
    [self configureTapRecognition];
    [self configureLegalLabel];

    [self registerForTextFieldChangeNotifications];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)configureLegalLabel
{
    self.legalLabel.textColor = [UIColor pgb_lightGrayTextColor];
    self.legalLabel.alpha = 0.6;
    [self.legalLabel sizeToFit];

    self.legalLabelHeightContraint.constant = self.legalLabel.frame.size.height;
}

#pragma mark - Notifications
- (void)registerForTextFieldChangeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustSignInButton)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

#pragma mark - Dismiss Keyboard

- (void)configureTapRecognition
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;

    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard
{
    [self.activeField resignFirstResponder];
}

#pragma mark - Button UI

- (void)configureTextFields
{
    [self.userNameView pgb_styleAsTextFieldContainer];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
    spacerView.backgroundColor = [UIColor clearColor];
    [self.usernameTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.usernameTextField setLeftView:spacerView];
    [self.usernameTextField pgb_styleBorderWithWidth:1.0
                                               color:[UIColor pgb_translucentWhiteBorderColor]];

    [self.passwordView pgb_styleAsTextFieldContainer];
    UIView *passwordSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 0)];
    passwordSpacerView.backgroundColor = [UIColor clearColor];
    [self.passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.passwordTextField setLeftView:passwordSpacerView];
    [self.passwordTextField pgb_styleBorderWithWidth:1.0
                                               color:[UIColor pgb_translucentWhiteBorderColor]];
}

- (void)configureButtons
{
    self.signInButton.enabled = NO;
    [self.signInButton pgb_styleAsWhiteButton];
    [self.createAccountButton pgb_styleAsBlueButton];
}

- (void)adjustSignInButton
{
    NSUInteger usernameLength = self.usernameTextField.text.length;
    NSUInteger passwordLength = self.passwordTextField.text.length;
    self.signInButton.enabled = (usernameLength > 0 && passwordLength > 5);
}

- (IBAction)tappedCreateAccountButton:(id)sender
{
    self.usernameTextField.text = nil;
    self.passwordTextField.text = nil;
    [SiteSpectSDK triggerMetricWithSDKIdentifier:@"4734-CreateAccountTapped"
                                    valueCapture:nil];
    [self performSegueWithIdentifier:@"showCreateAccount" sender:self];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        return NO;
    }
    else {
        [textField resignFirstResponder];
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self adjustSignInButton];
    [textField setTextColor:[UIColor pgb_darkGrayTextColor]];
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor pgb_lightBlueColor]];
    self.activeField = nil;
}

@end
