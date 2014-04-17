//
//  FourthViewController.m
//  BAC Calc
//
//  Created by Luke Connors on 12/6/12.
//
//

#import "FourthViewController.h"
#import "AppDelegate.h"
#import "FirstViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

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
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    self.myEquation = appDelegate.equation;
    _alarmDatePicker.minimumDate = [NSDate date];
    _alarmDatePicker.minuteInterval = 5;
    
    [self confitureButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currAlarm) {
        _alarmDatePicker.date = _currAlarm;
    }
    else _alarmDatePicker.date = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAlarmDatePicker:nil];
    [self setSetAlarm:nil];
    [super viewDidUnload];
}


- (IBAction)touchUpInside:(id)sender {
    if (_setAlarm.touchInside == true) {
        //NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        
        NSDate *alarm = [_alarmDatePicker date];
        NSDate *now = [NSDate date];
        NSCalendar *currCalendar = [NSCalendar currentCalendar];
        
        _currAlarm = alarm;
        
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;
        
        NSDateComponents *conversionInfo = [currCalendar components:unitFlags fromDate:now  toDate:alarm  options:0];
        
        int days = [conversionInfo day];
        int hours = [conversionInfo hour];
        int minutes = [conversionInfo minute];
        
        NSInteger alarmTime = (minutes + hours*60 + days*24*60)*60;
        _myEquation.myPerson.alarm = alarmTime;
    }
}


- (void)confitureButtons {
    _setAlarm.layer.cornerRadius = 5; // this value vary as per your desire
    _setAlarm.clipsToBounds = YES;
    _setAlarm.layer.borderWidth = 1.0f;
    _setAlarm.layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = _setAlarm.layer.bounds;
    // Set the gradient colors
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.75f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:0.4f alpha:0.2f].CGColor,
                         (id)[UIColor colorWithWhite:1.0f alpha:0.4f].CGColor,
                         nil];
    // Set the relative positions of the gradien stops
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.5f],
                            [NSNumber numberWithFloat:0.8f],
                            [NSNumber numberWithFloat:1.0f],
                            nil];
    
    // Add the layer to the button
    [_setAlarm.layer addSublayer:shineLayer];    
}

@end
