//
//  EditPresetViewController.m
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

#import "EditPresetViewController.h"


@implementation EditPresetViewController

@synthesize doneButton, bladedButton, angledButton, bubbledButton, bubbledButton2;
@synthesize preset, presetModalView, frameNameLabel, topToneTextField, topToneTextField2, bottomToneTextField, delegate;

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBarHidden=YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupButtons];
	self.frameNameLabel.text = preset.name;
	[self setupToneTextField:self.topToneTextField];
	[self setupToneTextField:self.topToneTextField2];
	[self setupToneTextField:self.bottomToneTextField];
	self.topToneTextField.text = [NSString localizedStringWithFormat: @"%f",self.preset.fundamentalFrequency0];
	self.topToneTextField2.text = [NSString localizedStringWithFormat: @"%f",self.preset.fundamentalFrequency00];
	self.bottomToneTextField.text = [NSString localizedStringWithFormat: @"%f",self.preset.fundamentalFrequency1];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction)done {
	[delegate editPresetViewController:self didFinishEditingPreset:self.preset];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	preset.fundamentalFrequency0 = [topToneTextField.text floatValue];
	preset.fundamentalFrequency00 = [topToneTextField2.text floatValue];
	preset.fundamentalFrequency1 = [bottomToneTextField.text floatValue];
	[delegate editPresetViewController:self didEditPreset:self.preset];
	return YES;
}

#pragma mark -
#pragma mark Text Fields

- (void)setupToneTextField:(UITextField *)textFieldNormal {
		
	textFieldNormal.adjustsFontSizeToFitWidth = YES;
	textFieldNormal.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textFieldNormal.keyboardType = UIKeyboardTypeNumbersAndPunctuation;	// use the default type input method (entire keyboard)
	textFieldNormal.returnKeyType = UIReturnKeyGo;
	
	textFieldNormal.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	textFieldNormal.clearsOnBeginEditing = NO;

	textFieldNormal.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	// Add an accessibility label that describes what the text field is for.
	[textFieldNormal setAccessibilityLabel:NSLocalizedString(@"Tone", @"")];
}

#pragma mark -
#pragma mark Buttons

- (void)setupButtons {
	bladedButton.selected = preset.bladed;
	angledButton.selected = preset.angled;
	bubbledButton.selected = preset.bubbled;
	bubbledButton2.selected = preset.doubleBubbled;
}

- (void)onOffButtonToggle:(UIButton *)sender {
	if (sender.selected == YES) sender.selected = NO;
	else sender.selected = YES;
}

- (IBAction)bladedButtonPressed: (UIButton *) sender {
	NSLog(@"press");
	[self onOffButtonToggle:sender];
	if (sender.selected == YES) preset.bladed = YES;
	else preset.bladed = NO;
	[delegate editPresetViewController:self didEditPreset:self.preset];
}

- (IBAction)angledButtonPressed: (UIButton *) sender {
	[self onOffButtonToggle:sender];
	if (sender.selected == YES) preset.angled = YES;
	else preset.angled = NO;
	[delegate editPresetViewController:self didEditPreset:self.preset];
}

- (IBAction)bubbledButtonPressed: (UIButton *) sender {
	[self onOffButtonToggle:sender];
	if (sender.selected == YES) preset.bubbled = YES;
	else preset.bubbled = NO;
	[delegate editPresetViewController:self didEditPreset:self.preset];
}

- (IBAction)doubleBubbledButtonPressed: (UIButton *) sender {
	[self onOffButtonToggle:sender];
	if (sender.selected == YES) preset.doubleBubbled = YES;
	else preset.doubleBubbled = NO;
	[delegate editPresetViewController:self didEditPreset:self.preset];
}

@end
