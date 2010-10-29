//
//  Preset.m
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

#import "Preset.h"


@implementation Preset

@synthesize name, size, lineColor, backgroundColor, bloomSpeed, wiltSpeed, gravitron, fundamentalFrequency0, fundamentalFrequency00, fundamentalFrequency1, bladed, angled, bubbled, doubleBubbled;

- (id) init {
	self = [super init];
	if (self) {
		self.size = 2;
		self.bloomSpeed = 2;
		self.wiltSpeed = 2;
		self.gravitron = CGPointMake(550,550);  //Will render offscreen
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
		self.fundamentalFrequency00 = 220.0;
		self.fundamentalFrequency1 = 220.0;
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
	[coder encodeObject:self.name forKey:@"name"];
	[coder encodeObject:self.lineColor forKey:@"lineColor"];
	[coder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
	[coder encodeObject:[NSNumber numberWithInt:self.size] forKey:@"size"];
	[coder encodeObject:[NSNumber numberWithInt:self.bloomSpeed] forKey:@"bloomSpeed"];
	[coder encodeObject:[NSNumber numberWithInt:self.wiltSpeed] forKey:@"wiltSpeed"];
	CGPoint point = self.gravitron;
	NSValue *pointValue = [NSValue value:&point withObjCType:@encode(CGPoint)];
	[coder encodeObject:pointValue forKey:@"gravitron"];
	[coder encodeObject:[NSNumber numberWithFloat:self.fundamentalFrequency0] forKey:@"fundamentalFrequency0"];
	[coder encodeObject:[NSNumber numberWithFloat:self.fundamentalFrequency00] forKey:@"fundamentalFrequency00"];
	[coder encodeObject:[NSNumber numberWithFloat:self.fundamentalFrequency1] forKey:@"fundamentalFrequency1"];
	[coder encodeObject:[NSNumber numberWithBool:self.bladed] forKey:@"bladed"];
	[coder encodeObject:[NSNumber numberWithBool:self.angled] forKey:@"angled"];
	[coder encodeObject:[NSNumber numberWithBool:self.bubbled] forKey:@"bubbled"];
	[coder encodeObject:[NSNumber numberWithBool:self.doubleBubbled] forKey:@"doubleBubbled"];
}

- (id)initWithCoder:(NSCoder *)coder {
	self = [super init];
	if( self != nil ) {
		self.name = [coder decodeObjectForKey:@"name"];
		self.lineColor = [coder decodeObjectForKey:@"lineColor"];
		self.backgroundColor = [coder decodeObjectForKey:@"backgroundColor"];
		self.size = [[coder decodeObjectForKey:@"size"] intValue];
		self.bloomSpeed = [[coder decodeObjectForKey:@"bloomSpeed"] intValue];
		self.wiltSpeed = [[coder decodeObjectForKey:@"wiltSpeed"] intValue];
		NSValue *decodedValue = [coder decodeObjectForKey:@"gravitron"];	
		CGPoint point;
		[decodedValue getValue:&point];
		self.gravitron =  point;
		self.fundamentalFrequency0 = [[coder decodeObjectForKey:@"fundamentalFrequency0"] floatValue];
		self.fundamentalFrequency00 = [[coder decodeObjectForKey:@"fundamentalFrequency00"] floatValue];
		self.fundamentalFrequency1 = [[coder decodeObjectForKey:@"fundamentalFrequency1"] floatValue];
		self.bladed = [[coder decodeObjectForKey:@"bladed"] boolValue];
		self.angled = [[coder decodeObjectForKey:@"angled"] boolValue];
		self.bubbled = [[coder decodeObjectForKey:@"bubbled"] boolValue];
		self.doubleBubbled = [[coder decodeObjectForKey:@"doubleBubbled"] boolValue];
	}
	return self;
}

@end
