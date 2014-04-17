//
//  FirstViewController.m
//  BAC Calc
//
//  Created by  on 11/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "BACCalc.h"
#import "BACCalcController.h"
#import "Equation.h"
#import "AppDelegate.h"
#import "QuartzCore/QuartzCore.h"
@interface FirstViewController ()

@end

@implementation FirstViewController 
@synthesize bacLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background3.png"]];
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.myEquation = appDelegate.equation;
    _bacLog = [[NSMutableArray alloc] init];
    _graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [self confitureButtons];
}

- (void)viewDidUnload
{
    [self setStopDrinking:nil];
    [self setCallTaxi:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.myEquation = appDelegate.equation;
    _currBAC = 0;
    
    if(_myEquation.needAlarm) {
        NSString *stopDrinking = @"STOP DRINKING";
        _stopDrinking.text = [NSString stringWithString: stopDrinking];
    }
    else {
        NSString *stopDrinking = @" ";
        _stopDrinking.text = [NSString stringWithString: stopDrinking];
    }
    
    [self.repeatingTimer invalidate];
    self.repeatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
}

-(void)runTimer{
    [self.myEquation decrementSlopesExperation];
    //[self.myEquation checkSlopesExperation];
    self.myEquation.time++;
    self.currBAC = [self.myEquation getCurrBAC];
    NSNumber *currBac = [NSNumber numberWithFloat:[_currBAC floatValue]];
    if ([currBac floatValue] > 0)
        [_bacLog addObject:currBac];
    if ([currBac floatValue] > [_maxBAC floatValue]) {
        _maxBAC = currBac;
    }
    
    //NSLog(@"%u", [_bacLog count]);
    
    self.bacLabel.text = [NSString stringWithFormat:@"%.3f", [self.currBAC floatValue]];
    if ([_currBAC floatValue] <= 0) {
        NSString *stopDrinking = @" ";
        _stopDrinking.text = [NSString stringWithString: stopDrinking];
    }
    if (self.myEquation.time%30 == 0) {
        [self initPlot:_maxBAC];
    }
}

- (IBAction)callTaxi:(id)sender {
    if (_callTaxi.touchInside == true) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code" message:@"Enter your current zip code location:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [[alertView textFieldAtIndex:0] becomeFirstResponder];
        [alertView show];
    }
}

- (void)confitureButtons {
    _callTaxi.layer.cornerRadius = 5; // this value vary as per your desire
    _callTaxi.clipsToBounds = YES;
    _callTaxi.layer.borderWidth = 1.0f;
    _callTaxi.layer.borderColor = [UIColor colorWithWhite:0.4f alpha:0.2f].CGColor;
    
    CAGradientLayer *shineLayer = [CAGradientLayer layer];
    shineLayer.frame = _callTaxi.layer.bounds;
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
    [_callTaxi.layer addSublayer:shineLayer];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UITextField *zipCodeField = [alertView textFieldAtIndex:0];
        NSString *zip = (NSString *)[zipCodeField text];
        [self findTaxiNum:zip];
    }
}

- (void)findTaxiNum:(NSString *)zip {
    //ATTENTION>>>> The only thing that should ever change is the zip NSString directly before... do not
    //              mess with anything else or we will have problems!
    
    /*-------------------Set up POST SQL values---------------------------------------------------------*/
    //NSString *zip = @"78701";
    NSString *distSubmit = @"&dist=15&submit=Submit";
    
    NSString *parameters = [[NSString alloc] initWithFormat:@""];
    parameters = [parameters stringByAppendingString:@"zip="];
    parameters = [parameters stringByAppendingString:zip];
    parameters = [parameters stringByAppendingString:distSubmit];
    
    /*-------------------SET UP HTTP POST REQUEST WITH zip, dist, submit VARIABLES----------------------*/
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setURL:[NSURL URLWithString:@"http://1800taxicab.com/taxiresults.php"]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", @"http://1800taxicab.com/taxiresults.php", [responseCode statusCode]);
    }
    
    /*-------------------Obtain resulting XML and isolate static HTML URL-------------------------------*/
    NSString *results = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSString *search = @"<p><center>";
    if ([results rangeOfString:search options:NSCaseInsensitiveSearch].location == NSNotFound)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Zip Code" message:@"Not a valid zip code, please reenter:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [[alertView textFieldAtIndex:0] becomeFirstResponder];
        [alertView show];
        return;
    }
    NSString *lastParsed = [results substringFromIndex:NSMaxRange([results rangeOfString:search])];
    NSRange rangeOfLineParsed = [lastParsed rangeOfString:@"</td></tr></table></center>"];
    
    NSString *lineParsed = [lastParsed substringToIndex:rangeOfLineParsed.location];
    
    NSRange rangeOfResultCount = [lineParsed rangeOfString:@"/static/"];
    
    NSString *lineParsedBack = [lineParsed substringFromIndex:rangeOfResultCount.location];
    
    NSArray *components=[lineParsedBack componentsSeparatedByString:@"\"><font"];
    
    NSString *staticURL = @"http://www.1800taxicab.com";
    NSString *staticURLBack = [components objectAtIndex:0];
    
    staticURL = [staticURL stringByAppendingString:staticURLBack];
    
    NSURL *ultimateURL = [NSURL URLWithString:[staticURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];;
    /*-------------------Set up HTML request with static URL previously obtained-------------------------*/
    NSStringEncoding encoding;
    NSError *error2 = nil;
    NSString *webSource = [NSString stringWithContentsOfURL:ultimateURL
                                               usedEncoding:&encoding
                                                      error:&error2];
    /*-------------------Obtain resulting XML and isolate phone number-----------------------------------*/
    NSString *searchAgain = @"class=\"style70\">TAXI SERVICES";
    NSString *lineAgain = [webSource substringFromIndex:NSMaxRange([webSource rangeOfString:searchAgain])];
    
    //NSLog(lineAgain);
    
    NSString *searchAgainAgain = @"<STRONG>PHONE:</STRONG>";
    NSString *lastLineAgain = [lineAgain substringFromIndex:NSMaxRange([lineAgain rangeOfString:searchAgainAgain])];
    
    NSArray *components2=[lastLineAgain componentsSeparatedByString:@"</span></P>"];
    NSString *phoneNumber = [components2 objectAtIndex:0];
    NSMutableString *formattedPhoneNumber = [NSMutableString stringWithCapacity:phoneNumber.length];
    
    //Format phone number by removing everything except the numbers:
    NSScanner *scanner = [NSScanner scannerWithString:phoneNumber];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [formattedPhoneNumber appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    NSString *phone = [@"telprompt://" stringByAppendingString:formattedPhoneNumber];
    NSLog(phone);
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void)initPlot:(NSNumber *)currBac {
    [self configureHost];
    [self configureGraph];
    [self configurePlots:currBac];
    [self configureAxes:currBac];
}

-(void)configureHost {
	self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:CGRectMake(5, 40, 310, 215)];
	self.hostView.allowPinchScaling = NO;
	[self.view addSubview:self.hostView];
}

-(void)configureGraph {
	// 1 - Create the graph
	CPTGraph *graph = _graph;
	[graph applyTheme:[CPTTheme themeNamed:kCPTStocksTheme]];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
	self.hostView.hostedGraph = graph;
	// 2 - Set graph title
	/*NSString *title = @"MY BAC MOTHA FUCKA";
	graph.title = title;*/
	// 3 - Create and set text style
	/*CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
	titleStyle.color = [CPTColor whiteColor];
	titleStyle.fontName = @"Helvetica-Bold";
	titleStyle.fontSize = 16.0f;
	graph.titleTextStyle = titleStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;*/
	graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
	// 4 - Set padding for plot area
	[graph.plotAreaFrame setPaddingLeft:40.0f];
	[graph.plotAreaFrame setPaddingBottom:30.0f];
    graph.paddingLeft = 0.0;
    graph.paddingTop = 0.0;
    graph.paddingRight = 0.0;
    graph.paddingBottom = 0.0;
	// 5 - Enable user interactions for plot space
	//CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	//plotSpace.allowsUserInteraction = NO;
    // 6 - Set boarder for plot area frame
    CPTMutableLineStyle *borderLineStyle = [CPTMutableLineStyle lineStyle];
    borderLineStyle.lineColor = [CPTColor whiteColor];
    borderLineStyle.lineWidth = 2.0;
    
    graph.plotAreaFrame.borderLineStyle = borderLineStyle;
    //graph.plotAreaFrame.borderLineStyle = nil;
    
}

-(void)configurePlots:(NSNumber *)currBac {
	// 1 - Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	// 2 - Create the three plots
	CPTScatterPlot *bac = [[CPTScatterPlot alloc] init];
	bac.dataSource = self;
	//bac.identifier = CPDTickerSymbolAAPL;
	CPTColor *bacColor = [CPTColor orangeColor];
	[graph addPlot:bac toPlotSpace:plotSpace];
    // 3 - Set up plot space
	[plotSpace scaleToFitPlots:[NSArray arrayWithObjects:bac, nil]];
    CPTPlotRange *xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                        length:CPTDecimalFromFloat([_bacLog count])];
	plotSpace.xRange = xRange;
    CGFloat yMax;
    if ([currBac floatValue] < 0.08) {
        yMax = 0.098f;
    }
    else if ([currBac floatValue] < 0.1) {
        yMax = 0.15f;
    }
    else if ([currBac floatValue] < 0.15) {
        yMax = 0.2f;
    }
    else if ([currBac floatValue] < 0.2) {
        yMax = 0.25f;
    }
    else if ([currBac floatValue] < 0.3) {
        yMax = 0.35f;
    }
    else {
        yMax = 0.5f;
    }
    CPTPlotRange *yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                        length:CPTDecimalFromFloat(yMax)];
	plotSpace.yRange = yRange;
	// 4 - Create styles and symbols
	CPTMutableLineStyle *bacLineStyle = [bac.dataLineStyle mutableCopy];
	bacLineStyle.lineWidth = 2.0;
	bacLineStyle.lineColor = bacColor;
	bac.dataLineStyle = bacLineStyle;
	CPTMutableLineStyle *bacSymbolLineStyle = [CPTMutableLineStyle lineStyle];
	bacSymbolLineStyle.lineColor = bacColor;
	/*CPTPlotSymbol *bacSymbol = [CPTPlotSymbol ellipsePlotSymbol];
	bacSymbol.fill = [CPTFill fillWithColor:bacColor];
	bacSymbol.lineStyle = bacSymbolLineStyle;
	bacSymbol.size = CGSizeMake(1.0f, 1.0f);
	bac.plotSymbol = bacSymbol;*/
}

-(void)configureAxes:(NSNumber *)currBac {
	// 1 - Create styles
	CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
	axisTitleStyle.color = [CPTColor whiteColor];
	axisTitleStyle.fontName = @"Helvetica-Bold";
	axisTitleStyle.fontSize = 12.0f;
	CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
	axisLineStyle.lineWidth = 2.0f;
	axisLineStyle.lineColor = [CPTColor whiteColor];
	CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
	axisTextStyle.color = [CPTColor whiteColor];
	axisTextStyle.fontName = @"Helvetica-Bold";
	axisTextStyle.fontSize = 11.0f;
	CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor whiteColor];
	tickLineStyle.lineWidth = 1.0f;
	CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
	tickLineStyle.lineColor = [CPTColor blackColor];
	tickLineStyle.lineWidth = 3.0f;
	// 2 - Get axis set
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
	// 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    NSNumber *interval;
    if ([_bacLog count] == 0) {
        x.title = @"";
    }
    else if ([_bacLog count] <= 3600) {
        x.title = @"Time in Minutes";
        interval = [NSNumber numberWithFloat:60.0];
    }
    else {
        x.title = @"Time in Hours";
        interval = [NSNumber numberWithFloat:3600.0];
    }
    NSInteger majorIncrement;
    if ([_bacLog count] <= 600) {
        majorIncrement = 60;
    }
    else if ([_bacLog count] <= 1800) {
        majorIncrement = 300;
    }
    else if ([_bacLog count] <= 3600) {
        majorIncrement = 900;
    }
    else if ([_bacLog count] <= 18000) {
        majorIncrement = 1800;
    }
    else {
        majorIncrement = 3600;
    }
    x.titleOffset = 15;
    x.titleTextStyle = axisTitleStyle;
	x.axisLineStyle = axisLineStyle;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	x.labelTextStyle = axisTextStyle;
	x.majorTickLineStyle = axisLineStyle;
	x.majorTickLength = 4.0f;
	x.tickDirection = CPTSignNegative;
    
    CGFloat xMax = [_bacLog count];
    NSMutableSet *xLabels = [NSMutableSet set];
	NSMutableSet *xMajorLocations = [NSMutableSet set];
    
    for (NSNumber *j = [NSNumber numberWithFloat:(majorIncrement)];
         [j floatValue] <= xMax;
         j = [NSNumber numberWithFloat:[j floatValue] + majorIncrement] ) {
		NSNumber *timeValue = [NSNumber numberWithFloat:([j floatValue]/[interval floatValue])];
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@", timeValue]
                                                       textStyle:x.labelTextStyle];
        NSDecimal location = CPTDecimalFromFloat([j floatValue]);
        label.tickLocation = location;
        label.offset = 4.0f;
        if (label) {
            [xLabels addObject:label];
        }
        [xMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
    }
    
	x.axisLabels = xLabels;
	x.majorTickLocations = xMajorLocations;
	// 4 - Configure y-axis
	CPTAxis *y = axisSet.yAxis;
	y.title = @"BAC";
	y.titleTextStyle = axisTitleStyle;
	y.titleOffset = -40.0f;
	y.axisLineStyle = axisLineStyle;
	y.majorGridLineStyle = gridLineStyle;
	y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.labelTextStyle = axisTextStyle;
	y.labelOffset = 20.0f;
	y.majorTickLineStyle = axisLineStyle;
	y.majorTickLength = 4.0f;
	y.minorTickLength = 2.0f;
	y.tickDirection = CPTSignPositive;
    CGFloat yMax;
    NSNumber *majorIncrementy;
    if ([currBac floatValue] < 0.08) {
        yMax = 0.1f;
        majorIncrementy = [NSNumber numberWithFloat:0.02];
    }
    else if ([currBac floatValue] < 0.1) {
        yMax = 0.2f;
        majorIncrementy = [NSNumber numberWithFloat:0.05];
    }
    else if ([currBac floatValue] < 0.2) {
        yMax = 0.25f;
        majorIncrementy = [NSNumber numberWithFloat:0.05];
    }
    else if ([currBac floatValue] < 0.3) {
        yMax = 0.35f;
        majorIncrementy = [NSNumber numberWithFloat:0.1];
    }
    else {
        yMax = 0.5f;
        majorIncrementy = [NSNumber numberWithFloat:0.1];
    }
    
	NSMutableSet *yLabels = [NSMutableSet set];
	NSMutableSet *yMajorLocations = [NSMutableSet set];
	NSMutableSet *yMinorLocations = [NSMutableSet set];
	for (NSNumber *j = [NSNumber numberWithFloat:[majorIncrementy floatValue]];
         [j floatValue] <= yMax;
        j = [NSNumber numberWithFloat:[j floatValue] + [majorIncrementy floatValue]]) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%@", j]
                                                           textStyle:y.labelTextStyle];
        NSDecimal location = CPTDecimalFromFloat([j floatValue]);
        label.tickLocation = location;
        label.offset = -y.majorTickLength - y.labelOffset;
        if (label) {
            [yLabels addObject:label];
        }
        [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
	}
	y.axisLabels = yLabels;
	y.majorTickLocations = yMajorLocations;
	y.minorTickLocations = yMinorLocations;
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
	return [_bacLog count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	NSInteger valueCount = [_bacLog count];
	switch (fieldEnum) {
		case CPTScatterPlotFieldX:
			if (index < valueCount) {
				return [NSNumber numberWithUnsignedInteger:index];
			}
			break;
			
		case CPTScatterPlotFieldY:
				return [_bacLog objectAtIndex:index];
	}
	return [NSDecimalNumber zero];
}

@end