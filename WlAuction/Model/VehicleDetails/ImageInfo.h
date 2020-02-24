//
//  ImageInfo.h
//  WlAuction
//
//  Created by Ashutosh Dave on 18/03/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ImageInfo
@end

@interface ImageInfo : JSONModel

@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *image_id;

@end
