//
//  DisclosureAuctionSetting.h
//  WlAuction
//
//  Created by Ashutosh Dave on 08/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol DisclosureAuctionSetting
@end

@interface DisclosureAuctionSetting : JSONModel

@property (nonatomic, strong) NSString *has_accident;

@end
