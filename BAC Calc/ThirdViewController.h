//
//  ThirdViewController.h
//  BAC Calc
//
//  Created by Jake Charland on 11/26/12.
//
//

#import <UIKit/UIKit.h>
#import "BACCalcController.h"
#import "Equation.h"
#import "AppDelegate.h"

@interface ThirdViewController : UIViewController

@property (nonatomic, retain) IBOutlet UISegmentedControl *frequency;
@property (nonatomic, retain) IBOutlet UISegmentedControl *gender;
@property (nonatomic, retain) IBOutlet UITextField *weightEntered;
@property (strong, nonatomic) BACCalcController *dataController;
@property (nonatomic, retain) Equation *myEquation;
@property (nonatomic, retain) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *weightError;

-(IBAction)changeSegFrequency;

-(IBAction)changeSegGender;

@end
