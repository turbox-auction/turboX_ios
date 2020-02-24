//
//  Validations.m
//  WlAuction
//
//  Created by LB 3 Mac Mini on 31/12/15.
//  Copyright © 2015 LB 3 Mac Mini. All rights reserved.
//

#import "Validations.h"

@implementation Validations

+(id)sharedInstance {
    static Validations *objValidations = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objValidations = [[self alloc]init];
    });
    return objValidations;
}

-(id)init {
    if(self = [super init]) {
        
    }
    return self;
}

-(void)dealloc {
    
}



-(BOOL)validationForEmail:(UITextField *)textField
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if([emailTest evaluateWithObject:textField.text])
    {
        return YES;
    }
    else
    {
        [self addShakeAnimations:textField];
        return NO;
    }
    
}

-(BOOL)validationForLength:(UITextField *)textField
{
    if([textField.text length]>6)
    {
        return YES;
    }
    else
    {
        [self addShakeAnimations:textField];
        return NO;
    }
    
}

-(BOOL)validationForPassword:(UITextField *)textField
{
    if([textField.text length]>=6)
    {
        return YES;
    }
    else
    {
        [self addShakeAnimations:textField];
        return NO;
    }
    
}

-(void)addShakeAnimations:(UITextField *)textField{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position.x";
    animation.values = @[ @0, @10, @-10, @10, @0 ];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
    animation.duration = 0.3;
    
    animation.additive = YES;
    
    [textField.layer addAnimation:animation forKey:@"shake"];
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
