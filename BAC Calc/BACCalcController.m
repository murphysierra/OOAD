//
//  BACCalcController.m
//  BAC Calc
//
//  Created by Jake Charland on 11/6/12.
//
//

#import "BACCalcController.h"
#import "BACCalc.h"

@interface BACCalcController ()
- (void)initializeDefaultDataList;
@end

@implementation BACCalcController

- (void)initializeDefaultDataList {
    
    
    
    NSMutableArray *valueList = [[NSMutableArray alloc] init];
    self.masterDrinkList = valueList;
    BACCalc *value;
    NSDate *today = [NSDate date];
    value = [[BACCalc alloc] initWithName:@"Vodka" drinkValue:0 date:today];
    [self addBACCalcInput:value];
}

- (void)setmasterDrinkList:(NSMutableArray *)newList {
    if (_masterDrinkList != newList) {
        _masterDrinkList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.masterDrinkList count];
}

- (BACCalc *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterDrinkList objectAtIndex:theIndex];
}

- (void)addBACCalcInput:(BACCalc*)value {
    [self.masterDrinkList addObject:value];
}

@end
