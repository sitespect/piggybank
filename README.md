# PiggyBank
Sample iOS App used to demo the SiteSpect Mobile SDK

<img src="https://github.com/sitespect/piggybank/raw/master/PiggyBank.png" width="300">

####Code Editor Example
This sample app includes a code change that works with a SiteSpect campaign. The following code block removes a form input on the registration screen in the application when a user is assigned to a campaign with the SDK identifier "789" (SDK identifier is the ID of a variation group):

```objective-c
  self.inputs = [NSMutableArray arrayWithObjects:@"First name", @"Middle name", @"Last name", @"Date of birth", @"Date Picker", @"Occupation", @"Email address", @"Password", @"Confirm password", nil];
 
  [SiteSpectSDK applyChangesForVariationGroupWithSDKIdentifier:@"789" baseline:nil changes:^{
    [self.inputs removeObjectAtIndex:5];
  }];
```
[See it Here](https://github.com/sitespect/piggybank/blob/master/PiggyBank/CreateAccountViewController.m#L59)

####Live Variables
Mobile Live Variables allows managing specific variables inside SiteSpect that are used within the app. These dynamic variables are retrieved in the app using the "objectForLiveVariableWithKey" call and the values are defined (in JSON format) inside SiteSpect campaigns.  For example, this sample app defines all form input labels as live variables in the app with this code:

```objective-c
   self.inputs = [NSMutableArray arrayWithObjects:@"First name", @"Middle name", @"Last name", @"Date of birth", @"Date Picker", @"Occupation", @"Email address", @"Password", @"Confirm password", nil];
 
    for (int i=0; i<[self.inputs count]; i++) {
        if ([SiteSpectSDK objectForLiveVariableWithKey:[self.inputs objectAtIndex:i]]) {
            [self.inputs setObject:[SiteSpectSDK objectForLiveVariableWithKey:[self.inputs objectAtIndex:i]] atIndexedSubscript:i];
        }
    }
```
[See it Here](https://github.com/sitespect/piggybank/blob/master/PiggyBank/CreateAccountViewController.m#L64)

Passing `{"Occupation":"Job"}` within a SiteSpect campaign changes the form input label "Occupation" to "Job" for any user that is assigned to that campaign.

