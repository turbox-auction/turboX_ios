//
//  Validations.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 31/12/15.
//  Copyright © 2015 LB 3 Mac Mini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Validations : NSObject

+(id)sharedInstance;


-(BOOL)validationForLength:(UITextField *)textField;
-(BOOL)validationForPassword:(UITextField *)textField;
//+(void)addShakeAnimations:(UITextField *)textField;
- (BOOL) validateEmail: (NSString *) candidate;
@end
