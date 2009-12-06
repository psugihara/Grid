//
//  EditPresetViewController.h
//  Grid
//
//  Created by Peter Sugihara on 11/1/09.
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

#import <UIKit/UIKit.h>
#import "Preset.h"

@protocol EditPresetDelegate;

@interface EditPresetViewController : UIViewController <UITextFieldDelegate> {
	Preset						*preset;
	int							currentField;
	IBOutlet UIView				*presetModalView;
	
	IBOutlet UIButton			*doneButton;
	IBOutlet UIButton			*bladedButton;
	IBOutlet UIButton			*angledButton;
	IBOutlet UIButton			*bubbledButton;
	IBOutlet UIButton			*bubbledButton2;
	
	IBOutlet UILabel			*frameNameLabel;
	IBOutlet UITextField		*topToneTextField;
	IBOutlet UITextField		*topToneTextField2;
	IBOutlet UITextField		*bottomToneTextField;
	id <EditPresetDelegate>		delegate;
}

@property (nonatomic, retain) Preset				*preset;
@property (nonatomic, retain) IBOutlet UIView		*presetModalView;
@property (nonatomic, retain) IBOutlet UIButton		*doneButton;
@property (nonatomic, retain) IBOutlet UIButton		*bladedButton;
@property (nonatomic, retain) IBOutlet UIButton		*angledButton;
@property (nonatomic, retain) IBOutlet UIButton		*bubbledButton;
@property (nonatomic, retain) IBOutlet UIButton		*bubbledButton2;
@property (nonatomic, retain) IBOutlet UILabel		*frameNameLabel;
@property (nonatomic, retain) IBOutlet UITextField	*topToneTextField;
@property (nonatomic, retain) IBOutlet UITextField	*topToneTextField2;
@property (nonatomic, retain) IBOutlet UITextField	*bottomToneTextField;
@property (nonatomic, assign) id <EditPresetDelegate> delegate;


- (IBAction)done;
- (IBAction)bladedButtonPressed: (UIButton *)sender;
- (IBAction)angledButtonPressed: (UIButton *)sender;
- (IBAction)bubbledButtonPressed: (UIButton *)sender;
- (IBAction)doubleBubbledButtonPressed: (UIButton *)sender;
- (void)setupButtons;
- (void)setupToneTextField:(UITextField *)textFieldNormal;
- (void)onOffButtonToggle:(UIButton *)sender;


@end

@protocol EditPresetDelegate <NSObject>

- (void)editPresetViewController:(EditPresetViewController *)editPresetViewController didEditPreset:(Preset *)preset;
- (void)editPresetViewController:(EditPresetViewController *)editPresetViewController didFinishEditingPreset:(Preset *)preset;

@end