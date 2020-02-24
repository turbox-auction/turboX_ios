//
//  AllInvoice.h
//  WlAuction
//
//  Created by LB 3 Mac Mini on 23/02/16.
//  Copyright © 2016 LB 3 Mac Mini. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "Invoice.h"

@interface AllInvoice : JSONModel

@property (nonatomic, assign) int per_page_records;
@property (nonatomic, assign) int total_records;
@property (nonatomic, strong) NSArray<Invoice> *invoices;
@end
