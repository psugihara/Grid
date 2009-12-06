//
//  Grid.m
//  SHSHSH
//
//  Created by Peter Sugihara on 5/27/09.
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

#import "Grid.h"
#import "GridPoint.h"

@implementation Grid


@synthesize lineColor, backgroundColor, points, gravitron, lengthBetweenPoints, numOfPointsAcross, numOfPointsDown, bloomSpeed, wiltSpeed;


- (id)initWithGravitron:(CGPoint)grav andPreset:(Preset *)preset {
	self = [super init];
	if (self) {
		[self loadPreset: preset];		
		gravitron = grav;
		
		NSMutableArray *pointsArray = [[NSMutableArray alloc] init];
		self.points = pointsArray;
		[pointsArray release];
		[self addPointsToArray:points];
	}
	return self;
}

- (void)loadPreset:(Preset *)preset {
	self.lineColor = preset.lineColor;
	self.backgroundColor = preset.backgroundColor;
	int size = preset.size;
	self.lengthBetweenPoints = 16*size;
	self.numOfPointsAcross = 320/lengthBetweenPoints + 1;
	self.numOfPointsDown = 432/lengthBetweenPoints;
	self.bloomSpeed = preset.bloomSpeed;
	self.wiltSpeed = preset.wiltSpeed;
	[preset release];
}

- (void)addPointsToArray:(NSMutableArray *)arrayOfPoints {
	for (int y = 0; y < numOfPointsDown; y++) {
		for (int x = 0; x < numOfPointsAcross; x++) {
			GridPoint *point = [[GridPoint alloc] initWithX: x*lengthBetweenPoints andY: y*lengthBetweenPoints];
			point.bloomSpeed = self.bloomSpeed;
			point.wiltSpeed = self.wiltSpeed;
			[arrayOfPoints addObject:point];
			[point release];
		}
	}
}

- (NSArray *)points {
	return points;
}

- (void)updatePositionOfPoints {
	for (GridPoint *point in points) {
		[point shiftAroundCenter:gravitron];
	}
}

//  Reset positions of the points back to original positions.
- (void)reset {
	for (GridPoint *point in points) {
		[point reset];
	}
}

- (void)dealloc {
	[points release];
	[super dealloc];
}

@end
