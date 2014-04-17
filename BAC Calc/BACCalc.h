//
//  BACCalc.h
//  BAC Calc
//
//  Created by Jake Charland on 11/6/12.
//
//

#import <Foundation/Foundation.h>

@interface BACCalc : NSObject

@property (nonatomic, copy) NSString *drinkType;
@property (nonatomic, copy) NSNumber *bacValue;
@property (nonatomic, strong) NSDate *date;

-(id)initWithName:(NSString *)drinkType drinkValue:(NSNumber *)bacValue date:(NSDate *)date;
@end

