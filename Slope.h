//
//  Slope.h
//  BAC Calc
//
//  Created by Luke Connors on 11/6/12.
//
//

#import <Foundation/Foundation.h>

@interface Slope : NSObject

@property (nonatomic, retain) NSNumber *value;
@property (nonatomic) NSInteger expDate;

-(id)initWithValue:(NSNumber *) value expireDate:(NSInteger) expDate;

@end
