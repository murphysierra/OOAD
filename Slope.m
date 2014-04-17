//
//  Slope.m
//  BAC Calc
//
//  Created by Luke Connors on 11/6/12.
//
//

#import "Slope.h"

@implementation Slope


-(id)initWithValue:(NSNumber *)value expireDate:(NSInteger)expDate
{
    self = [super init];
    
    if (self) {
        _value = value;
        _expDate = expDate;
    }
    
    return self;
}
@end
