//
//  Person.h
//  BAC Calc
//
//  Created by Luke Connors on 11/6/12.
//
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, retain) NSNumber *weight;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSNumber *matabRate;
@property (nonatomic) NSInteger alarm;

-(id)initWithGender:(NSString *)gender personWeight:(NSNumber *) weight;

@end
