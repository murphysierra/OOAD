//
//  ThirdViewController.m
//  BAC Calc
//
//  Created by Jake Charland on 11/26/12.
//
//

#import "ThirdViewController.h"

@class BACCalcController;
@class FirstViewController;

@interface ThirdViewController ()

@end

@implementation ThirdViewController
@synthesize frequency;
@synthesize label;
@synthesize gender;
@synthesize weightEntered;
@synthesize weightError;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background3.png"]];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.myEquation = appDelegate.equation;
    weightError.text = @" ";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeSegFrequency{
    if(frequency.selectedSegmentIndex == 0){
        //add value to person
        _myEquation.myPerson.matabRate = [NSNumber numberWithFloat:(0.020/60/60)];
	}
	if(frequency.selectedSegmentIndex == 1){
        //add value to person
        _myEquation.myPerson.matabRate = [NSNumber numberWithFloat:(0.017/60/60)];
	}
    if(frequency.selectedSegmentIndex == 2){
        //add value to person
        _myEquation.myPerson.matabRate = [NSNumber numberWithFloat:(0.015/60/60)];
	}
    
}

-(IBAction)changeSegGender{
    
    NSString *selectedGender;
    if(gender.selectedSegmentIndex == 0)
    {
        selectedGender = @"Male";
    }
    if(gender.selectedSegmentIndex == 1)
    {
        selectedGender = @"Female";
    }
    _myEquation.myPerson.gender = selectedGender;
}

-(IBAction)userDoneEnteringText:(id)sender
{
    UITextField *theField = (UITextField*)sender;
    // do whatever you want with this text field
    NSString *text1;
    text1 = theField.text;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    if([f numberFromString: text1])
    {
        _myEquation.myPerson.weight = [NSNumber numberWithFloat:[text1 floatValue]];
        weightError.text = @" ";
    }
    else
    {
       weightError.text = @"Not A Valid Entry";
    }
}


- (void)viewDidUnload {
    [self setWeightError:nil];
    [super viewDidUnload];
}
@end
