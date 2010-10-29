//
//  Preset.h
//  Grid
//
//  Created by Peter Sugihara on 9/9/09.
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
//	This class contains the information for a Preset object and can be instantiated with
//	presets defined here.


#import <Foundation/Foundation.h>


@interface Preset : NSObject <NSCoding> {
	NSString	*name;
	UIColor	*lineColor;
	UIColor	*backgroundColor;
	int			size;
	int			bloomSpeed;
	int			wiltSpeed;
	CGPoint	gravitron;
	
	//Audio
	float		fundamentalFrequency0;
	float		fundamentalFrequency00; //The second channel 0 frequency;
	float		fundamentalFrequency1;
	BOOL		bladed;
	BOOL		angled;
	BOOL		bubbled;
	BOOL		doubleBubbled;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) int size;
@property (nonatomic, assign) int bloomSpeed;
@property (nonatomic, assign) int wiltSpeed;
@property (nonatomic, assign) CGPoint gravitron;
@property (nonatomic) float fundamentalFrequency0;
@property (nonatomic) float fundamentalFrequency00;
@property (nonatomic) float fundamentalFrequency1;
@property (nonatomic) BOOL bladed;
@property (nonatomic) BOOL angled;
@property (nonatomic) BOOL bubbled;
@property (nonatomic) BOOL doubleBubbled;

- (id) initWithName:(NSString*)aName;
- (void) setToDefaultNumber: (int) number;

@end
