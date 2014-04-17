//
//  FourthViewController.h
//  BAC Calc
//
//  Created by Luke Connors on 12/6/12.
//
//

#import <UIKit/UIKit.h>
#import "Equation.h"

@interface FourthViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *setAlarm;
@property (nonatomic, retain) Equation *myEquation;
@property (nonatomic, retain) NSDate *currAlarm; 

- (IBAction)touchUpInside:(id)sender;

@end
