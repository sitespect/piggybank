//
//  CreateAccountViewController.m
//  Example
//
//  Created by Eliot Williams on 4/13/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "PiggyBankStyles.h"
#import "BasicTextFieldCell.h"

#import <SiteSpectEditorSDK/SiteSpectSDK+Editor.h>
//#import <SiteSpectSDK/SiteSpectSDK.h>

static float kPGBSubmitButtonInsetPadding = 100.0;

@interface CreateAccountViewController () <UITextFieldDelegate, UIPickerViewDelegate>

@property (strong, nonatomic) BasicTextFieldCell *passwordCell;
@property (strong, nonatomic) BasicTextFieldCell *confirmPasswordCell;

@property (strong, nonatomic) UITextField *activeField;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIView *errorBanner;
@property (nonatomic) BOOL errorDisplayed;

@property (nonatomic) BOOL shouldHidePickerView;
@property (strong, nonatomic) UITextField *birthDateTextField;
@property (strong, nonatomic) UIDatePicker *birthDatePickerView;

@property (strong, nonatomic) UIButton *submitButton;

@property (nonatomic) BOOL didScrollForKeyboard;
@property (nonatomic) UIEdgeInsets initialInsets;

@property (nonatomic) NSMutableArray *inputs;

@property (nonatomic) NSNumber *pswFieldIndex;
@property (nonatomic) NSNumber *confirmPswFieldIndex;

@end

@implementation CreateAccountViewController

BOOL custom = NO;

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"CREATE ACCOUNT";
    [self configureTapRecognition];
    
    self.inputs = [NSMutableArray arrayWithObjects:@"First name", @"Middle name", @"Last name", @"Date of birth", @"Date Picker", @"Occupation", @"Email address", @"Password", @"Confirm password", nil];
    
    // Code editing version setup
    [SiteSpectSDK applyChangesForVariationGroupWithSDKIdentifier:@"no_occupation" baseline:nil changes:^{
        [self.inputs removeObjectAtIndex:5];
    }];

    // Live variables setup
    for (int i=0; i<[self.inputs count]; i++) {
        if ([SiteSpectSDK objectForLiveVariableWithKey:[self.inputs objectAtIndex:i]]) {
            [self.inputs setObject:[SiteSpectSDK objectForLiveVariableWithKey:[self.inputs objectAtIndex:i]] atIndexedSubscript:i];
        }
    }
    
    self.pswFieldIndex = [NSNumber numberWithInteger:[self.inputs indexOfObject:@"Password"]];
    self.confirmPswFieldIndex = [NSNumber numberWithInteger:[self.inputs indexOfObject:@"Confirm password"]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor pgb_lightGrayBackgroundColor];

    [self registerForTextFielddNotifications];
    [self configureNavBar];
    [self configureStartLabel];
    [self configureSubmitButton];
    [self configureErrorBanner];
    self.shouldHidePickerView = YES;
    
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableFooterView.userInteractionEnabled = YES;

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.initialInsets = self.tableView.contentInset;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self deregisterFromNotifications];
    [super viewWillDisappear:animated];
}

#pragma mark - Button Actions

- (void)tappedSubmitButton {
    [self validatePasswordsAndAttemptSegueToFinalScreen];
}

- (void)validatePasswordsAndAttemptSegueToFinalScreen
{
    if (![self isValidPassowrd:self.passwordCell.textField.text]){
        return;
    }
    
    if ([self hasValidPasswords]) {
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"NoAutolayout" bundle:nil];
        UIViewController *finalViewController = [secondStoryBoard instantiateInitialViewController];
        [self.navigationController pushViewController:finalViewController animated:YES];
    }
    else {
        [self markInvalidPasswords];
    }
}

#pragma mark - Configuration
- (void)configureNavBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // Remove the shadow from the initial nav bar
        for (UIView *parent in self.navigationController.navigationBar.subviews) {
            for (UIView *childView in parent.subviews) {
                if ([childView isKindOfClass:[UIImageView class]]) {
                    [childView removeFromSuperview];
                }
            }
        }
    // Replace the shadow with our own
    [self.navigationController.navigationBar pgb_styleShadowWithColor:[UIColor pgb_grayShadowColor] shadowOpacity:0.0 shadowOffset:CGSizeMake(0, 0.5) shadowRadius:2];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor pgb_lightGrayBackgroundColor];
    self.navigationController.view.backgroundColor = [UIColor pgb_lightGrayBackgroundColor];

    NSString *title = self.title;
    NSRange titleRange = NSMakeRange(0, title.length);

    float spacing = 1.5f;
    NSMutableAttributedString *attributedTitleString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedTitleString addAttribute:NSKernAttributeName
                                  value:@(spacing)
                                  range:titleRange];
    [attributedTitleString addAttribute:NSForegroundColorAttributeName
                                  value:[UIColor pgb_lightGrayTextColor]
                                  range:titleRange];

    UIFont *titleFont = [UIFont boldSystemFontOfSize:14.0];
    [attributedTitleString addAttribute:NSFontAttributeName
                                  value:titleFont
                                  range:titleRange];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.attributedText = attributedTitleString;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btnCreateaccountNavbarBackNormal"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(tappedBackArrow:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor pgb_lightGrayTextColor];
    
}

- (void)configureStartLabel
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 150)];
    
    // Set up start label
    NSString *startString = @"Start your rainy day fund by setting up your account now!";
    UILabel *startLabel = [[UILabel alloc] init];
    [startLabel setText:startString];
    startLabel.numberOfLines = 0;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:startString];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, startString.length)];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, startString.length)];
    
    startLabel.attributedText = attrString;
    [startLabel setTextColor:[UIColor darkGrayColor]];
    [headerView addSubview:startLabel];
    
    [startLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *startLabelTopConstraint = [NSLayoutConstraint constraintWithItem:startLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:startLabel.superview
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:25];
    
    NSLayoutConstraint *startLabelLeadingConstraint = [NSLayoutConstraint constraintWithItem:startLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:startLabel.superview
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1
                                                                      constant:30];
    
    NSLayoutConstraint *startLabelTrailingConstraint = [NSLayoutConstraint constraintWithItem:startLabel.superview
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:startLabel
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1
                                                                          constant:30];
    
    // Set up separater
    UIView *line = [[UIView alloc] init];
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    line.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:line];
    
    NSLayoutConstraint *lineLeadingConstraint = [NSLayoutConstraint constraintWithItem:line
                                                                                   attribute:NSLayoutAttributeLeading
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:line.superview
                                                                                   attribute:NSLayoutAttributeLeading
                                                                                  multiplier:1
                                                                                    constant:30];
    
    NSLayoutConstraint *lineTrailingConstraint = [NSLayoutConstraint constraintWithItem:line.superview
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:line
                                                                                    attribute:NSLayoutAttributeTrailing
                                                                                   multiplier:1
                                                                                     constant:30];
    
    NSLayoutConstraint *lineHeightConstraint = [NSLayoutConstraint constraintWithItem:line
                                                                              attribute:NSLayoutAttributeHeight
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:nil
                                                                              attribute:NSLayoutAttributeHeight
                                                                             multiplier:1
                                                                               constant:1];
    
    
    // Sub label
    UILabel *subTitle = [[UILabel alloc] init];
    [subTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [subTitle setText:@"Basic Account Info"];
    [subTitle setTextColor:[UIColor pgb_lightBlueColor]];
    [headerView addSubview:subTitle];
    
    NSLayoutConstraint *subTitleLeadingConstraint = [NSLayoutConstraint constraintWithItem:subTitle
                                                                             attribute:NSLayoutAttributeLeading
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:subTitle.superview
                                                                             attribute:NSLayoutAttributeLeading
                                                                            multiplier:1
                                                                              constant:30];
    
    NSLayoutConstraint *subTitleTrailingConstraint = [NSLayoutConstraint constraintWithItem:subTitle.superview
                                                                              attribute:NSLayoutAttributeTrailing
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:subTitle
                                                                              attribute:NSLayoutAttributeTrailing
                                                                             multiplier:1
                                                                               constant:30];
    
    NSLayoutConstraint *subTitleBottomConstraint = [NSLayoutConstraint constraintWithItem:subTitle.superview
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:subTitle
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:22];
    
    NSLayoutConstraint *subTitleTopConstraint = [NSLayoutConstraint constraintWithItem:subTitle
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:line
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1
                                                                                 constant:12];
    
    
    // Activate constraints
    self.tableView.tableHeaderView = headerView;
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects: startLabelTopConstraint, startLabelLeadingConstraint, startLabelTrailingConstraint, lineLeadingConstraint, lineTrailingConstraint, lineHeightConstraint, subTitleTopConstraint, subTitleBottomConstraint, subTitleLeadingConstraint, subTitleTrailingConstraint, nil]];
    
}

- (void)configureSubmitButton
{
    self.tableView.userInteractionEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 145)];
    self.tableView.tableFooterView.userInteractionEnabled = YES;
    self.submitButton = [[UIButton alloc] init];
    self.submitButton.userInteractionEnabled = YES;
    [self.submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [self.submitButton pgb_styleAsBlueButton];
    
    [self.submitButton addTarget:self action:@selector(tappedSubmitButton) forControlEvents:UIControlEventTouchUpInside];

    [self configureButtonStatus];
    [self.submitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView.tableFooterView addSubview:self.submitButton];

    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                                 attribute:NSLayoutAttributeLeading
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.submitButton.superview
                                                                                 attribute:NSLayoutAttributeLeading
                                                                                multiplier:1
                                                                                  constant:30];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton.superview
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.submitButton
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1
                                                                                   constant:30];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.submitButton.superview
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1
                                                                           constant:27];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton.superview
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:self.submitButton
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:36];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.submitButton
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1
                                                                             constant:44];
    
    
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:topConstraint, bottomConstraint, leadingConstraint, trailingConstraint, heightConstraint, nil]];
    
}

- (void)configureButtonStatus
{
    self.submitButton.enabled = [self isValidPassowrd:self.passwordCell.textField.text];
}

#pragma mark - Notification Registration
- (void)registerForTextFielddNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}

- (void)deregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Password Validation

- (void)textFieldDidChange:(NSNotification *)notification
{
    [self configureButtonStatus];
    
    UITextField *textField = (UITextField *)notification.object;
    if (textField.tag == self.pswFieldIndex.integerValue || textField.tag == self.confirmPswFieldIndex.integerValue) {
        [self activelyValidatePasswordTextFields];
    }
}

- (BOOL)isValidPassowrd:(NSString *)passwordString
{
    return passwordString.length > 5;
}

- (void)activelyValidatePasswordTextFields
{
    if ([self hasValidPasswords]) {
        [self addCheckMarkToTextField:self.passwordCell.textField];
        [self addCheckMarkToTextField:self.confirmPasswordCell.textField];
    }
    else if ([self isValidPassowrd:self.passwordCell.textField.text]) {
        [self addCheckMarkToTextField:self.passwordCell.textField];
        [self removeAnnotationsFromTextField:self.confirmPasswordCell.textField];
    }
    else {
        [self removeAnnotationsFromPasswordFields];
    }
}

- (BOOL)hasValidPasswords
{
    NSString *password1 = self.passwordCell.textField.text;
    NSString *password2 = self.confirmPasswordCell.textField.text;

    BOOL validFirstPassword = [self isValidPassowrd:self.passwordCell.textField.text];
    BOOL passwordsMatch = [password1 isEqualToString:password2];
    return validFirstPassword && passwordsMatch;
}

- (void)addCheckMarkToTextField:(UITextField *)field
{
    field.rightViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 10)];
    imageView.image = [UIImage imageNamed:@"check.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    field.rightView = imageView;
    [field pgb_styleWithMediumWeightBlueText];
}

- (void)removeAnnotationsFromPasswordFields
{
    [self removeAnnotationsFromTextField:self.passwordCell.textField];
    [self removeAnnotationsFromTextField:self.confirmPasswordCell.textField];
}

- (void)removeAnnotationsFromTextField:(UITextField *)field
{
    field.rightViewMode = UITextFieldViewModeNever;
    field.rightView = nil;
    field.leftViewMode = UITextFieldViewModeNever;
    field.leftView = nil;
    [field pgb_styleWithGrayText];
}

- (void)markInvalidPasswords
{
    UITextField *field = self.confirmPasswordCell.textField;
    field.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    imageView.image = [UIImage imageNamed:@"icnCreateaccountMissinginfoActive.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    UIView *containerView = [[UIView alloc] init];
    containerView.frame = CGRectMake(0, 0, 28, 16);
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:imageView];

    field.leftView = containerView;

    self.confirmPasswordCell.textField.textColor = [UIColor pgb_redColor];
    [self showErrorBanner];
}

#pragma mark - Error Banner

- (void)configureErrorBanner
{
    CGRect bannerFrame = CGRectMake(0.0, -126, [[UIApplication sharedApplication] keyWindow].frame.size.width, 106);
    UIView *banner = [[UIView alloc] initWithFrame:bannerFrame];
    banner.backgroundColor = [UIColor pgb_redColor];
    [banner pgb_styleShadowWithColor:[UIColor pgb_grayShadowColor] shadowOpacity:1.0 shadowOffset:CGSizeMake(0, 0.5) shadowRadius:4.0];

    UILabel *bannerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 235, 40)];
    bannerLabel.textColor = [UIColor whiteColor];
    bannerLabel.numberOfLines = 0;
    bannerLabel.textAlignment = NSTextAlignmentCenter;
    bannerLabel.text = @"Passwords do not match. Please try again";
    bannerLabel.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    [bannerLabel sizeToFit];
    [banner addSubview:bannerLabel];
    bannerLabel.center = CGPointMake(CGRectGetMidX(banner.bounds), (38 + bannerLabel.frame.size.height / 2));

    self.errorBanner = banner;
    self.errorBanner.alpha = 0.0;
    [self.view addSubview:banner];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(hideErrorBanner)];
    tap.cancelsTouchesInView = YES;

    [banner addGestureRecognizer:tap];
}

- (void)showErrorBanner
{
    self.errorDisplayed = YES;
    self.errorBanner.alpha = 1.0;
    [self.view bringSubviewToFront:self.errorBanner];
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect fixedFrame = self.errorBanner.frame;
                         fixedFrame.origin.y = 0 + self.tableView.contentOffset.y;
                         self.errorBanner.frame = fixedFrame;
                     }];
}

- (void)hideErrorBanner
{
    self.errorDisplayed = NO;
    CGRect hiddenFrame = CGRectMake(0.0, -226, self.errorBanner.frame.size.width, self.errorBanner.frame.size.height);
    
    __weak CreateAccountViewController *welf = self;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.errorBanner.frame = hiddenFrame;
                     }
                     completion:^(BOOL finished) {
                         welf.errorBanner.alpha = 0.0;
                     }];
}

#pragma mark - Navigation

- (IBAction)tappedBackArrow:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Date Selection

- (void)revealAndSelectPickerView
{
    [self.activeField resignFirstResponder];
    self.shouldHidePickerView = NO;
    [self.birthDateTextField pgb_styleWithGrayText];
    [self selectedDate];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    NSIndexPath *pathToSelect = [NSIndexPath indexPathForRow:5 inSection:0];
    [self.tableView scrollToRowAtIndexPath:pathToSelect
                          atScrollPosition:UITableViewScrollPositionNone
                                  animated:YES];
    [self.birthDatePickerView becomeFirstResponder];
}

- (void)hidePickerView
{
    self.shouldHidePickerView = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.birthDateTextField pgb_styleWithMediumWeightBlueText];
}

- (void)selectedDate
{
    self.birthDateTextField.text = [NSDateFormatter localizedStringFromDate:self.birthDatePickerView.date
                                                                  dateStyle:NSDateFormatterLongStyle
                                                                  timeStyle:NSDateFormatterNoStyle];
    [self.birthDateTextField pgb_styleWithGrayText];
}

#pragma mark - TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideErrorBanner];
    if (indexPath.row == 3) {
        self.shouldHidePickerView = !self.shouldHidePickerView;

        if (self.shouldHidePickerView) {
            [self hidePickerView];
        }
        else {
            [self revealAndSelectPickerView];
        }
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (indexPath.row == 4 && !self.shouldHidePickerView) {
        height = 217;
    } else if (indexPath.row == 4 && self.shouldHidePickerView) {
        height = 0.0;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SiteSpectSDK objectForLiveVariableWithKey:@"cell_bg_color"]) {
        NSArray *colors = [SiteSpectSDK objectForLiveVariableWithKey:@"cell_bg_color"];
        cell.backgroundColor = [UIColor colorWithRed:[colors[0] floatValue] green:[colors[1] floatValue] blue:[colors[2] floatValue] alpha:1.0];
    } else {
        [cell setBackgroundColor:[UIColor pgb_lightGrayBackgroundColor]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRows = [self.inputs count];
    
    return numOfRows;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *placeHolder = [self.inputs objectAtIndex:indexPath.row];
    BasicTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:placeHolder];
    if ( cell == nil || [placeHolder isEqualToString:@"Date Picker"] ) {
        cell = [[BasicTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeHolder];
    }
    cell.textField.placeholder = placeHolder;
    
    [cell.textField setTag:indexPath.row];
    cell.textField.delegate = self;
    
    if ( [placeHolder isEqualToString:@"Password"] || [placeHolder isEqualToString:@"Confirm password"])
    {
        [cell.textField setSecureTextEntry:YES];
        if ([placeHolder isEqualToString:@"Password"]) {
            _passwordCell = cell;
        } else {
            _confirmPasswordCell = cell;
        }
    } else if ([placeHolder isEqualToString:@"Date Picker"]) {
        [cell.textField setHidden:YES];
        [cell.separatorView setHidden:YES];
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 217)];
        [picker setDatePickerMode:UIDatePickerModeDate];
        [picker addTarget:self action:@selector(selectedDate) forControlEvents:UIControlEventValueChanged];
        picker.maximumDate = [NSDate date];
        [cell.contentView addSubview:picker];
        _birthDatePickerView = picker;
    } else if ([placeHolder isEqualToString:@"Date of birth"]) {
        _birthDateTextField = cell.textField;
        // In order to be able to select the cell, textfield must be set to non interactive
        _birthDateTextField.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - TextFields

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hidePickerView];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    if (textField.tag == self.pswFieldIndex.integerValue || textField.tag == self.confirmPswFieldIndex.integerValue) {
        [self activelyValidatePasswordTextFields];
        [self hideErrorBanner];
        UIEdgeInsets currentInsets = self.tableView.contentInset;
        self.tableView.contentInset = UIEdgeInsetsMake(currentInsets.top, currentInsets.left, currentInsets.bottom + kPGBSubmitButtonInsetPadding, currentInsets.right);
    }
    else {
        [textField pgb_styleWithGrayText];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
    if (textField.tag == self.pswFieldIndex.integerValue || textField.tag == self.confirmPswFieldIndex.integerValue) {
        [self activelyValidatePasswordTextFields];
        UIEdgeInsets currentInsets = self.tableView.contentInset;
        self.tableView.contentInset = UIEdgeInsetsMake(currentInsets.top, currentInsets.left, currentInsets.bottom - kPGBSubmitButtonInsetPadding, currentInsets.right);
        [textField resignFirstResponder];
    }
    else {
        [textField pgb_styleWithMediumWeightBlueText];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReturn = NO;
    switch (textField.tag) {
        case 2:
            [self revealAndSelectPickerView];
            break;
        case 8:
            shouldReturn = YES;
            [textField resignFirstResponder];
            [self validatePasswordsAndAttemptSegueToFinalScreen];
            break;
        default:
            [[self.view viewWithTag:(textField.tag + 1)] becomeFirstResponder];
            break;
    }

    return shouldReturn;
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        CGPoint offset = [scrollView contentOffset];
    
        if (offset.y < 2) {
            self.navigationController.navigationBar.layer.shadowOpacity = 0.0;
        }
        else {
            self.navigationController.navigationBar.layer.shadowOpacity = 1.0;
        }
    
    if (self.errorDisplayed) {
        CGRect fixedFrame = self.errorBanner.frame;
        fixedFrame.origin.y = 0 + scrollView.contentOffset.y;
        self.errorBanner.frame = fixedFrame;
    }
}

@end