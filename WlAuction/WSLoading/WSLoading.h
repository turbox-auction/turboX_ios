//
//  WSLoading.h
//  Mindless
//
//  Created by Nilesh on 31/07/15.
//  Copyright (c) 2015 LiveBird Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSerManager.h"
#import "Login.h"
#import "VehicleDetails.h"

@interface WSLoading : NSObject

+(WSLoading *)sharedInstance;
+(BOOL )isNetAvailable;
+(void)callWebService:(NSURLRequest *)request resultBlock:(void (^) (BOOL isSuccess, NSString*message, NSString *strResponse)) result;
+(void)showLoading;
+(void)dismissLoading;
+(void)callWebServiceWithOutLoading:(NSURLRequest *)request resultBlock:(void (^) (BOOL isSuccess, NSString*message, NSString *strResponse)) result;

+(void)showAlertWithTitle:(NSString *)title Message:(NSString *)message;
+(void)getResponseWithParameters:(NSDictionary *)parameters Url:(NSString *)urlString Headers:(NSDictionary *)headers CompletionBlock:(void (^)(id result))block;
+(void)postResponseWithParameters:(NSDictionary *)parameters Url:(NSString *)urlString CompletionBlock:(void (^)(id result))block;

+(void)saveCurrentUser:(Login *)object;

+(void)saveCurrentVehicleDetails:(VehicleDetails *)objectv;
//+ (Login *)getCurrentUser;
+ (NSString *)getCurrentUserDetailForKey:(NSString *)key;
+(NSString *)convertToStringAuctionStatus:(NSString *)status;
+(NSString *)getUserDefaultValueFromKey:(NSString *)key;
+(BOOL)getBoolValueForKey:(NSString *)key;
+(void)sendUserDeviceToken;
@end
