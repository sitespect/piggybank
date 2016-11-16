//
//  SiteSpectSDK.h
//  SiteSpectSDK
//
//  Created by Nick Donaldson on 1/21/14.
//  Copyright (c) 2014 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for SiteSpectSDK.
FOUNDATION_EXPORT double SiteSpectSDKVersionNumber;

//! Project version string for SiteSpectSDK.
FOUNDATION_EXPORT const unsigned char SiteSpectSDKVersionString[];

@protocol SiteSpectSessionData;

/**
 *  Log verbosity
 */
typedef NS_ENUM(NSUInteger, SSPCTLogLevel) {
    SSPCTLogLevelDebug = 0,
    SSPCTLogLevelInfo,
    SSPCTLogLevelError
};

/**
 *  Public SiteSpect SDK interface.
 *  All methods in this interface must be called on the main thread, or an exception will be thrown.
 */

@interface SiteSpectSDK : NSObject

/**
 *  Set the site ID and enable the SDK in one line.
 *  @param siteID Identifier of app registered with SiteSpect.
 */
+ (void)enableWithSiteID:(NSString *)siteID;

/**
 *  Set the site ID and optionally delay the session start.
 *  Use [SiteSpectSDK startSession] to start the session
 *  and attempt user assignment.
 *  @param siteID Identifier of app registered with SiteSpect.
 *  @param delayed Mark the session to be dalyed.
 */
+ (void)enableWithSiteID:(NSString *)siteID withSessionDelay:(BOOL)delayed;

/**
 *  Set the site ID and enable the SDK and enable/disable Visual Editor
 *  @param siteID Identifier of app registered with SiteSpect.
 *  @param disabled
 *          YES - Disable Visual Editor
 *          NO  - Enable Visual Editor
 */
+ (void)enableWithSiteID:(NSString *)siteID disableVisualEditor:(BOOL)disabled;

/**
 *  Set the site ID for the SDK without enabling it.
 *  If the SDK is already enabled, this will log an error and do nothing.
 *  @param siteID Identifier of app registered with SiteSpect.
 */
+ (void)setSiteID:(NSString *)siteID;

/**
 *  Enable or disable the SDK.
 *  This is useful for delaying campaign placement until after login, for example,
 *  to give time to attach additional metadata to placement requests.
 *  If the client ID is not set, attempting to enable the SDK will log an error and do nothing.
 */
+ (void)setSDKEnabled:(BOOL)enabled;

/**
 *  Set console logging level. Defaults to SSPCTLogLevelError.
 */
+ (void)setLogLevel:(SSPCTLogLevel)logLevel;

/**
 *  Returns the object for the given 'key' at the top level of live variables structure
 */
+ (id)objectForLiveVariableWithKey:(NSString *)key;

/**
 *  Set session timeout interval.
 *  After this amount of time in the background, the user's session is 
 *  considered finished and a new session will begin.
 *  Defaults to 8 seconds. Minimum is 1 second, maximum is 30 seconds.
 */
+ (void)setSessionTimeoutInterval:(NSTimeInterval)sessionTimeoutInterval;

/**
 *  Retrieve the current session data for use with other services.
 *  If there is not a current session in progress, this will be nil.
 *
 *  Session logic is managed internally to the SDK, so in order to get the most up-to-date session data
 *  for third-party usage, it is recommended to call this method on application:didEnterBackground:
 */
+ (id<SiteSpectSessionData>)sessionData;

/**
 *  Trigger code when a user is assigned to a Variation Group (also known as a test), determined by the SDK identifier of the Variation Group.
 *
 *  @param sdkIdentifier   The SDKIdentifier of a Variation Group. 
 *
 *  @param baselineBlock   A block which will be executed when the assigned variationGroup.sdkIdentifier does not match the sdkIdentifier parameter. May be set to nil if no changes are required for this scenario.
 *
 *  @param changesBlock    A block which will be executed when the assigned variationGroup.sdkIdentifier matches the sdkIdentifier parameter. May be set to nil if no changes are required for this scenario.
 *
 */
+ (void)applyChangesForVariationGroupWithSDKIdentifier:(NSString *)sdkIdentifier
                                          baseline:(void (^)())baselineBlock
                                           changes:(void (^)())changesBlock;

/**
 *  Trigger a metric (also known as a Response Point) in code based on its SDK identifier.
 *
 *  @param metricIdentifier The SDK Identifier of the metric being triggered.
 *                          A search is performed for a matching metric within the currently assigned tests.
 *                          Nothing is triggered if no match is found.
 *
 *  @param valueCapture    An optional numeric value which will be recorded with the metric.
 *                         Multiple captures for the same metric within a session will be averaged together.
 */
+ (void)triggerMetricWithSDKIdentifier:(NSString *)sdkIdentifier valueCapture:(NSNumber *)valueCapture;

/**
 *  Return the comletionHandler wrapper which fetches and applys variations to the front most screen,
 *  then calls the completionHandler
 *
 *  @param completionHandler The completionHandler of performFetchWithCompletionHandler from Application
 *                           delegate method.
 */
+ (void (^)(UIBackgroundFetchResult))sspctCompletionHandlerWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 *  Immediately starts the SiteSpect session and attempts user assignment.
 */
+ (void)startSession;

@end

/**
 *  Protocols for session data objects.
 *  These (immutable) objects can be returned and used to provide session data to other metrics/analytics services.
 */
@protocol SiteSpectSessionData <NSObject>

/**
 *  Dictionary containing assigned test and change identifiers for this session.
 *  Due to the possibility of overlaid tests, there may be multiple entries.
 *
 *  keys - Test identifier
 *  values - Version identifier for the test
 *
 *  For example, a user placed in version 1001 of test 100 would produce
 *
 *    { "100" : "1001" }
 *
 */
@property (nonatomic, readonly) NSDictionary *assignmentInfo;

/** Time the session began. */
@property (nonatomic, readonly) NSDate *startTime;

/** Duration of the session, thus far, in seconds. */
@property (nonatomic, readonly) NSTimeInterval duration;

/** 
 *  Array of objects conforming to <SiteSpectMetricsData>
 *  Each object represents a metric that was triggered during this session
 */
@property (nonatomic, readonly) NSArray *trackedMetrics;

@end

@protocol SiteSpectMetricsData <NSObject>

/** ID of the metric that was triggered */
@property (nonatomic, readonly) NSString *metricID;

/** Number of times the metric was triggered this session */
@property (nonatomic, readonly) NSUInteger hitCount;

/** Average of all values captured by this metric for the current session, or nil if no values were captured */
@property (nonatomic, readonly) NSNumber *valueCapture;

@end
