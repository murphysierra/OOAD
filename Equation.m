//
//  Equation.m
//  BAC Calc
//
//  Created by Luke Connors on 11/6/12.
//
//

#import "Equation.h"

@implementation Equation

-(id)initWithPerson:(Person *)person
{
    self = [super init];
    
    if (self) {
        _myPerson = person;
        _slopes = [[NSMutableArray alloc] init];
        _m = [NSNumber numberWithFloat:0];
        _b = [NSNumber numberWithFloat:0];
    }
    
    return self;
}

-(void) addBAC:(NSNumber *)percent :(NSNumber *)volume
{
    NSNumber *currBAC = [NSNumber numberWithFloat:([_m floatValue] * _time + [_b floatValue])];
    
    NSNumber *r;
    if (_myPerson.gender == @"Male") {
        r = [NSNumber numberWithFloat:0.75];
    }
    else
        r = [NSNumber numberWithFloat:0.66];
    
    NSNumber *alc = [NSNumber numberWithFloat:
                     (([percent floatValue] * [volume floatValue]) * 5.14)/
                     ([_myPerson.weight floatValue] * [r floatValue])];
    
    //update person's alarm time by subtracting current time from alarm time
    if(_myPerson.alarm >= _time) _myPerson.alarm -= _time;
    else(_myPerson.alarm) = 0;
    
    _time = 0;
    
    //NSLog(@"%@", alc);
    
    NSNumber *value = [NSNumber numberWithFloat: [alc floatValue] / (25 * 60)];
    NSInteger expDate = 25 * 60;
    
    //NSLog(@"%@", value);
    
    Slope *s1 = [[Slope alloc] initWithValue:(NSNumber *)value expireDate:(NSInteger)expDate];
    
    _m = [NSNumber numberWithFloat: [s1.value floatValue] - [_myPerson.matabRate floatValue]];
    
    for (Slope *s in _slopes) {
        _m = [NSNumber numberWithFloat: [_m floatValue] + [s.value floatValue]];
    }
    
    [_slopes addObject:s1];
    
    _b = [NSNumber numberWithFloat: [currBAC floatValue]];
}

- (void)throwUp
{
    NSNumber *currBAC = [NSNumber numberWithFloat:([_m floatValue] * _time + [_b floatValue])];
    _m = [NSNumber numberWithFloat: -[_myPerson.matabRate floatValue]];
    _b = [NSNumber numberWithFloat: [currBAC floatValue]];
    _time = 0;
    [_slopes removeAllObjects];
}

- (void)decrementSlopesExperation
{
    NSMutableArray *toRemove = [[NSMutableArray alloc] init];
    for (Slope *s in _slopes) {
        s.expDate--;
        /*NSLog(@"expDate");
        NSLog(@"%@", s.value);
        NSLog(@"%d", s.expDate);*/
        if (s.expDate == 0) {
            [toRemove addObject:s];
        }
    }
    for (Slope *s in toRemove) {
        [self removeSlope:s];
    }
}

- (void)checkSlopesExperation
{
    for (Slope *s in _slopes) {
        if (s.expDate <= 0) {
            [self removeSlope:s];
        }
    }
}

- (void)removeSlope:(Slope *)slope
{
    NSNumber *currBAC = [NSNumber numberWithFloat:([_m floatValue] * _time + [_b floatValue])];
    _m = [NSNumber numberWithFloat: [_m floatValue] - [slope.value floatValue]];
    _b = [NSNumber numberWithFloat: [currBAC floatValue]];
    _time = 0;
    [_slopes removeObject: slope];
}

- (NSNumber *)getCurrBAC
{
    NSNumber *bac = [NSNumber numberWithFloat:([_m floatValue] * _time + [_b floatValue])];
   /* NSLog(@"bac");
    NSLog(@"%@",bac);
    NSLog(@"%@",_m);
    NSLog(@"%@",_b);
    NSLog(@"%d",_time);*/
    if([bac floatValue] <= 0) {
        _m = [NSNumber numberWithFloat:0];
        _b = [NSNumber numberWithFloat:0];
        return [NSNumber numberWithFloat:0];
    }
    return bac;
}

- (Boolean)needAlarm
{
    NSInteger alarmTime =  _myPerson.alarm;
    NSNumber *bac = [NSNumber numberWithFloat:([_m floatValue] * _time + [_b floatValue])];
    NSNumber *m = [NSNumber numberWithFloat:[_m floatValue]];
    NSNumber *b = [NSNumber numberWithFloat:[_b floatValue]];
    NSInteger time = _time;
    NSMutableArray *slopes = [[NSMutableArray alloc] init];
    
    for (Slope *s in _slopes) {
        Slope *sCopy = [[Slope alloc] initWithValue:(NSNumber *)s.value expireDate:(NSInteger)s.expDate];
        [slopes addObject:sCopy];
    }

    if (alarmTime == 0) {
        return false;
    }
    
    
    while (alarmTime >= 1) {
        bac = [NSNumber numberWithFloat:([m floatValue] * time + [b floatValue])];
        if ([bac floatValue] <= 0) {
            return false;       //bac reaches 0 before alarm
        }
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (Slope *s in slopes) {
            s.expDate--;
            if (s.expDate == 0) {
                [toRemove addObject:s];
            }
        }
        for (Slope *s in toRemove) {
            m = [NSNumber numberWithFloat: [m floatValue] - [s.value floatValue]];
            b = [NSNumber numberWithFloat: [bac floatValue]];
            time = 0;
            [slopes removeObject: s];
        }
        
        time++;
        alarmTime --;
    }
    
    return true;        //alarm reaches 0 before bac
}


@end
