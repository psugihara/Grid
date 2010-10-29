//
//  gridView.m
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

#import "GridView.h"
#import "GridPoint.h"

@implementation GridView

@synthesize grid;

- (void)drawRect:(CGRect)rect {
	if (grid != nil) {
		[self drawLines];
//		[self drawDots];
	}
}

- (void) drawDots {
	CGContextRef gridContext = UIGraphicsGetCurrentContext();
	CGContextBeginPath(gridContext);

	for (GridPoint *gp in grid.points) {
		CGPoint point = gp.current;  //get the current point from the GridPoint object
		CGContextMoveToPoint(gridContext, point.x, point.y);
		CGContextAddArc(gridContext, point.x, point.y, 2, 0, 2*M_PI, false);
	}
	CGContextDrawPath(gridContext, kCGPathStroke);
}
- (void)drawLines {
	CGContextRef gridContext = UIGraphicsGetCurrentContext();
	CGContextBeginPath(gridContext);

	int count = 1;
	//Horizontal lines
	for (GridPoint *gp in grid.points) {
		CGPoint point = gp.current;  //get the current point from the GridPoint object
		if (count%grid.numOfPointsAcross == 1)  //if the point is the first on the line, begin a new subpath
			CGContextMoveToPoint(gridContext, point.x, point.y);
		else //if it isn't the first add it to the current path
			CGContextAddLineToPoint(gridContext, point.x, point.y);
		count ++;
	}
	
	//Vertical lines
	for (int i=0; i < grid.numOfPointsAcross; i++) {			//Draw as many verticals as there are points across.
		CGPoint point = [[grid.points objectAtIndex:i]current];	//Get the current point from the GridPoint object
		CGContextMoveToPoint(gridContext, point.x, point.y);	//and begin a new subpath.
		for (int j=1; j < grid.numOfPointsDown; j++) {
			int index = i+(j*grid.numOfPointsAcross);			//find the index of the next point and connect.
			CGPoint point = [[grid.points objectAtIndex:index]current];
			CGContextAddLineToPoint(gridContext, point.x, point.y);
		}
	}
	
	CGContextSetLineWidth(gridContext, 1);
	CGContextDrawPath(gridContext, kCGPathStroke);
}




- (void)dealloc {
	[grid release];
	[super dealloc];
}

@end
