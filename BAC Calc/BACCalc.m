//
//  BACCalc.m
//  BAC Calc
//
//  Created by Jake Charland on 11/6/12.
//
//

#import "BACCalc.h"

@implementation BACCalc

-(id)initWithName:(NSString *)drinkType drinkValue:(NSNumber *)bacValue date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _drinkType = drinkType;
        _bacValue = bacValue;
        _date = date;
        return self;
    }
    return nil;
}

@end
