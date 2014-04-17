//
//  BACCalcController.h
//  BAC Calc
//
//  Created by Jake Charland on 11/6/12.
//
//

#import <Foundation/Foundation.h>
@class BACCalc;

@interface BACCalcController : NSObject
@property (nonatomic, copy) NSMutableArray *masterDrinkList;

- (NSUInteger)countOfList;
- (BACCalc *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addBACCalcInput:(BACCalc *)value;

@end
