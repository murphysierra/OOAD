//
//  Profile.h
//  BAC Calc
//
//  Created by Jake Charland on 11/26/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSNumber * habits;

@end
