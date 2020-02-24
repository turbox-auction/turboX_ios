//
//  DocumentModel.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DocumentModel : JSONModel

@property (nonatomic, strong) NSString *doc_form;
@property (nonatomic, strong) NSString *doc_policy;

@end
