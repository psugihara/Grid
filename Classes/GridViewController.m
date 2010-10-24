//
//  gridViewController.m
//  Grid
//
//  Created by Peter Sugihara on 6/4/09.
//	Copyright (c) 2009 Peter Sugihara
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE
//

#import "GridViewController.h"


@implementation GridViewController

@synthesize djMixer, gridPresetForWindowI, gridPresetForWindowII, gridPresetForWindowIII, grid, gravitron, gridView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:3];
	}
    return self;
}

// Overridden in order to save the currentWindowNumber
- (void)setCurrentWindowNumber:(int)number {
	if (currentWindowNumber == number) return;
	currentWindowNumber = number;
	[[NSUserDefaults standardUserDefaults] setInteger:currentWindowNumber forKey:@"currentWindowNumber"];
}
	  
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationController.navigationBarHidden=YES;

}

// Called by default.  Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	//start the audio
	djMixer = [[DJMixer alloc]init];
	
	secondsToShowLoadingScreen = 1.4;
	
	[self beginCreatingGrid];
	[self showLoadingImages];
	[grid reset];
	[super viewDidLoad];
}


- (void)showLoadingImages {
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	NSMutableArray *loadingImages = [[NSMutableArray alloc] init];

	//Populate the array
	NSString *name;
	UIImage *loadingImage;
	for (int i=0; i<10; i++) {
		name = [NSString stringWithFormat:@"gridderLoadScreen%i.png", i];
		loadingImage = [UIImage imageNamed:name];
		[loadingImages addObject:loadingImage];
	}

	
	imageView.animationImages = loadingImages;
	imageView.animationRepeatCount = 1;
	imageView.animationDuration = secondsToShowLoadingScreen/imageView.animationRepeatCount;
	[imageView startAnimating];
	[self.view addSubview:imageView];
	[imageView release];
	[loadingImages release];
	[self didFinishShowingLoadingImages];
}

- (void)didFinishShowingLoadingImages {
}

- (void)beginCreatingGrid {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(synchronousCreateGrid) object:nil];
    [operationQueue addOperation:operation];
    [operation release];
}

- (void)synchronousCreateGrid {
	
	presetButtonI.tag = 1;
	presetButtonII.tag = 2;
	presetButtonIII.tag = 3;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	currentWindowNumber = [prefs integerForKey:@"currentWindowNumber"];
	if (![prefs boolForKey:@"hasPrefs"]) { //This will occur the first time the app is used.
		[self resetSettingsToDefaultPresetForWindowNumber:1];
		[self resetSettingsToDefaultPresetForWindowNumber:2];
		[self resetSettingsToDefaultPresetForWindowNumber:3];
		currentWindowNumber = 1;
		[self savePresets];
		[prefs setBool:YES forKey:@"hasPrefs"];
	}
	else {
		[self loadSavedPresets];
	}
								 
	

	//Load the gravitron and grid
	gravitron = CGPointMake(550,550);  //Will render offscreen
	grid = [[Grid alloc] initWithGravitron:self.gravitron andPreset:[self getPresetForWindowNumber:currentWindowNumber]];
	gridView.grid = grid;

	[NSThread sleepForTimeInterval:secondsToShowLoadingScreen];
	[grid reset];
    [self performSelectorOnMainThread:@selector(didFinishCreatingGrid) withObject:nil waitUntilDone:NO];
}

- (void)didFinishCreatingGrid {
	timer = [NSTimer timerWithTimeInterval:(.2) target:self selector:@selector(loadNewFrame) userInfo:nil repeats:YES];
	runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
}

//This is the animation/data update triggered by the timer.
- (void)loadNewFrame {
	if (presetIsNotLoaded) {

	}
	else {
		[self.grid updatePositionOfPoints];
		[gridView setNeedsDisplay];
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.gridView = nil;
}

- (void)dealloc {
	[djMixer release];
	[gridPresetForWindowI release];
	[gridPresetForWindowII release];
	[gridPresetForWindowIII release];
	[presetButtonI release];
	[presetButtonII release];
	[presetButtonIII release];
	[grid release];
	[gridView release];
	[timer release];
	[operationQueue release];
	[runLoop release];
    [super dealloc];
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch= [touches anyObject];
	grid.gravitron = [touch locationInView:self.gridView];
	CGRect rect = [[UIScreen mainScreen] bounds];
	[djMixer changeCrossFaderAmount:(1-(grid.gravitron.y-10)/rect.size.height)];
	djMixer.octaveShift = (int)4*(grid.gravitron.x)/rect.size.width;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch= [touches anyObject];
	grid.gravitron = [touch locationInView:self.gridView];
	CGRect rect = [[UIScreen mainScreen] bounds];
	[djMixer changeCrossFaderAmount:(1-(grid.gravitron.y-10)/rect.size.height)];
	djMixer.octaveShift = (int)4*(grid.gravitron.x)/rect.size.width;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark -
#pragma mark Buttons

- (IBAction)presetButton:(UIButton *)sender {
	if (currentWindowNumber != sender.tag) {
		self.currentWindowNumber = sender.tag;
		grid = [grid initWithGravitron:gridView.grid.gravitron andPreset:[self getPresetForWindowNumber:currentWindowNumber]];

		gridView.grid = grid;
		djMixer.fundamentalFrequency0 = [self getPresetForWindowNumber:currentWindowNumber].fundamentalFrequency0;
		djMixer.fundamentalFrequency00 = [self getPresetForWindowNumber:currentWindowNumber].fundamentalFrequency0;
		djMixer.fundamentalFrequency1 = [self getPresetForWindowNumber:currentWindowNumber].fundamentalFrequency1;
		djMixer.bladed = [self getPresetForWindowNumber:currentWindowNumber].bladed;
		djMixer.angled = [self getPresetForWindowNumber:currentWindowNumber].angled;
		djMixer.bubbled = [self getPresetForWindowNumber:currentWindowNumber].bubbled;
		djMixer.doubleBubbled = [self getPresetForWindowNumber:currentWindowNumber].doubleBubbled;
	}
	[grid reset];
}

- (IBAction)editPresetButton:(UIButton *)sender {

    EditPresetViewController *editController = [[EditPresetViewController alloc] initWithNibName:@"EditPresetView" bundle:nil];
    editController.delegate = self;
	
	editController.preset = [self getPresetForWindowNumber:currentWindowNumber];
	
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editController];
    [self presentModalViewController:navigationController animated:YES];
    
    [navigationController release];
    [editController release];
}

#pragma mark -
#pragma mark Change Presets

- (void)editPresetViewController:(EditPresetViewController *)editPresetViewController didEditPreset:(Preset *)preset {
	//Essentially "loadPreset" for djMixer
	djMixer.fundamentalFrequency0 = preset.fundamentalFrequency0;
	djMixer.fundamentalFrequency00 = preset.fundamentalFrequency00;
	djMixer.fundamentalFrequency1 = preset.fundamentalFrequency1;
	djMixer.bladed = preset.bladed;
	djMixer.angled = preset.angled;
	djMixer.bubbled = preset.bubbled;
	djMixer.doubleBubbled = preset.doubleBubbled;
	[self savePresets];
}

- (void)editPresetViewController:(EditPresetViewController *)editPresetViewController didFinishEditingPreset:(Preset *)preset {
	[self.grid loadPreset:preset];
//	[self editPresetViewController:editPresetViewController didFinishEditingPreset:preset];
	[editPresetViewController dismissModalViewControllerAnimated:YES];
}

- (Preset *)getPresetForWindowNumber:(int)presetNumber {
	Preset *preset = [[[Preset alloc] init] autorelease];
	if (presetNumber == 1) {
		preset = self.gridPresetForWindowI;
	}
	else if (presetNumber == 2) {
		preset = self.gridPresetForWindowII;
	}
	else if (presetNumber == 3) {
		preset = self.gridPresetForWindowIII;
	}
	return [preset retain];
}


- (void)resetSettingsToDefaultPresetForWindowNumber:(int)number {
	Preset *preset = [[[Preset alloc] init] autorelease];
	[preset setToDefaultNumber:number];
	if (number == 1) {
		self.gridPresetForWindowI = preset;
	}
	else if (number == 2) {
		self.gridPresetForWindowII = preset;
	}
	else if (number == 3) {
		self.gridPresetForWindowIII = preset;
	}
	[preset retain];
}

#pragma mark -
#pragma mark Load/Save State

- (void)savePresets {
	NSData *presetData;
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	presetData = [NSKeyedArchiver archivedDataWithRootObject:gridPresetForWindowI];
	[prefs setObject:presetData forKey:@"gridPresetForWindowI"];
	presetData = [NSKeyedArchiver archivedDataWithRootObject:gridPresetForWindowII];
	[prefs setObject:presetData forKey:@"gridPresetForWindowII"];
	presetData = [NSKeyedArchiver archivedDataWithRootObject:gridPresetForWindowIII];
	[prefs setObject:presetData forKey:@"gridPresetForWindowIII"];
	
	[prefs synchronize];
}

- (void)loadSavedPresets {
	self.gridPresetForWindowI = [self loadPresetWithKey:@"gridPresetForWindowI"];
	self.gridPresetForWindowII = [self loadPresetWithKey:@"gridPresetForWindowII"];
	self.gridPresetForWindowIII = [self loadPresetWithKey:@"gridPresetForWindowIII"];
}

- (Preset*)loadPresetWithKey:(NSString*)key {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:key];
    Preset* obj = (Preset*)[NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    return obj;
}

@end
