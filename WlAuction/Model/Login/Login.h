//
//  Login.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Login : JSONModel

@property (nonatomic,strong) NSString *error_message;
@property (nonatomic,strong) NSString *dealer_id;
@property (nonatomic,strong) NSString *auth_key;
@property (nonatomic,strong) NSString *display_name;
@property (nonatomic,strong) NSString *dealer_country;
@property (nonatomic,strong) NSString *dealer_type;
@property (nonatomic,strong) NSString *dealer_email;
@property (nonatomic,strong) NSString *user_type;
@property (nonatomic,strong) NSString *term_cond;
@property (nonatomic,strong) NSString *dealer_address;
@property (nonatomic,strong) NSString *dealer_primary_phone;
@property (nonatomic,strong) NSString *omvic_number;
@property (nonatomic,strong) NSString *rin_number;
@property (nonatomic,strong) NSString *hst_number;



+(Login *)sharedInstance;
+(void)resetSharedInstance;
@end
