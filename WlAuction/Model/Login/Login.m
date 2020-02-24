//
//  Login.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "Login.h"

static Login *sharedInstance;

@implementation Login

+(Login *)sharedInstance {
    if(sharedInstance == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:@"currentUser"];
        Login *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        sharedInstance = object;
    }
    return sharedInstance;
}

+(void)resetSharedInstance {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    sharedInstance = nil;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
