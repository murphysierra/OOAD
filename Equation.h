//
//  Equation.h
//  BAC Calc
//
//  Created by Luke Connors on 11/6/12.
//
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Slope.h"
#import "FirstViewController.h"
@class Slope;
@class Person;

@interface Equation : NSObject

@property (nonatomic, retain) Person *myPerson;
@property (nonatomic, copy) NSMutableArray *slopes;
@property (nonatomic, retain) NSNumber *m;
@property (nonatomic, retain) NSNumber *b;
@property (nonatomic) NSInteger time;

- (id)initWithPerson:(Person *)person;

- (void)addBAC:(NSNumber *) percent:(NSNumber *) volume;

- (void)throwUp;

- (void)decrementSlopesExperation;

- (void)checkSlopesExperation;

- (void)removeSlope:(Slope *) slope;

- (Boolean)needAlarm;

- (NSNumber *)getCurrBAC;

@end
