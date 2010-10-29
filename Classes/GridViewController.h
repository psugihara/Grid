//
//  gridViewController.h
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
//	Only one Grid exists at a time but the 3 Preset settings are always kept in memory as well as the currentFrame.
 
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Grid.h"
#import "GridView.h"
#import "Preset.h"
#import "DJMixer.h"
#import "EditPresetViewController.h"



@interface GridViewController : UIViewController <EditPresetDelegate> {
	DJMixer *djMixer;
	
	NSTimer			*timer;
	NSOperationQueue	*operationQueue;
	NSRunLoop			*runLoop;
	
	int		secondsToShowLoadingScreen;
	BOOL	presetIsNotLoaded;
	
	int		currentWindowNumber;
	Preset	*gridPresetForWindowI;
	Preset	*gridPresetForWindowII;
	Preset	*gridPresetForWindowIII;

	Grid	*grid;
	
	IBOutlet GridView	*gridView;
	IBOutlet UIButton	*presetButtonI;
	IBOutlet UIButton	*presetButtonII;
	IBOutlet UIButton	*presetButtonIII;
}


@property (nonatomic, retain) DJMixer		*djMixer;
@property (nonatomic, retain) Preset		*gridPresetForWindowI;
@property (nonatomic, retain) Preset		*gridPresetForWindowII;
@property (nonatomic, retain) Preset		*gridPresetForWindowIII;
@property (nonatomic, retain) Grid			*grid;
@property (nonatomic, retain) IBOutlet	GridView *gridView;

- (void)showLoadingImages;
- (void)didFinishShowingLoadingImages;
- (void)beginCreatingGrid;
- (void)synchronousCreateGrid;
- (void)didFinishCreatingGrid;
- (void)resetSettingsToDefaultPresetForWindowNumber:(int)number;
- (IBAction)presetButton:(UIButton *)sender;
- (IBAction)editPresetButton:(UIButton *)sender;
- (void)loadNewFrame;
- (Preset *)getPresetForWindowNumber:(int)presetNumber;
- (void)savePresets;
- (void)loadSavedPresets;
- (Preset*)loadPresetWithKey:(NSString*)key;


@end

