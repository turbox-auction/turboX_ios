//
//  WSLoading.m
//  Mindless
//
//  Created by Nilesh on 31/07/15.
//  Copyright (c) 2015 LiveBird Mac Mini. All rights reserved.
//

#import "WSLoading.h"
#import "JTProgressHUD.h"
#import "Reachability.h"
#import "AFNetworking.h"

static NSString *const currentUser = @"currentUser";


@implementation WSLoading

+(WSLoading *)sharedInstance{
    static WSLoading *sharedInstance = nil;
    static dispatch_once_t onceToken;
    if (sharedInstance == nil)
    {
        dispatch_once(&onceToken, ^{
            sharedInstance = [[WSLoading alloc] init];
        });
    }
    return sharedInstance;
}
+(BOOL )isNetAvailable{
    Reachability *rechability = [Reachability reachabilityForInternetConnection];
    [rechability startNotifier];
    NetworkStatus netStatus = [rechability currentReachabilityStatus];
    if (netStatus == NotReachable) {
        return false;
    }
    return true;
}

+(void)callWebService:(NSURLRequest *)request resultBlock:(void (^) (BOOL isSuccess, NSString*message, NSString *strResponse)) result{
    if ([WSLoading isNetAvailable]) {
        [WSLoading showLoading];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            [WSLoading dismissLoading];
            if (data) {
                NSString *returnstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"Response:%@",returnstr);
                result(true, @"Data received successfully", returnstr);
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Some error, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                result(false, @"Some error, Please try again later.", @"");
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Net is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        result(false, @"Net is not available", @"");
    }
}

+(void)callWebServiceWithOutLoading:(NSURLRequest *)request resultBlock:(void (^) (BOOL isSuccess, NSString*message, NSString *strResponse)) result{
    if ([WSLoading isNetAvailable]) {
        NSDate *startDate = [NSDate date];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDate *endDate = [NSDate date];
            NSTimeInterval timeInt = [endDate timeIntervalSinceDate:startDate];
            NSLog(@"Time Int: %f",timeInt);
            if (data) {
                NSString *returnstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                result(true, @"Data received successfully", returnstr);
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Some error, Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                result(false, @"Some error, Please try again later.", @"");
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Net is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        result(false, @"Net is not available", @"");
    }
}


+(void)showLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [JTProgressHUD showWithStyle:JTProgressHUDStyleGradient];
    });
}

+(void)dismissLoading{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [JTProgressHUD hide];
        });
    });
}

+(void)showAlertWithTitle:(NSString *)title Message:(NSString *)message {
    UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [successAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [[[[UIApplication sharedApplication] keyWindow]rootViewController] presentViewController:successAlert animated:YES completion:nil];
    
}

// Webservice call for POST

+(void)postResponseWithParameters:(NSDictionary *)parameters Url:(NSString *)urlString CompletionBlock:(void (^)(id result))block {
    if([WSLoading isNetAvailable]) {
        [WSLoading showLoading];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

        
        [manager.requestSerializer setValue:[Login sharedInstance].auth_key forHTTPHeaderField:@"AUTH-KEY"];
        
        NSDate *startDate = [NSDate date];
        
        [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            [WSLoading dismissLoading];
            NSDate *endDate = [NSDate date];
            NSTimeInterval timeInt = [endDate timeIntervalSinceDate:startDate];
            NSLog(@"Time Taken:%f",timeInt);
            block(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error) {
                [WSLoading dismissLoading];
//                NSLog(@"Error Post:%@",error.localizedDescription);
//                [WSLoading showAlertWithTitle:@"Error" Message:error.localizedDescription];
                
                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                if(data != nil) {
                    NSError* error;
                NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"json:%@",jsonStr);

                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingAllowFragments
                                                                           error:&error];
                    NSLog(@"json:%@",json);
                    [WSLoading showAlertWithTitle:@"Alert" Message:[json objectForKey:@"error_message"]];
                }

            }
        }];
    }else {
        [WSLoading showAlertWithTitle:@"No Internet" Message:@"Internet is not available"];
    }
}

// Webservice call for GET
+(void)getResponseWithParameters:(NSDictionary *)parameters Url:(NSString *)urlString Headers:(NSDictionary *)headers CompletionBlock:(void (^)(id result))block{
    if ([WSLoading isNetAvailable]) {
        [WSLoading showLoading];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        if(headers.count > 0) {
            for (id key in headers) {
                 [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
            }
        }
        
        [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [WSLoading dismissLoading];
            block(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(error) {
                [WSLoading dismissLoading];
                NSLog(@"Error Get:%@",error.localizedDescription);
                
                NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
                
                if(data) {
                    NSError* jsonError;
    //                NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:NSJSONReadingAllowFragments
                                                                                   error:&jsonError];
                    NSLog(@"json:%@",json);
                    [WSLoading showAlertWithTitle:@"Error" Message:[json objectForKey:@"error_message"]];
                }else {
                    [WSLoading showAlertWithTitle:@"Error" Message:error.localizedDescription];
                }

            }
        }];
    }else {
        [WSLoading showAlertWithTitle:@"No Internet" Message:@"Internet is not available"];
    }
}

+(void)saveCurrentUser:(Login *)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:currentUser];
    [defaults synchronize];
    [self sendUserDeviceToken];
    
}

+(void)saveCurrentVehicleDetails:(VehicleDetails *)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"currentVehicleDetails"];
    [defaults synchronize];
    
}

+ (NSString *)getCurrentVehicleDetailForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"currentVehicleDetails"];
    VehicleDetails *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return [object valueForKey:key];
}

+ (NSString *)getCurrentUserDetailForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:currentUser];
    Login *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    NSString *tempValue = [object valueForKey:key];
    
    if(tempValue.length > 0) {
        return tempValue;
    }else {
        return @" ";
    }
}

+(NSString *)convertToStringAuctionStatus:(NSString *)status {
    __block NSString *auctionType;
    typedef void (^AuctionBlock)();
    
    NSDictionary *tempDict = @{
                        @"S":
                            ^{
                                auctionType = @"SOLD";
                            },
                        @"W":
                            ^{
                                auctionType = @"WON";
                            },
                        @"O":
                            ^{ 
                                auctionType = @"PENDING";
                            },
                        @"E":
                            ^{
                                auctionType = @"EXTENDED";
                            },
                        @"C":
                            ^{
                                auctionType = @"CANCELLED";
                            },
                        @"D":
                            ^{ 
                                auctionType = @"DELIVERED";
                            },
                        @"L":
                            ^{
                                auctionType = @"LIVE";
                            },
                        
                        @"U":
                            ^{
                                auctionType = @"UPCOMING";
                            },
                        @"P":
                            ^{
                                auctionType = @"PARK";
                            }
                        
                        };
    
//    ((CaseBlock)tempDict[status])();
    AuctionBlock auction = tempDict[status];
    if (auction) {
        auction();
     return auctionType;
    } else {
        return status;
    }
//    return auctionType;
}

+(NSString *)getUserDefaultValueFromKey:(NSString *)key {
    return getObjectFromUserDefaults(key);
}

+(BOOL)getBoolValueForKey:(NSString *)key {
//    return !([key isEqualToString:@"N"]) ? NO : YES;
    if([key isEqualToString:@"N"]) {
        return NO;
    }else if([key isEqualToString:@"Y"]) {
        return YES;
    }else {
        return NO;
    }
}


+(void)sendUserDeviceToken{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,APNS_REG];
//    NSDictionary *params = [NSDictionary dictionaryWithObject:[WSLoading getUserDefaultValueFromKey:@"DeviceToken"] forKey:@"regId"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [WSLoading getUserDefaultValueFromKey:@"DeviceToken"],@"regId",
                            [Login sharedInstance].auth_key,@"AUTH-KEY",
                            nil];
    
    [WSLoading postResponseWithParameters:params Url:urlString CompletionBlock:^(id result) {
        [WSLoading dismissLoading];
        NSError* error;
        NSString *json = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
        //        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:result
        //                                                             options:NSJSONReadingAllowFragments
        //                                                               error:&error];
        NSLog(@"device token JSON:%@",json);
        if(!error) {
            
        }
        
    }];
}

@end
