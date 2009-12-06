//
//  DJMixer.m
//  ToneGenerator
//
//  Setup Created by arab stab on 5/07/09.
//  Copyright 2009 Aran Mulholland. All rights reserved.
//	Callback by Peter Sugihara
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

#import "DJMixer.h"
#define kSampleRate 44100.0f
#define kTwoRootTwelve (2^(1/12))
#define kWaveform (M_PI * 2.0f / kSampleRate)


#pragma mark Listeners


void propListener(void *					inClientData,
				  AudioSessionPropertyID	inID,
				  UInt32					inDataSize,
				  const void *				inData){
	printf("property listener\n");
	//RemoteIOPlayer *THIS = (RemoteIOPlayer*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange){		
	}
}

void rioInterruptionListener(void *inClientData, UInt32 inInterruption){
	printf("Session interrupted! --- %s ---", inInterruption == kAudioSessionBeginInterruption ? "Begin Interruption" : "End Interruption");
	
	if (inInterruption == kAudioSessionEndInterruption) {
		// make sure we are again the active session
		AudioSessionSetActive(true);
		//AudioOutputUnitStart(THIS->audioUnit);
	}
	if (inInterruption == kAudioSessionBeginInterruption) {
		//AudioOutputUnitStop(THIS->audioUnit);
    }
}


#pragma mark Callbacks

/** This 2 channel node generates tones */

// Dirty Channel
int sawPhase = 0;
int sawPhase1 = 0;
int phase = 0;
int phase1 = 0;
int grower = 0;


int combPlayCount = 0;

static OSStatus toneGeneratorMixerCallback(void							*inRefCon, 
										   AudioUnitRenderActionFlags	*ioActionFlags, 
										   const AudioTimeStamp			*inTimeStamp, 
										   UInt32						inBusNumber,
										   UInt32						inNumberFrames, //512 
										   AudioBufferList				*ioData) {  
	
	
	//get a reference to the dframeMixer class, we need this as we are outside the class
	//in frameust a straight C method.
	DJMixer *dframeMixer = (DJMixer *)inRefCon;
	UInt32 *frameBuffer = ioData->mBuffers[0].mData;
	if (inBusNumber == 0){
		float freq = dframeMixer.fundamentalFrequency0;
		float freq2 = dframeMixer.fundamentalFrequency00;

		//loop through the buffer and fill the frames
		for (int frame = 0; frame < inNumberFrames; frame++){
			float waves = 0;
			waves += sin(kWaveform * freq * phase);
			waves += sin(kWaveform * freq2 * phase);
			waves *= 32500/2; // <--------- make sure to divide by how many waves you're stacking
			frameBuffer[frame] = (SInt16)waves;
			frameBuffer[frame] += frameBuffer[frame]<<16;
			phase++;
		}
	}

	else if (inBusNumber == 1){
		//Calculations before the loop
		float shifter = kTwoRootTwelve ^ (12*(dframeMixer.octaveShift));
		float freq = dframeMixer.fundamentalFrequency1*shifter;
			
		for(int frame = 0; frame < inNumberFrames; frame++) {
			float waves = 0;
			waves += sin(kWaveform * freq * phase1);
			if (dframeMixer.bladed == YES) waves += 1.0f/(float)(kWaveform * sawPhase1);
			else waves += sin(kWaveform * freq * phase1);
			if (dframeMixer.bubbled == YES) waves += sin(kWaveform * freq * phase1)+grower;
			else waves += sin(kWaveform * freq * phase1);
			if (dframeMixer.doubleBubbled == YES) waves += sin(kWaveform * freq * phase1)+2*grower;
			else waves += sin(kWaveform * freq * phase1);
			if (dframeMixer.angled == YES) waves += sin(kWaveform * freq * (kTwoRootTwelve^5) * phase1);
			else waves += sin(kWaveform * freq * phase1);
			waves *= 32500/5;  // <--------- make sure to divide by how many waves you're stacking
			frameBuffer[frame] = (SInt16)waves;
			frameBuffer[frame] += frameBuffer[frame]<<16;

			phase1++;
			sawPhase1++;
			grower++;
			if (sawPhase1 >= freq) {
				sawPhase1 = 0;
			}
		}
	}
	
	if (grower > 4000) grower = 0;
	return 0;
}

static OSStatus masterFaderCallback(void *inRefCon, 
							    AudioUnitRenderActionFlags *ioActionFlags, 
								const AudioTimeStamp *inTimeStamp, 
								UInt32 inBusNumber, 
								UInt32 inNumberFrames, 
								AudioBufferList *ioData) {  
	
	//get self
	DJMixer *dframeMixer = (DJMixer *)inRefCon;
	OSStatus err = 0;
	//get the audio from the toneGenerator, we could directly connect them but this gives us a chance to get at the audio
	//to apply an effect
	err = AudioUnitRender(dframeMixer.toneGeneratorMixer, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, ioData);
	//apply master effect (if any)
	
	return err;
}

@implementation DJMixer

@synthesize toneGeneratorMixer;
@synthesize masterFaderMixer;
@synthesize fundamentalFrequency0, fundamentalFrequency00;
@synthesize fundamentalFrequency1;
@synthesize octaveShift;
@synthesize bladed, angled, bubbled, doubleBubbled;


//@synthesize loopOne;
//@synthesize loopTwo;

-(id)init{
	
	self = [super init];
//	
//	loopOne = [[InMemoryAudioFile alloc]init];
//	loopTwo = [[InMemoryAudioFile alloc]init];
//	[loopOne open:[[NSBundle mainBundle] pathForResource:@"funkBeats" ofType:@"wav"]];
//	[loopTwo open:[[NSBundle mainBundle] pathForResource:@"funk stabs 3" ofType:@"wav"]];
	fundamentalFrequency0 = 0;
	fundamentalFrequency1 = 0;
	[self initAudio];
	return self;
}

#pragma mark Volume Control

-(void)changeCrossFaderAmount:(float)volume{
	
	float inverseVolume = 1.0 - volume;
	
	float volumeChannelOne = 0.0; 
	float volumeChannelTwo = 0.0;
	
	if (volume > 0.5){
		volumeChannelOne = 1.0;
	}
	else{
		volumeChannelOne = volume * 2.0;		
	}
	
	if (inverseVolume > 0.5){
		volumeChannelTwo = 0.5;
	}
	else{
		volumeChannelTwo = inverseVolume * 1.0;		
	}
	
	//set the volume levels on the two input channels to the toneGenerator
	AudioUnitSetParameter(toneGeneratorMixer, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, 0, volumeChannelOne, 0);	
	AudioUnitSetParameter(toneGeneratorMixer, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, 1, volumeChannelTwo, 0);	
}

-(void)changeVolume:(float)volume {
	//set the volume levels on the two input channels to the toneGenerator
	AudioUnitSetParameter(output, kMultiChannelMixerParam_Volume, kAudioUnitScope_Output, 0, volume, 0);	
}

//-(void)play{
//	[loopOne play];
//	[loopTwo play];
//	
//}


#pragma mark Initialization

-(void)initAudio{

	/*
	 Getting the value of kAudioUnitProperty_ElementCount tells you how many elements you have in a scope. This happens to be 8 for this mixer.
	 If you want to increase it, you need to set this property. 
	 */
	// Initialize and configure the audio session, and add an interuption listener
    AudioSessionInitialize(NULL, NULL, rioInterruptionListener, self);
	
	//set the audio category
	UInt32 audioCategory = kAudioSessionCategory_LiveAudio;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
	
	UInt32 getAudioCategory = sizeof(audioCategory);
	AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &getAudioCategory, &getAudioCategory);
	
	if(getAudioCategory == kAudioSessionCategory_LiveAudio){
		NSLog(@"kAudioSessionCategory_LiveAudio");
	}
	else{
		NSLog(@"Could not get kAudioSessionCategory_LiveAudio");
	}
	
	
	//add a property listener
	AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, propListener, self);
	
	//set the buffer size as small as we can
	Float32 preferredBufferSize = .02;
	AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(preferredBufferSize), &preferredBufferSize);
	
	//set the audio session active
	AudioSessionSetActive(YES);
	
	//the descriptions for the components
	AudioComponentDescription toneGeneratorMixerDescription, masterFaderDescription, outputDescription;
	
	//the AUNodes
	AUNode toneGeneratorMixerNode, masterMixerNode;
	AUNode outputNode;
	
	//the graph
	OSErr err = noErr;
	err = NewAUGraph(&graph);
	NSAssert(err == noErr, @"Error creating graph.");	
	
	//the cross fader mixer
	toneGeneratorMixerDescription.componentFlags = 0;
	toneGeneratorMixerDescription.componentFlagsMask = 0;
	toneGeneratorMixerDescription.componentType = kAudioUnitType_Mixer;
	toneGeneratorMixerDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer;
	toneGeneratorMixerDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	err = AUGraphAddNode(graph, &toneGeneratorMixerDescription, &toneGeneratorMixerNode);
	NSAssert(err == noErr, @"Error creating mixer node.");	
	
	//the master mixer
	masterFaderDescription.componentFlags = 0;
	masterFaderDescription.componentFlagsMask = 0;
	masterFaderDescription.componentType = kAudioUnitType_Mixer;
	masterFaderDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer;
	masterFaderDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	err = AUGraphAddNode(graph, &masterFaderDescription, &masterMixerNode);
	NSAssert(err == noErr, @"Error creating mixer node.");
	
	//the output
	outputDescription.componentFlags = 0;
	outputDescription.componentFlagsMask = 0;
	outputDescription.componentType = kAudioUnitType_Output;
	outputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	outputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	err = AUGraphAddNode(graph, &outputDescription, &outputNode);
	NSAssert(err == noErr, @"Error creating output node.");
	
	err = AUGraphOpen(graph);
	NSAssert(err == noErr, @"Error opening graph.");
	
	//get the cross fader
	AUGraphNodeInfo(graph, toneGeneratorMixerNode, &toneGeneratorMixerDescription, &toneGeneratorMixer);
	//get the master fader
	AUGraphNodeInfo(graph, masterMixerNode, &masterFaderDescription, &masterFaderMixer);
	//get the output
	AUGraphNodeInfo(graph, outputNode, &outputDescription, &output);
	
	//the cross fader mixer
	AURenderCallbackStruct callbackToneGenerator;
	callbackToneGenerator.inputProc = toneGeneratorMixerCallback;
	//set the reference to "self" this becomes *inRefCon in the playback callback
	callbackToneGenerator.inputProcRefCon = self;
	
	//mixer channel 0
	err = AUGraphSetNodeInputCallback(graph, toneGeneratorMixerNode, 0, &callbackToneGenerator);
	NSAssert(err == noErr, @"Error setting render callback 0 Cross fader.");
	//mixer channel 1
	err = AUGraphSetNodeInputCallback(graph, toneGeneratorMixerNode, 1, &callbackToneGenerator);
	NSAssert(err == noErr, @"Error setting render callback 1 Cross fader.");
	
	// Set up the master fader callback
	AURenderCallbackStruct playbackCallbackStruct;
	playbackCallbackStruct.inputProc = masterFaderCallback;
	//set the reference to "self" this becomes *inRefCon in the playback callback
	playbackCallbackStruct.inputProcRefCon = self;
	
	err = AUGraphSetNodeInputCallback(graph, outputNode, 0, &playbackCallbackStruct);
	NSAssert(err == noErr, @"Error setting effects callback.");
			
	// Describe format
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
	
	//  Set the volume levels on the two input channels to the toneGenerator.
	//  The clean channel (0) is twice as loud.
	AudioUnitSetParameter(toneGeneratorMixer, 
								kMultiChannelMixerParam_Volume, 
								kAudioUnitScope_Input, 
								0, 1, 0);	
	AudioUnitSetParameter(toneGeneratorMixer, 
								kMultiChannelMixerParam_Volume, 
								kAudioUnitScope_Input, 
								1, 0.5, 0);
	
	//set the master fader input properties
	err = AudioUnitSetProperty(output, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting RIO input property.");
	
	//set the master fader input properties
	err = AudioUnitSetProperty(masterFaderMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting Master fader property.");

	//set the toneGenerator output properties
	err = AudioUnitSetProperty(toneGeneratorMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Output, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting output property format 00000.");
	
	
	//set the toneGenerator input properties
	err = AudioUnitSetProperty(toneGeneratorMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   0, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting property format 0erf;kl.");
	
	err = AudioUnitSetProperty(toneGeneratorMixer, 
							   kAudioUnitProperty_StreamFormat, 
							   kAudioUnitScope_Input, 
							   1, 
							   &audioFormat, 
							   sizeof(audioFormat));
	NSAssert(err == noErr, @"Error setting property format 1.");
	err = AUGraphInitialize(graph);
	NSAssert(err == noErr, @"Error initializing graph.");
	
	CAShow(graph); 
	
	err = AUGraphStart(graph);
	NSAssert(err == noErr, @"Error starting graph.");
}

- (void)dealloc {
	[super dealloc];
}
@end
