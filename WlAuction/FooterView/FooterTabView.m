//
//  FooterTabView.m
//  WlAuction
//
//  Created by Rajesh on 18/10/18.
//  Copyright © 2018 LB 3 Mac Mini. All rights reserved.
//

#import "FooterTabView.h"

@implementation FooterTabView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:self options:nil];
    [self addSubview:self.view];
}

@end

