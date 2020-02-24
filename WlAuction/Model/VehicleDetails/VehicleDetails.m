//
//  VehicleDetails.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 04/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import "VehicleDetails.h"
 VehicleDetails *sharedInstance;

@implementation VehicleDetails

+(VehicleDetails *)sharedInstance {
    
    if(sharedInstance == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:@"currentVehicleDetails"];
        VehicleDetails *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        sharedInstance = object;
    }
    return sharedInstance;
}

+(void)resetSharedInstance {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentVehicleDetails"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    sharedInstance = nil;
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end
