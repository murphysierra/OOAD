//
//  SecondViewController.h
//  BAC Calc
//
//  Created by  on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BACCalcController;
@class Equation;

@interface SecondViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView       *picker;
    NSArray            *drinkType;
    NSArray            *drinkCategory;
}
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) BACCalcController *dataController;
@property (nonatomic, retain) NSArray *drinkType;
@property (nonatomic, retain) NSArray *drinkAlc;
@property (nonatomic, retain) NSArray *drinkSize;
@property (nonatomic, retain) NSArray *drinkImage;
@property (weak, nonatomic) IBOutlet UIImageView *dImage;
@property (nonatomic, retain) IBOutlet UILabel *bacLabel;
@property (nonatomic, retain) IBOutlet UIButton *addDrink;
@property (weak, nonatomic) IBOutlet UIButton *throwUp;
@property (weak, nonatomic) IBOutlet UILabel *selectDrink;
@property (nonatomic, retain) Equation *myEquation;
@property (nonatomic, retain) NSNumber *currAlc;
@property (nonatomic, retain) NSNumber *currSize;
@property (nonatomic, retain) NSString *currDrinkType;
-(IBAction)textFieldReturn:(id)sender;
-(IBAction)touchupinside:(id)sender;

@end  

