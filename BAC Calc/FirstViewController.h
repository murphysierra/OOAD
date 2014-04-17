//
//  FirstViewController.h
//  BAC Calc
//
//  Created by  on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
@class BACCalcController;
@class Equation;

@interface FirstViewController : UIViewController <CPTPlotDataSource>
@property (strong, nonatomic) BACCalcController *dataController;
@property (nonatomic, retain) IBOutlet UILabel *bacLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBac;
@property (weak) NSTimer *repeatingTimer;
@property (nonatomic, retain) NSNumber *currBAC;
@property (nonatomic, retain) NSNumber *maxBAC;
@property (nonatomic, retain) Equation *myEquation;
@property (weak, nonatomic) IBOutlet UILabel *stopDrinking;
@property (nonatomic, copy) NSMutableArray *bacLog;
@property (weak, nonatomic) IBOutlet UIButton *callTaxi;
@property (nonatomic, copy) CPTGraph *graph;

@property (nonatomic, strong) CPTGraphHostingView *hostView;

- (void)startMyRepeatingTimer;
- (IBAction)callTaxi:(id)sender;

- (void)updateMyBac:(NSTimer*)theTimer;

@end