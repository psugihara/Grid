//
//  Preset.m
//  Gridder
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

#import "Preset.h"


@implementation Preset

@synthesize name;
@synthesize size;
@synthesize lineColor;
@synthesize backgroundColor;
@synthesize bloomSpeed;
@synthesize wiltSpeed;
@synthesize fundamentalFrequency0;
@synthesize fundamentalFrequency00;
@synthesize fundamentalFrequency1;
@synthesize bladed, angled, bubbled, doubleBubbled;

- (id) init {
	self = [super init];
	if (self) {
		self.size = 2;
		self.bloomSpeed = 2;
		self.wiltSpeed = 2;
		self.lineColor = [UIColor blackColor];
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (id) initWithName:(NSString*)aName {
	self = [super init];
	if (self) {
		name = aName;
		size = 2; //this is just a default
		self.bloomSpeed = 4;
		self.wiltSpeed = 4;
		if (name == @"graphPaper") {
			lineColor = [UIColor colorWithRed:0 green:0 blue:.78 alpha:1];
			backgroundColor = [UIColor colorWithRed:.73 green:1 blue:.78 alpha:1];
		}
		else if (name == @"clusters") {
			lineColor = [UIColor colorWithRed:0 green:0 blue:.78 alpha:1];
			backgroundColor = [UIColor colorWithRed:.73 green:1 blue:.78 alpha:1];
		}
		else if (name == @"stockhausen") {
			lineColor = [UIColor colorWithRed:0 green:0 blue:.78 alpha:1];
			backgroundColor = [UIColor colorWithRed:.73 green:1 blue:.78 alpha:1];
		}
		else {
			NSLog(@"The setting name for this grid is not registered.");
			lineColor = [UIColor colorWithRed:0 green:0 blue:.78 alpha:1];
			backgroundColor = [UIColor colorWithRed:.73 green:1 blue:.78 alpha:1];
		}
	}
	return self;
}

- (void) setToDefaultNumber: (int) number {
	if (number == 1) {
		self.name = @"I";
		self.size = 1;
		self.bloomSpeed = 8;
		self.wiltSpeed = 11;
		self.fundamentalFrequency0 = 61.74;  //Db
		self.fundamentalFrequency00 = 138.59;
		self.fundamentalFrequency1 = 138.59;
	}
	else if (number == 2) {
		self.name = @"II";
		self.size = 2;
		self.bloomSpeed = 4;
		self.wiltSpeed = 4;
		self.fundamentalFrequency0 = 41.20;  //E
		self.fundamentalFrequency00 = 164.81;
		self.fundamentalFrequency1 = 164.81;
	}
	else if (number == 3) {
		self.name = @"III";
		self.size = 4;
		self.bloomSpeed = 6;
		self.wiltSpeed = 6;
		self.fundamentalFrequency0 = 369.99;  //A
		self.fundamentalFrequency00 = 554.37;
		self.fundamentalFrequency1 = 554.37;
	}
	bladed = NO;
	angled = NO;
	bubbled = NO;
	doubleBubbled = NO;
}

- (void)dealloc {
	[name release];
	[lineColor release];
	[backgroundColor release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    // example
	[coder encodeValueOfObjCType:@encode(NSString) at:&name];
	NSLog(@"con");

	[coder encodeValueOfObjCType:@encode(UIColor) at:&lineColor];
	NSLog(@"codin");
	[coder encodeValueOfObjCType:@encode(UIColor) at:&backgroundColor];
	[coder encodeValueOfObjCType:@encode(int) at:&size];
	[coder encodeValueOfObjCType:@encode(int) at:&bloomSpeed];
	[coder encodeValueOfObjCType:@encode(int) at:&wiltSpeed];
	[coder encodeValueOfObjCType:@encode(float) at:&fundamentalFrequency0];
	[coder encodeValueOfObjCType:@encode(float) at:&fundamentalFrequency0];


    // do this for all the properties of the object you want to store
}

- (id)initWithCoder:(NSCoder *)coder {
    // example
    //  [coder decodeValueOfObjCType:@encode(NSInteger) at:&myInt];
    // do this for all the properties of the object you want to retrieve
	[coder encodeValueOfObjCType:@encode(NSString) at:&name];
	[coder encodeValueOfObjCType:@encode(UIColor) at:&lineColor];
	[coder encodeValueOfObjCType:@encode(UIColor) at:&backgroundColor];
	[coder encodeValueOfObjCType:@encode(int) at:&size];
	[coder encodeValueOfObjCType:@encode(int) at:&bloomSpeed];
	[coder encodeValueOfObjCType:@encode(int) at:&wiltSpeed];
	[coder encodeValueOfObjCType:@encode(float) at:&fundamentalFrequency0];
	[coder encodeValueOfObjCType:@encode(float) at:&fundamentalFrequency0];
	return self;
}

@end
