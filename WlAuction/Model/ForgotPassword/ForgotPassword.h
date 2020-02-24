//
//  ForgotPassword.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ForgotPassword : JSONModel

@property (assign, nonatomic) id<Optional> dealer_id;
@property (strong, nonatomic) NSString<Optional> *success_message;
@property (strong, nonatomic) NSString<Optional> *error_message;
@end
