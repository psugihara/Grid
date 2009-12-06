//
//  Grid.h
//  Grid
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

#import <Foundation/Foundation.h>
#import "Preset.h"

@interface Grid : NSObject {
	UIColor					*lineColor;
	UIColor					*backgroundColor;
	NSInteger				lengthBetweenPoints; 
	NSInteger				numOfPointsAcross;
	NSInteger				numOfPointsDown;
	CGFloat					bloomSpeed;
	CGFloat					wiltSpeed;
	
	NSMutableArray			*points;
	CGPoint					gravitron;
}

@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, assign) CGPoint gravitron;
//These remaining properties are gathered from the settings.
@property (nonatomic) NSInteger lengthBetweenPoints;
@property (nonatomic) NSInteger numOfPointsAcross;
@property (nonatomic) NSInteger numOfPointsDown;
@property (nonatomic) CGFloat bloomSpeed;
@property (nonatomic) CGFloat wiltSpeed;

- (id)initWithGravitron:(CGPoint)gravitron andPreset:(Preset *)settings;
- (void)loadPreset:(Preset *)preset;
- (void)addPointsToArray:(NSMutableArray *)arrayOfPoints;
- (void)updatePositionOfPoints;
- (void)reset;

@end