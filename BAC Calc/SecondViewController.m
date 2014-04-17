//
//  SecondViewController.m
//  BAC Calc
//
//  Created by  on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "BACCalcController.h"
#import "BACCalc.h"
#import "AppDelegate.h"
@class BACCalcController;
@class FirstViewController;

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize picker, drinkType, drinkAlc, drinkSize, drinkImage;
@synthesize bacLabel;
@synthesize addDrink;
@synthesize dImage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background3.png"]];
	// Do any additional setup after loading the view, typically from a nib.
    self.drinkType = [[NSArray alloc] initWithObjects:
                         @"Shot", @"Double Shot", @"Glass (Hard Liquor)", @"Light Beer", @"Beer", @"Strong Beer",
                         @"Beer Pint", @"Red Wine", @"White Wine", @"Mixed Shot", @"Mixed Double Shot", @"Cocktail",
                         @"Party Cup", @"Party Cup (Strong)", nil];
    self.drinkAlc = [[NSArray alloc]
                          initWithObjects:
                          [NSNumber numberWithFloat:0.40],
                          [NSNumber numberWithFloat:0.40],
                          [NSNumber numberWithFloat:0.40],
                          [NSNumber numberWithFloat:0.032],
                          [NSNumber numberWithFloat:0.06],
                          [NSNumber numberWithFloat:0.08],
                          [NSNumber numberWithFloat:0.06],
                          [NSNumber numberWithFloat:0.13],
                          [NSNumber numberWithFloat:0.11],
                          [NSNumber numberWithFloat:0.20],
                          [NSNumber numberWithFloat:0.20],
                          [NSNumber numberWithFloat:0.30],
                          [NSNumber numberWithFloat:0.40],
                          [NSNumber numberWithFloat:0.40],
                          nil];
    self.drinkSize = [[NSArray alloc]
                      initWithObjects:
                      [NSNumber numberWithFloat:1.5],
                      [NSNumber numberWithFloat:3.0],
                      [NSNumber numberWithFloat:6.0],
                      [NSNumber numberWithFloat:12.0],
                      [NSNumber numberWithFloat:12.0],
                      [NSNumber numberWithFloat:12.0],
                      [NSNumber numberWithFloat:16.0],
                      [NSNumber numberWithFloat:5.5],
                      [NSNumber numberWithFloat:5.5],
                      [NSNumber numberWithFloat:1.5],
                      [NSNumber numberWithFloat:3.0],
                      [NSNumber numberWithFloat:6.0],
                      [NSNumber numberWithFloat:3.0],
                      [NSNumber numberWithFloat:6.0],
                      nil];
    self.drinkImage = [[NSArray alloc] initWithObjects:
                       @"MixedShot.png", @"DoubleShot.png", @"Glass.png", @"LightBeer.png", @"Beer.png", @"StrongBeer.png",
                       @"BeerPint.png", @"RedWine.png", @"WhiteWine.png", @"MixedShot.png", @"MixedDoubleShot.png",
                       @"MartiniGlass.png", @"RedSoloCup1.png", @"RedSoloCup2.png", nil];
    
    _currDrinkType = [drinkType objectAtIndex:0];
    _currAlc = [drinkAlc objectAtIndex:0];
    _currSize = [drinkSize objectAtIndex:0];
    [self confitureButtons];
}

- (void)viewDidUnload
{
    [self setThrowUp:nil];
    [self setDImage:nil];
    [self setSelectDrink:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.myEquation = appDelegate.equation;
    
    NSString *select = @"Select Drink Above";
    _selectDrink.text = [NSString stringWithString: select];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [drinkType count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [drinkType objectAtIndex:row];
} 

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    float alc = [[drinkAlc objectAtIndex:row] floatValue];
    _currAlc = [NSNumber numberWithFloat:alc];
    
    float size = [[drinkSize objectAtIndex:row] floatValue];
    _currSize = [NSNumber numberWithFloat:size];
    
    _currDrinkType = [drinkType objectAtIndex:row];
    
    NSString *file = (NSString *)[drinkImage objectAtIndex:row];
    
    UIImage *image = [UIImage imageNamed:file];
    [dImage setImage:image];
    
    //bacLabel.text = myString;
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)touchupinside:(id)sender
{
    if(addDrink.touchInside == true)
    {
        NSString *message = @"Would you like to add the drink: ";
        message = [message stringByAppendingString:_currDrinkType];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Drink" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    if (_throwUp.touchInside == true) {
        [self.myEquation throwUp];
        NSString *select = @"Thrown Up";
        _selectDrink.text = [NSString stringWithString: select];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.myEquation addBAC:_currAlc :_currSize];
        NSString *select = @"Drink Successfully Added";
        _selectDrink.text = [NSString stringWithString: select];
    }
}

- (void)confitureButtons {
    addDrink.layer.cornerRadius = 5; // this value vary as per your desire
    addDrink.clipsToBounds = YES;
    addDrink.layer.borderWidth = 1.0f;
    addDrink.layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = addDrink.layer.bounds;
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
    [addDrink.layer addSublayer:shineLayer];
    
    _throwUp.layer.cornerRadius = 5; // this value vary as per your desire
    _throwUp.clipsToBounds = YES;
    _throwUp.layer.borderWidth = 1.0f;
    _throwUp.layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    shineLayer = [CAGradientLayer layer];
    shineLayer.frame = _throwUp.layer.bounds;
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
    [_throwUp.layer addSublayer:shineLayer];

}
@end
