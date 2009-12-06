//
//  InMemoryAudioFile.m
//  HelloWorld
//
//  Created by Aran Mulholland on 22/02/09.
//  Copyright 2009 Aran Mulholland. All rights reserved.
//

#import "InMemoryAudioFile.h"

@implementation InMemoryAudioFile

//overide init method
- (id)init 
{ 
    [super init]; 
	//set the index
	packetIndex = 0;
	leftPacketIndex = 0;
	rightPacketIndex = 0;
	isPlaying = NO;
	return self;
}

- (void)dealloc {
	//release the AudioBuffer
	free(audioData);
    [super dealloc];
}

-(void)play{
	if(isPlaying){
		isPlaying = NO;
	}
	else{
		isPlaying = YES;
	}
}

//open and read a wav file
-(OSStatus)open:(NSString *)filePath{
	
	//print out the file path
	NSLog(@"FilePath: ");
	NSLog(filePath);
	
	//get a ref to the audio file, need one to open it
	CFURLRef audioFileURL = CFURLCreateFromFileSystemRepresentation (NULL, (const UInt8 *)[filePath cStringUsingEncoding:[NSString defaultCStringEncoding]] , strlen([filePath cStringUsingEncoding:[NSString defaultCStringEncoding]]), false);
	
	//open the audio file
	OSStatus result = AudioFileOpenURL (audioFileURL, 0x01, 0, &mAudioFile);
	//were there any errors reading? if so deal with them first
	if (result != noErr) {
		NSLog([NSString stringWithFormat:@"Could not open file: %s", filePath]);
		packetCount = -1;
	}
	//otherwise
	else{
		//get the file info
		[self getFileInfo];
		//how many packets read? (packets are the number of stereo samples in this case)
		//NSLog([NSString stringWithFormat:@"File Opened, packet Count: %d", packetCount]);
		
		UInt32 packetsRead = packetCount;
		OSStatus result = -1;
		
		//free the audioBuffer just in case it contains some data
		free(audioData);
		UInt32 numBytesRead = -1;
		//if we didn't get any packets dop nothing, nothing to read
		if (packetCount <= 0) { }
		//otherwise fill our in memory audio buffer with the whole file (i wouldnt use this with very large files btw)
		else{
			//allocate the buffer
			audioData = (UInt32 *)malloc(sizeof(UInt32) * packetCount);
			//read the packets
			result = AudioFileReadPackets (mAudioFile, false, &numBytesRead, NULL, 0, &packetsRead,  audioData); 
		}
		if (result==noErr){

			monoFloatDataLeft = (float *)malloc(sizeof(float) * packetCount);
			monoFloatDataRight = (float *)malloc(sizeof(float) * packetCount);
			
			
			leftAudioData = (SInt16 *)malloc(sizeof(SInt16) * packetCount);			
			rightAudioData = (SInt16 *)malloc(sizeof(SInt16) * packetCount);
			
			//now we need to copy the sample data
			UInt32 sample;
			SInt16 left;
			SInt16 right;
			
			for (UInt32 i = 0; i < packetCount; i++){ 
				
				sample = *(audioData + i);
				left = sample >> 16;
				right = sample;
				
				leftAudioData[i] = left;
				rightAudioData[i] = right;
				
				//turn it into the range -1.0 - 1.0
				monoFloatDataLeft[i] = (float)left / 32768.0;
				monoFloatDataRight[i] = (float)right / 32768.0;

				
			}
			
			//print out general info about  the file
			//NSLog([NSString stringWithFormat:@"Packets read from file: %d\n", packetsRead]);
			//NSLog([NSString stringWithFormat:@"Bytes read from file: %d\n", numBytesRead]);
			//for a stereo 32 bit per sample file this is ok
			//NSLog([NSString stringWithFormat:@"Sample count: %d\n", numBytesRead / 2]);
			//for a 32bit per stereo sample at 44100khz this is correct
			//NSLog([NSString stringWithFormat:@"Time in Seconds: %f.4\n", ((float)numBytesRead / 4.0) / 44100.0]);
		}
	}

	CFRelease (audioFileURL);     

	return result;
}


- (OSStatus) getFileInfo {
	
	OSStatus	result = -1;
	double duration;
	
	if (mAudioFile == nil){}
	else{
		UInt32 dataSize = sizeof packetCount;
		result = AudioFileGetProperty(mAudioFile, kAudioFilePropertyAudioDataPacketCount, &dataSize, &packetCount);
		if (result==noErr) {
			duration = ((double)packetCount * 2) / 44100;
		}
		else{
			packetCount = -1;
		}
	}
	return result;
}


//gets the next packet from the buffer, if we have reached the end of the buffer return 0
-(UInt32)getNextPacket{
	
	UInt32 returnValue = 0;
	
	//if the packetCount has gone to the end of the file, reset it. Audio will loop.
	if (packetIndex >= packetCount){
		packetIndex = 0;
		isPlaying = YES;
	}
	
	//i always like to set a variable and then return it during development so i can
	//see the value while debugging
	
	if(isPlaying){
		returnValue = audioData[packetIndex++];
		return returnValue;	
	}
	else{
		return 0;
	}

}


//gets the current index (where we are up to in the buffer)
-(SInt64)getIndex{
	return packetIndex;
}

-(void)reset{
	packetIndex = 0;
}

@end
