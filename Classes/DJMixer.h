//
//  DJMixer.h
//  CrossFader
//
//  Created by arab stab on 5/07/09.
//  Copyright 2009 Aran Mulholland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#include <AudioUnit/AudioUnit.h>
#import "AudioToolbox/AudioToolbox.h"
#import "InMemoryAudioFile.h"

@interface DJMixer : NSObject {
	int octaveShift;
	float		fundamentalFrequency0;
	float		fundamentalFrequency00; //The second channel 0 frequency;
	float		fundamentalFrequency1;
	BOOL		bladed;
	BOOL		angled;
	BOOL		bubbled;
	BOOL		doubleBubbled;
	
	//the audio output
	AudioUnit output;
	AudioStreamBasicDescription audioFormat;

	//the graph of audio connections
	AUGraph graph;

	//the audio unit nodes in the graph
	AudioUnit toneGeneratorMixer;
	AudioUnit masterFaderMixer;
	
//	InMemoryAudioFile *loopOne;
//	InMemoryAudioFile *loopTwo;
	
}

@property (nonatomic, assign) int octaveShift;
@property (nonatomic) float fundamentalFrequency0;
@property (nonatomic) float fundamentalFrequency00;
@property (nonatomic) float fundamentalFrequency1;
@property (nonatomic) BOOL bladed;
@property (nonatomic) BOOL angled;
@property (nonatomic) BOOL bubbled;
@property (nonatomic) BOOL doubleBubbled;
@property (nonatomic) AudioUnit toneGeneratorMixer;
@property (nonatomic) AudioUnit masterFaderMixer;
//@property (nonatomic, retain) InMemoryAudioFile *loopOne;
//@property (nonatomic, retain) InMemoryAudioFile *loopTwo;

-(void)initAudio;
-(void)changeCrossFaderAmount:(float)volume;
-(void)changeVolume:(float)volume;
//-(void)play;

@end
