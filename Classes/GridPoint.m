//
//  GridPoint.m
//  Grid
//
//	This class defines a GridPoint object with certain behaviors
//	relative to a center.
//
//  Created by Peter Sugihara on 5/29/09.
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

#import "GridPoint.h"


@implementation GridPoint

@synthesize current, bloomSpeed, wiltSpeed;

- (id)initWithX:(NSInteger)x andY:(NSInteger)y{
	self = [super init];
	if (self) {
		current = CGPointMake(x, y);
		original = CGPointMake(x, y);
	}
	return self;
}

- (void)shiftAroundCenter:(CGPoint)center {
	CGFloat centerToOriginal = [GridPoint distanceBetweenPoint:original point:center];
	CGFloat centerToCurrent = [GridPoint distanceBetweenPoint:current point:center];
	CGFloat offset = [GridPoint distanceBetweenPoint:original point:current];
	
	if (centerToOriginal < 80) {
		CGFloat shift = 60*bloomSpeed/centerToCurrent;
		if (current.x > center.x)
			current.x = current.x + shift;
		else
			current.x = current.x - shift;
		if (current.y > center.y)
			current.y = current.y + shift;
		else
			current.y = current.y - shift;
	}
	else if (offset > 10) {
		CGFloat shiftBack = 100*wiltSpeed/centerToCurrent;
		if (current.x < original.x)
			current.x = current.x + shiftBack;
		else
			current.x = current.x - shiftBack;
		if (current.y < original.y)
			current.y = current.y + shiftBack;
		else
			current.y = current.y - shiftBack;
	}
}
		

+ (CGFloat)distanceBetweenPoint:(CGPoint)point1 point:(CGPoint)point2 {
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrt(dx*dx + dy*dy);
}


- (void)reset {
	current = original;
}


- (void)dealloc {
	[super dealloc];
}

@end
